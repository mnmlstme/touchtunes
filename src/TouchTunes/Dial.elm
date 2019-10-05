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
import Html.Events.Extra.Mouse as Mouse
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
    = Start ( Float, Float )
    | Finish
    | Cancel
    | Drag ( Float, Float )


type alias Config valueType msg =
    { options : Array valueType
    , viewValue : valueType -> Svg msg
    , segments : Int
    }


type alias Track =
    { position : Float
    , originalIndex : Int
    , positionOffset : Float
    }


type alias Tracking =
    Maybe Track


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
                ( _, y ) =
                    coord
            in
            ( Just
                { position = 0.0
                , originalIndex = i0
                , positionOffset = y
                }
            , Nothing
            )

        Drag coord ->
            let
                ( _, y ) =
                    coord

                offset =
                    case tracking of
                        Just theTrack ->
                            theTrack.positionOffset

                        Nothing ->
                            y

                rotation =
                    -2.0 * (y - offset)

                sect =
                    360 // config.segments

                shift =
                    log "shift" <|
                        floor <|
                            rotation
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
                        { position = 0.0
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
            100.0

        dialRadius =
            50.0

        faceRadius =
            32.0

        segments =
            config.segments

        sect =
            360 // config.segments

        trackBottom =
            200.0

        trackTop =
            -200.0

        position =
            case tracking of
                Just theTrack ->
                    theTrack.position

                Nothing ->
                    0.0

        initialRotation =
            case tracking of
                Just theTrack ->
                    theTrack.originalIndex * sect

                Nothing ->
                    0

        rotation =
            initialRotation - 2 * floor position

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
                        ++ String.fromFloat (dialRadius / 2.0 + collarRadius / 2.0)
                        ++ ",0) rotate("
                        ++ String.fromInt (ri - rotation)
                        ++ ") scale(0.25, 0.25)"
                ]
                [ config.viewValue v ]
    in
    svg
        [ height <| String.fromFloat (2.0 * collarRadius)
        , width <| String.fromFloat (2.0 * collarRadius)
        , viewBox <|
            String.join " "
                [ String.fromFloat (-1.0 * dialRadius)
                , String.fromFloat (-1.0 * collarRadius)
                , String.fromFloat (2.0 * collarRadius)
                , String.fromFloat (2.0 * collarRadius)
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
                    [ r <| String.fromFloat collarRadius ]
                    []
                ]
            <|
                indexedMapToList viewOption config.options
        , g [ class <| styles.toString .dial ]
            [ circle
                [ r <| String.fromFloat dialRadius ]
                []
            , line
                [ class <| styles.toString .tick
                , x1 <| String.fromFloat faceRadius
                , y1 "0"
                , x2 <| String.fromFloat (dialRadius + 10)
                , y2 "0"
                ]
                []
            ]
        , g
            [ class <| styles.toString .value ]
            [ circle
                [ class <| styles.toString .face
                , r <| String.fromFloat faceRadius
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
                2.0 * halfThumbHeight

            thumbWidth =
                dialRadius - faceRadius

            halfThumbWidth =
                thumbWidth / 2.0
          in
          g
            [ class <| styles.toString .thumb ++ active
            , Mouse.onDown
                (\event ->
                    let
                        ( x, y ) =
                            event.offsetPos
                    in
                    Start ( x, y - faceRadius ) |> toMsg
                )
            ]
            [ rect
                [ x <| String.fromFloat (-1.0 * dialRadius)
                , y <| String.fromFloat (position - halfThumbHeight)
                , height <| String.fromFloat thumbHeight
                , width <| String.fromFloat thumbWidth
                , rx <| String.fromFloat halfThumbWidth
                ]
                []
            ]
        , g
            [ class <| styles.toString .track ++ active
            , Mouse.onMove
                (\event ->
                    let
                        ( x, y ) =
                            event.offsetPos
                    in
                    Drag ( x, y + trackTop ) |> toMsg
                )
            , Mouse.onUp (\event -> Finish |> toMsg)
            , Mouse.onOut (\event -> Cancel |> toMsg)
            ]
            [ rect
                [ x <| String.fromFloat (-1.0 * dialRadius)
                , y <| String.fromFloat trackTop
                , height <| String.fromFloat (trackBottom - trackTop)
                , width <| String.fromFloat (dialRadius - faceRadius)
                , rx <| String.fromFloat <| (dialRadius - faceRadius) / 2.0
                ]
                []
            ]
        ]
