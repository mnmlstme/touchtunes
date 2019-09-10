-- Icon.SvgAsset.elm
-- after https://github.com/cultureamp/babel-elm-assets-plugin/tree/1.0.1#advanced-configuration


module Icon.SvgAsset exposing (..)

import String exposing (fromFloat)
import Array
import Svg
    exposing
        ( Svg
        , use
        )
import Svg.Attributes
    exposing
        ( x
        , y
        , width
        , height
        , xlinkHref
        )


type alias SvgAsset =
    { id : String
    , viewBox : String
    }


type alias ViewBox =
    { x : Float
    , y : Float
    , height : Float
    , width : Float
    }


svgAsset : String -> SvgAsset
svgAsset path =
    -- these placeholder values are replaced by Webpack at build time
    { id = "elm-svg-asset-placeholder"
    , viewBox = "0 0 0 0"
    }


makeViewBox : ViewBox -> String
makeViewBox box =
    String.join " " <|
        List.map
            fromFloat
            [ box.x, box.y, box.width, box.height ]


dimensions : SvgAsset -> ViewBox
dimensions asset =
    let
        strings =
            String.split " " asset.viewBox

        parse s =
            Maybe.withDefault 0 (String.toFloat s)

        floats =
            Array.fromList (List.map parse strings)

        item n =
            Maybe.withDefault 0 (Array.get n floats)
    in
        { x = item 0
        , y = item 1
        , width = item 2
        , height = item 3
        }


leftAlign : Float -> SvgAsset -> SvgAsset
leftAlign xOffset asset =
    let
        box =
            dimensions asset

        -- a new box whose center is x - xOffset
        newBox =
            { box
                | x = box.x - xOffset - 0.5 * box.width
            }
    in
        { id = asset.id
        , viewBox = makeViewBox newBox
        }


rightAlign : Float -> SvgAsset -> SvgAsset
rightAlign xOffset asset =
    let
        box =
            dimensions asset

        -- a new box whose center is x - xOffset
        newBox =
            { box
                | x = box.x - xOffset + 1.5 * box.width
            }
    in
        { id = asset.id
        , viewBox = makeViewBox newBox
        }


view : SvgAsset -> Svg msg
view asset =
    let
        box =
            dimensions asset

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
