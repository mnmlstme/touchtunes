module TouchTunes.Dial exposing
    ( Action(..)
    , Config
    , Tracking
    , update
    , view
    )

import Array as Array exposing (Array)
import Array.Extra exposing (indexedMapToList)
import CssModules exposing (css)
import Debug exposing (log)
import Html exposing (Html)
import Html.Events
    exposing
        ( on
        , onMouseDown
        , onMouseOut
        , onMouseUp
        )
import Json.Decode as Decode exposing (Decoder, field, int)
import List.Extra exposing (findIndex)
import Maybe as Maybe exposing (withDefault)
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
import Tuple exposing (pair)


type Action
    = Start ( Int, Int )
    | Finish
    | Cancel
    | Drag ( Int, Int )


type alias Config valueType msg =
    { options : Array valueType
    , viewValue : valueType -> Svg msg
    , segments : Int
    }


type alias Track =
    { position : Int
    , originalIndex : Int
    , positionOffset : Int
    }


type alias Tracking =
    Maybe Track


mouseOffset : Decoder ( Int, Int )
mouseOffset =
    Decode.map2 pair
        (field "offsetX" int)
        (field "offsetY" int)


update :
    Config valueType msg
    -> (valueType -> msg)
    -> Tracking
    -> valueType
    -> Action
    -> ( Tracking, Maybe msg )
update config onChange tracking currentValue dialAction =
    let
        i0 =
            case tracking of
                Just theTrack ->
                    theTrack.originalIndex

                Nothing ->
                    withDefault 0 <|
                        log "findIndex" <|
                            findIndex
                                ((==) currentValue)
                            <|
                                Array.toList config.options
    in
    case dialAction of
        Start coord ->
            let
                y =
                    Tuple.second coord
            in
            ( Just
                { position = 0
                , originalIndex = i0
                , positionOffset = y
                }
            , Nothing
            )

        Drag coord ->
            let
                y =
                    Tuple.second coord

                offset =
                    case tracking of
                        Just theTrack ->
                            theTrack.positionOffset

                        Nothing ->
                            y

                rotation =
                    -2 * (y - offset)

                sect =
                    360 // config.segments

                shift =
                    log "shift" <|
                        floor <|
                            toFloat rotation
                                / toFloat sect
                                + 0.5

                selected =
                    Array.get (i0 + shift) config.options

                change =
                    case selected of
                        Just theValue ->
                            if theValue == currentValue then
                                Nothing

                            else
                                selected

                        Nothing ->
                            Nothing
            in
            ( Just
                (case tracking of
                    Just theTrack ->
                        { theTrack
                            | position = y - offset
                        }

                    Nothing ->
                        { position = 0
                        , originalIndex = i0
                        , positionOffset = offset
                        }
                )
            , Maybe.map onChange change
            )

        Finish ->
            ( Nothing
            , Nothing
            )

        Cancel ->
            ( Nothing
            , Maybe.map onChange <|
                Array.get i0 config.options
            )


view :
    Config valueType msg
    -> (Action -> msg)
    -> Tracking
    -> valueType
    -> Html msg
view config toMsg tracking value =
    let
        styles =
            css "./TouchTunes/dial.css"
                { dial = "dial"
                , face = "face"
                , value = "value"
                , option = "option"
                , tick = "tick"
                , collar = "collar"
                , thumb = "thumb"
                , active = "active"
                , track = "track"
                }

        active =
            case tracking of
                Just _ ->
                    " " ++ styles.toString .active

                Nothing ->
                    ""

        collarRadius =
            100

        dialRadius =
            50

        faceRadius =
            32

        segments =
            config.segments

        sect =
            360 // config.segments

        trackBottom =
            200

        trackTop =
            -200

        position =
            case tracking of
                Just theTrack ->
                    theTrack.position

                Nothing ->
                    0

        initialRotation =
            case tracking of
                Just theTrack ->
                    theTrack.originalIndex * sect

                Nothing ->
                    0

        rotation =
            initialRotation - 2 * position

        viewOption i v =
            let
                ri =
                    i * sect
            in
            g
                [ class <|
                    styles.toString <|
                        if v == value then
                            .value

                        else
                            .option
                , transform <|
                    "rotate("
                        ++ String.fromInt (-1 * ri)
                        ++ ") translate("
                        ++ String.fromInt (dialRadius // 2 + collarRadius // 2)
                        ++ ",0) rotate("
                        ++ String.fromInt (ri - rotation)
                        ++ ") scale(0.25, 0.25)"
                ]
                [ config.viewValue v ]
    in
    svg
        [ height <| String.fromInt (2 * collarRadius)
        , width <| String.fromInt (2 * collarRadius)
        , viewBox <|
            String.join " "
                [ String.fromInt (-1 * dialRadius)
                , String.fromInt (-1 * collarRadius)
                , String.fromInt (2 * collarRadius)
                , String.fromInt (2 * collarRadius)
                ]
        ]
        [ g
            [ class <|
                styles.toString .collar
                    ++ active
            , transform <|
                "rotate("
                    ++ String.fromInt rotation
                    ++ ")"
            ]
          <|
            List.append
                [ circle
                    [ r <| String.fromInt collarRadius ]
                    []
                ]
            <|
                indexedMapToList viewOption config.options
        , g [ class <| styles.toString .dial ]
            [ circle
                [ r <| String.fromInt dialRadius ]
                []
            , line
                [ class <| styles.toString .tick
                , x1 <| String.fromInt faceRadius
                , y1 "0"
                , x2 <| String.fromInt (dialRadius + 10)
                , y2 "0"
                ]
                []
            ]
        , g
            [ class <| styles.toString .value ]
            [ circle
                [ class <| styles.toString .face
                , r <| String.fromInt faceRadius
                ]
                []
            , g
                [ transform "scale(0.375, 0.375)" ]
                [ config.viewValue value ]
            ]
        , let
            halfThumbHeight =
                faceRadius

            thumbHeight =
                2 * halfThumbHeight

            thumbWidth =
                dialRadius - faceRadius

            halfThumbWidth =
                thumbWidth // 2
          in
          g
            [ class <| styles.toString .thumb ++ active
            , on "mousedown" <|
                Decode.map
                    (\( x, y ) -> Start ( x, y - faceRadius ) |> toMsg)
                    mouseOffset
            ]
            [ rect
                [ x <| String.fromInt (-1 * dialRadius)
                , y <| String.fromInt (position - halfThumbHeight)
                , height <| String.fromInt thumbHeight
                , width <| String.fromInt thumbWidth
                , rx <| String.fromInt halfThumbWidth
                ]
                []
            ]
        , g
            [ class <| styles.toString .track ++ active
            , on "mousemove" <|
                Decode.map
                    (\( x, y ) -> Drag ( x, y + trackTop ) |> toMsg)
                    mouseOffset
            , onMouseUp (Finish |> toMsg)
            , onMouseOut (Cancel |> toMsg)
            ]
            [ rect
                [ x <| String.fromInt (-1 * dialRadius)
                , y <| String.fromInt trackTop
                , height <| String.fromInt (trackBottom - trackTop)
                , width <| String.fromInt (dialRadius - faceRadius)
                , rx <| String.fromInt <| (dialRadius - faceRadius) // 2
                ]
                []
            ]
        ]
