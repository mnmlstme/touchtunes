module Music.Views.SvgAsset exposing
    ( SvgAsset
    , ViewBox
    , eighthRest
    , flat
    , halfRest
    , ledgerLine
    , leftAlign
    , noteheadClosed
    , noteheadOpen
    , quarterRest
    , rightAlign
    , sharp
    , singleDot
    , stemDown
    , stemDown1Flag
    , stemUp
    , stemUp1Flag
    , view
    , wholeRest
    )

import String exposing (fromFloat)
import Svg exposing (Svg, use)
import Svg.Attributes
    exposing
        ( height
        , width
        , x
        , xlinkHref
        , y
        )


type alias SvgAsset =
    { viewbox : ViewBox
    , id : String
    }


type alias ViewBox =
    { x : Float
    , y : Float
    , width : Float
    , height : Float
    }



-- SvgAsset definitions for symbols in sprite from ./svg folder


wholeRest =
    SvgAsset (ViewBox 0 0 30 80) "tt-rest-whole"


halfRest =
    SvgAsset (ViewBox 0 0 30 80) "tt-rest-half"


quarterRest =
    SvgAsset (ViewBox 0 0 30 80) "tt-rest-quarter"


eighthRest =
    SvgAsset (ViewBox 0 0 40 80) "tt-rest-eighth"


noteheadClosed =
    SvgAsset (ViewBox 0 0 34 24) "tt-notehead-closed"


noteheadOpen =
    SvgAsset (ViewBox 0 0 34 24) "tt-notehead-open"


singleDot =
    SvgAsset (ViewBox 0 0 20 20) "tt-dot"


sharp =
    SvgAsset (ViewBox 0 0 22 62) "tt-sharp"


flat =
    SvgAsset (ViewBox 0 0 22 62) "tt-flat"


ledgerLine =
    SvgAsset (ViewBox 0 0 60 12) "tt-ledger-line"


stemUp =
    SvgAsset (ViewBox 0 0 34 164) "tt-stem-up"


stemDown =
    SvgAsset (ViewBox 0 0 34 164) "tt-stem-down"


stemUp1Flag =
    SvgAsset (ViewBox 0 0 80 164) "tt-stem-up-1flag"


stemDown1Flag =
    SvgAsset (ViewBox 0 0 34 164) "tt-stem-down-1flag"



-- default view is centered; leftAlign and rightAlign adjust viewbox


leftAlign : Float -> SvgAsset -> SvgAsset
leftAlign xOffset asset =
    let
        box =
            asset.viewbox

        -- a new box whose left edge is x - xOffset
        newBox =
            { box
                | x = box.x - xOffset - 0.5 * box.width
            }
    in
    { asset | viewbox = newBox }


rightAlign : Float -> SvgAsset -> SvgAsset
rightAlign xOffset asset =
    let
        box =
            asset.viewbox

        -- a new box whose right edge is x - xOffset
        newBox =
            { box
                | x = box.x - xOffset + 1.5 * box.width
            }
    in
    { asset | viewbox = newBox }


view : SvgAsset -> Svg msg
view asset =
    let
        box =
            asset.viewbox

        xOffset =
            -0.5 * box.width - box.x

        yOffset =
            -0.5 * box.height - box.y
    in
    use
        [ xlinkHref <| "#" ++ asset.id
        , x <| fromFloat xOffset
        , y <| fromFloat yOffset
        , height <| fromFloat box.height
        , width <| fromFloat box.width
        ]
        []
