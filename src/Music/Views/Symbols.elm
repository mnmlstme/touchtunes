module Music.Views.Symbols exposing
    ( Symbol
    , ViewBox
    , doubleFlat
    , doubleSharp
    , eighthRest
    , flat
    , halfRest
    , ledgerLine
    , leftAlign
    , natural
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
    , trebleClef
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


type alias Symbol =
    { viewbox : ViewBox
    , id : String
    }


type alias ViewBox =
    { x : Float
    , y : Float
    , width : Float
    , height : Float
    }



-- Symbol definitions for symbols in sprite from ./svg folder


trebleClef =
    Symbol (ViewBox 0 0 64 135) "tt-treble-clef"


wholeRest =
    Symbol (ViewBox 0 0 30 80) "tt-rest-whole"


halfRest =
    Symbol (ViewBox 0 0 30 80) "tt-rest-half"


quarterRest =
    Symbol (ViewBox 0 0 30 80) "tt-rest-quarter"


eighthRest =
    Symbol (ViewBox 0 0 40 80) "tt-rest-eighth"


noteheadClosed =
    Symbol (ViewBox 0 0 34 24) "tt-notehead-closed"


noteheadOpen =
    Symbol (ViewBox 0 0 34 24) "tt-notehead-open"


singleDot =
    Symbol (ViewBox 0 0 20 20) "tt-dot"


natural =
    Symbol (ViewBox 0 0 22 62) "tt-natural"


sharp =
    Symbol (ViewBox 0 0 22 62) "tt-sharp"


flat =
    Symbol (ViewBox 0 0 22 62) "tt-flat"


doubleSharp =
    Symbol (ViewBox 0 0 22 62) "tt-double-sharp"


doubleFlat =
    Symbol (ViewBox 0 0 22 62) "tt-double-flat"


ledgerLine =
    Symbol (ViewBox 0 0 60 12) "tt-ledger-line"


stemUp =
    Symbol (ViewBox 0 0 34 164) "tt-stem-up"


stemDown =
    Symbol (ViewBox 0 0 34 164) "tt-stem-down"


stemUp1Flag =
    Symbol (ViewBox 0 0 80 164) "tt-stem-up-1flag"


stemDown1Flag =
    Symbol (ViewBox 0 0 34 164) "tt-stem-down-1flag"



-- default view is centered; leftAlign and rightAlign adjust viewbox


leftAlign : Float -> Symbol -> Symbol
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


rightAlign : Float -> Symbol -> Symbol
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


view : Symbol -> Svg msg
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
