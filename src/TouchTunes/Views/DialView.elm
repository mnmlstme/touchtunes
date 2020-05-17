module TouchTunes.Views.DialView exposing (view)

import Array as Array exposing (Array)
import Array.Extra exposing (indexedMapToList)
import Html exposing (Html)
import Html.Events.Extra.Pointer as Pointer
import List.Extra exposing (findIndex)
import Maybe.Extra
import String exposing (fromFloat)
import Svg exposing (Svg, circle, g, line, rect, svg)
import Svg.Attributes
    exposing
        ( class
        , cx
        , cy
        , height
        , r
        , rx
        , transform
        , viewBox
        , width
        , x
        , x1
        , x2
        , y
        , y1
        , y2
        )
import TouchTunes.Models.Dial as Dial exposing (Action(..), Dial)
import TouchTunes.Views.DialStyles exposing (css)
import Tuple exposing (pair)


collarRadius =
    100.0


dialRadius =
    50.0


faceRadius =
    32.0


view :
    Dial val msg
    -> (Action -> msg)
    -> Html msg
view dial toMsg =
    let
        { config, tracking } =
            dial

        theValue =
            Dial.transientValue dial

        segments =
            config.segments

        sect =
            360 // config.segments

        n =
            Array.length config.options

        viewOption i v =
            let
                ri =
                    toFloat ((2 * i - n + 1) * sect) / 2
            in
            g
                [ class
                    (if v == theValue then
                        css .value

                     else
                        css .option
                    )
                , transform
                    ("rotate("
                        ++ fromFloat (-1 * ri)
                        ++ ",0,0)"
                        ++ " translate("
                        ++ fromFloat (dialRadius / 2.0 + collarRadius / 2.0)
                        ++ ",0)"
                        ++ " rotate("
                        ++ fromFloat ri
                        ++ ",0,0)"
                        ++ " scale(0.66,0.66)"
                    )
                , Pointer.onEnter <| \_ -> toMsg (Set i)
                ]
                [ circle
                    [ r <| fromFloat faceRadius
                    ]
                    []
                , g
                    [ class (css .viewValue)
                    , transform "scale(0.375,0.375)"
                    ]
                    [ config.viewValue v ]
                ]
    in
    svg
        [ class
            (case dial.tracking of
                Just _ ->
                    css .dial ++ " " ++ css .active

                Nothing ->
                    css .dial
            )
        , height <| fromFloat (2.0 * collarRadius)
        , width <| fromFloat (2.0 * collarRadius)
        , viewBox
            (fromFloat (-1.0 * collarRadius)
                ++ " "
                ++ fromFloat (-1.0 * collarRadius)
                ++ " "
                ++ fromFloat (2.0 * collarRadius)
                ++ " "
                ++ fromFloat (2.0 * collarRadius)
            )
        , Pointer.onUp <| \_ -> toMsg Finish
        ]
        [ g
            [ class (css .collar)
            ]
          <|
            List.append
                [ circle
                    [ r <| fromFloat collarRadius
                    , Pointer.onOut <| \_ -> toMsg Cancel
                    ]
                    []
                ]
            <|
                indexedMapToList viewOption config.options
        , g
            [ class (css .value)
            , Pointer.onDown <| \_ -> toMsg Start
            ]
            [ circle
                [ r <| fromFloat faceRadius
                ]
                []
            , g
                [ class (css .viewValue)
                , transform "scale(0.5,0.5)"
                ]
                [ config.viewValue theValue ]
            ]
        ]