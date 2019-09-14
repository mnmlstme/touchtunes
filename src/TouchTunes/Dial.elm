module TouchTunes.Dial exposing (Config, view)

import Html exposing (Html)
import Svg exposing (Svg, circle, g, svg)
import Svg.Attributes
    exposing
        ( class
        , transform
        , height
        , width
        , r
        , cx
        , cy
        , x
        , y
        )
import CssModules exposing (css)


type alias Config valueType msg =
    { options : List valueType
    , viewValue : valueType -> Svg msg
    }


view : Config valueType msg -> valueType -> Html msg
view config value =
    let
        styles =
            css "./TouchTunes/dial.css"
                { dial = "dial"
                , window = "window"
                , spindle = "spindle"
                , value = "value"
                }

        dialRadius =
            50

        windowRadius =
            20

        spindleRadius =
            2
    in
        svg
            [ height <| String.fromInt (2 * dialRadius)
            , width <| String.fromInt (2 * dialRadius)
            ]
            [ circle
                [ class <| styles.toString .dial
                , r <| String.fromInt dialRadius
                , cx <| String.fromInt dialRadius
                , cy <| String.fromInt dialRadius
                ]
                []
            , g
                [ class <| styles.toString .value
                , transform <|
                    "translate("
                        ++ String.fromInt (dialRadius + spindleRadius + windowRadius)
                        ++ ","
                        ++ String.fromInt (dialRadius - windowRadius)
                        ++ ")"
                ]
                [ circle
                    [ class <| styles.toString .window
                    , r <| String.fromInt windowRadius
                    ]
                    []
                , config.viewValue value
                ]
            , circle
                [ class <| styles.toString .spindle
                , r <| String.fromInt spindleRadius
                , cx <| String.fromInt dialRadius
                , cy <| String.fromInt dialRadius
                ]
                []
            ]
