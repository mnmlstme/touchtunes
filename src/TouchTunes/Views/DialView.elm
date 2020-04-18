module TouchTunes.Views.DialView exposing (view)

import Array as Array exposing (Array)
import Array.Extra exposing (indexedMapToList)
import Html.Styled exposing (Html)
import Html.Styled.Events as Events
import List.Extra exposing (findIndex)
import Maybe.Extra
import String exposing (fromFloat)
import Svg.Styled exposing (Svg, circle, g, line, rect, svg)
import Svg.Styled.Attributes
    exposing
        ( class
        , css
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
import TouchTunes.Views.DialStyles as Styles
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
                [ css
                    [ if v == theValue then
                        Styles.value

                      else
                        Styles.option
                    ]
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
                , Events.onMouseDown <| toMsg <| Set i
                , Events.onMouseEnter <| toMsg <| Set i
                , Events.onMouseUp <| toMsg Finish
                ]
                [ circle
                    [ css [ Styles.optionCircle ]
                    , r <| fromFloat faceRadius
                    ]
                    []
                , g
                    [ css [ Styles.viewValue ]
                    , transform "scale(0.375,0.375)"
                    ]
                    [ config.viewValue v ]
                ]
    in
    svg
        [ css
            [ case dial.tracking of
                Just _ ->
                    Styles.dialActive

                Nothing ->
                    Styles.dial
            ]
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
        ]
        [ g
            [ css
                [ case dial.tracking of
                    Just _ ->
                        Styles.collarActive

                    Nothing ->
                        Styles.collar
                ]
            , Events.onMouseLeave <| toMsg Cancel
            ]
          <|
            List.append
                [ circle
                    [ css [ Styles.collarCircle ], r <| fromFloat collarRadius ]
                    []
                ]
            <|
                indexedMapToList viewOption config.options
        , g
            [ css [ Styles.value ]
            , Events.onMouseDown <| toMsg Start
            ]
            [ circle
                [ css [ Styles.valueCircle ]
                , r <| fromFloat faceRadius
                ]
                []
            , g
                [ css [ Styles.viewValue ]
                , transform "scale(0.5,0.5)"
                ]
                [ config.viewValue theValue ]
            ]
        ]
