module TouchTunes.Views.DialView exposing (view)

import Array as Array exposing (Array)
import Array.Extra exposing (indexedMapToList)
import Debug exposing (log)
import Html exposing (Html, div, li, span, ul)
import Html.Attributes exposing (class, style)
import Html.Events
import Html.Events.Extra.Mouse as Mouse
import Html.Events.Extra.Pointer as Pointer
import Json.Decode as Json exposing (Decoder, at, field, float, int, succeed)
import List.Extra exposing (findIndex)
import Maybe.Extra
import String exposing (fromFloat)
import Svg exposing (Svg, circle, g, line, path, rect, svg)
import Svg.Attributes as SvgAttr
    exposing
        ( cx
        , cy
        , d
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


type alias Vector =
    { r : Float, theta : Float }


toVector : Float -> Float -> Int -> Int -> Vector
toVector xOffset yOffset w h =
    let
        cx =
            w // 2

        cy =
            h // 2

        fromCenter =
            ( xOffset - toFloat cx, toFloat cy - yOffset )

        ( radius, radians ) =
            toPolar fromCenter
    in
    { r = radius, theta = radians * 180.0 / pi }


decodeVector : Decoder Vector
decodeVector =
    Json.map4
        toVector
        (field "offsetX" float)
        (field "offsetY" float)
        (at [ "currentTarget", "clientWidth" ] int)
        (at [ "currentTarget", "clientHeight" ] int)


onVectorMove : (Vector -> msg) -> Html.Attribute msg
onVectorMove message =
    Html.Events.on "pointermove" <|
        Json.map message decodeVector


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

        rmid =
            40.0

        viewOption i v =
            let
                theta =
                    degrees <| toFloat ((2 * i - n + 1) * sect) / 2
            in
            li
                [ class <| css .option
                , style "left" <| fromFloat (50.0 + rmid * cos theta) ++ "%"
                , style "top" <| fromFloat (50.0 - rmid * sin theta) ++ "%"
                ]
                [ span
                    [ class <| css .viewValue
                    ]
                    [ config.viewValue v ]
                ]

        viewSector i =
            let
                theta0 =
                    degrees <| toFloat ((2 * i - n) * sect) / 2

                theta1 =
                    degrees <| toFloat ((2 * i - n + 2) * sect) / 2

                classList =
                    List.append
                        [ css .sector ]
                        (Maybe.withDefault
                            []
                         <|
                            Maybe.map
                                (\t ->
                                    if t.index == i then
                                        [ css .active ]

                                    else
                                        []
                                )
                                tracking
                        )
            in
            path
                [ SvgAttr.class <| String.join " " classList
                , d <|
                    String.join " "
                        [ "M"
                        , fromFloat <| 40.0 * cos theta0
                        , fromFloat <| -40.0 * sin theta0
                        , "L"
                        , fromFloat <| 100.0 * cos theta0
                        , fromFloat <| -100.0 * sin theta0
                        , "A 100 100 0 0 0"
                        , fromFloat <| 100.0 * cos theta1
                        , fromFloat <| -100.0 * sin theta1
                        , "L"
                        , fromFloat <| 40.0 * cos theta1
                        , fromFloat <| -40.0 * sin theta1
                        , "A 50 50 0 0 1"
                        , fromFloat <| 40.0 * cos theta0
                        , fromFloat <| -40.0 * sin theta0
                        , "Z"
                        ]
                ]
                []

        mapVector : Vector -> Maybe Int
        mapVector vec =
            let
                i =
                    round <| vec.theta / toFloat sect + toFloat n / 2.0 - 0.5
            in
            if vec.r > 20 && i >= 0 && i < n then
                Just i

            else
                Nothing

        events =
            case tracking of
                Just _ ->
                    [ onVectorMove (mapVector >> Drag >> toMsg)
                    , Pointer.onUp (\_ -> Finish |> toMsg)
                    , Pointer.onCancel (\_ -> Cancel |> toMsg)
                    ]

                Nothing ->
                    [ Pointer.onDown (\_ -> Start |> toMsg) ]
    in
    div
        (case tracking of
            Just _ ->
                [ class <| css .dial ++ " " ++ css .active
                ]

            Nothing ->
                [ class (css .dial)
                ]
        )
        [ svg
            (List.append
                [ height <| fromFloat (2.0 * collarRadius) ++ "px"
                , width <| fromFloat (2.0 * collarRadius) ++ "px"
                , viewBox "-100 -100 200 200"
                ]
                events
            )
            [ g
                [ SvgAttr.class (css .collar)
                ]
              <|
                List.append
                    [ circle
                        [ SvgAttr.class (css .outer)
                        , cx "0"
                        , cy "0"
                        , r "99"
                        ]
                        []
                    ]
                <|
                    indexedMapToList
                        (\i _ -> viewSector i)
                        config.options
            , circle
                [ SvgAttr.class (css .ring)
                , cx "0"
                , cy "0"
                , r "36"
                ]
                []
            , circle
                [ SvgAttr.class (css .inner)
                , cx "0"
                , cy "0"
                , r "28"
                ]
                []
            ]
        , ul
            [ class (css .collar) ]
          <|
            indexedMapToList viewOption config.options
        , div
            [ class (css .value)
            ]
            [ span [ class <| css .viewValue ]
                [ config.viewValue theValue ]
            ]
        ]
