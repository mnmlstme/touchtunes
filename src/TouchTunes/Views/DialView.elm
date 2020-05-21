module TouchTunes.Views.DialView exposing (view)

import Array as Array exposing (Array)
import Array.Extra exposing (indexedMapToList)
import Html exposing (Html, div, li, span, ul)
import Html.Attributes exposing (class, style)
import Html.Events.Extra.Pointer as Pointer
import List.Extra exposing (findIndex)
import Maybe.Extra
import String exposing (fromFloat)
import Svg exposing (Svg, circle, g, line, rect, svg)
import Svg.Attributes
    exposing
        ( cx
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

        cx =
            collarRadius

        cy =
            collarRadius

        r =
            dialRadius / 2.0 + collarRadius / 2.0

        viewOption i v =
            let
                ri =
                    toFloat ((2 * i - n + 1) * sect) / 2
            in
            li
                [ class <| css .option
                , style "left" <| fromFloat (cx + r * (sin <| degrees ri)) ++ "px"
                , style "top" <| fromFloat (cy + r * (cos <| degrees ri)) ++ "px"
                ]
                [ span
                    [ class <| css .viewValue
                    , Pointer.onEnter <| \_ -> toMsg (Set i)
                    ]
                    [ config.viewValue v ]
                ]
    in
    div
        [ class
            (case dial.tracking of
                Just _ ->
                    css .dial ++ " " ++ css .active

                Nothing ->
                    css .dial
            )
        , Pointer.onUp <| \_ -> toMsg Finish
        ]
        [ ul
            [ class (css .collar)
            ]
          <|
            indexedMapToList viewOption config.options
        , div
            [ class (css .value)
            , Pointer.onDown <| \_ -> toMsg Start
            ]
            [ span [ class <| css .viewValue ]
                [ config.viewValue theValue ]
            ]
        ]
