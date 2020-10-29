module TouchTunes.Views.DialView exposing (view)

import Array as Array exposing (Array)
import Array.Extra exposing (indexedMapToList)
import Debug exposing (log)
import Html exposing (Html)
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
        ( class
        , cx
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

                rtext =
                    collarRadius - 20.0
            in
            g
                [ class <| css .option
                , transform <|
                    "translate("
                        ++ fromFloat (rtext * cos theta)
                        ++ ","
                        ++ fromFloat (-1.0 * rtext * sin theta)
                        ++ ")"
                ]
                [ g
                    [ class <| css .viewValue
                    , transform <|
                        "translate("
                            ++ fromFloat (-0.5 * faceRadius)
                            ++ ","
                            ++ fromFloat (-0.5 * faceRadius)
                            ++ ")"
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
                        , fromFloat <| rmid * cos theta0
                        , fromFloat <| -rmid * sin theta0
                        , "L"
                        , fromFloat <| collarRadius * cos theta0
                        , fromFloat <| -collarRadius * sin theta0
                        , "A 100 100 0 0 0"
                        , fromFloat <| collarRadius * cos theta1
                        , fromFloat <| -collarRadius * sin theta1
                        , "L"
                        , fromFloat <| rmid * cos theta1
                        , fromFloat <| -rmid * sin theta1
                        , "A 50 50 0 0 1"
                        , fromFloat <| rmid * cos theta0
                        , fromFloat <| -rmid * sin theta0
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
    svg
        (List.append
            events
            [ class <|
                case log "dial tracking: " tracking of
                    Just _ ->
                        css .dial ++ " " ++ css .active

                    Nothing ->
                        css .dial
            , height <| fromFloat (2.0 * collarRadius) ++ "px"
            , width <| fromFloat (2.0 * collarRadius) ++ "px"
            , viewBox "-100 -100 200 200"
            ]
        )
        [ g []
            [ g [ class (css .collar) ] <|
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
                [ class (css .ring)
                , cx "0"
                , cy "0"
                , r "36"
                ]
                []
            , circle
                [ class (css .inner)
                , cx "0"
                , cy "0"
                , r "28"
                ]
                []
            ]
        , g
            [ class (css .collar) ]
          <|
            indexedMapToList viewOption config.options
        , g
            [ class (css .value)
            , transform <|
                "translate("
                    ++ fromFloat (-0.5 * faceRadius)
                    ++ ","
                    ++ fromFloat (-0.5 * faceRadius)
                    ++ ")"
            ]
            [ g [ class <| css .viewValue ]
                [ config.viewValue theValue ]
            ]
        ]
