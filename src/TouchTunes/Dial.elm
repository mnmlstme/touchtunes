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
import Html.Events.Extra.Touch as Touch
import Json.Decode as Decode exposing (Decoder, field, int)
import List.Extra exposing (findIndex)
import Maybe as Maybe exposing (withDefault)
import Tuple exposing (pair)
import TypedSvg exposing (circle, g, line, rect, svg)
import TypedSvg.Attributes
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
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Transform(..), px)


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


touchCoordinates : Touch.Event -> ( Float, Float )
touchCoordinates touchEvent =
    List.head touchEvent.changedTouches
        |> Maybe.map .clientPos
        |> Maybe.withDefault ( 0, 0 )


mouseCoordinates : Mouse.Event -> ( Float, Float )
mouseCoordinates mouseEvent =
    mouseEvent.offsetPos


view :
    Config valueType msg
    -> (Action -> msg)
    -> Tracking
    -> valueType
    -> Html msg
view config toMsg tracking value =
    let
        style =
            .toString <|
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
                    style .active

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

        adjustThumbPosition ( x, y ) =
            ( x, y - faceRadius )

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
                    toFloat (i * sect)
            in
            g
                [ class
                    [ style <|
                        if v == value then
                            .value

                        else
                            .option
                    ]
                , transform
                    [ Rotate (-1 * ri) 0 0
                    , Translate (dialRadius / 2.0 + collarRadius / 2.0) 0
                    , Rotate (ri - toFloat rotation) 0 0
                    , Scale 0.25 0.25
                    ]
                ]
                [ config.viewValue v ]
    in
    svg
        [ height <| px (2.0 * collarRadius)
        , width <| px (2.0 * collarRadius)
        , viewBox
            (-1.0 * dialRadius)
            (-1.0 * collarRadius)
            (2.0 * collarRadius)
            (2.0 * collarRadius)
        ]
        [ g
            [ class [ style .collar, active ]
            , transform [ Rotate (toFloat rotation) 0 0 ]
            ]
          <|
            List.append
                [ circle
                    [ r <| px collarRadius ]
                    []
                ]
            <|
                indexedMapToList viewOption config.options
        , g [ class [ style .dial ] ]
            [ circle
                [ r <| px dialRadius ]
                []
            , line
                [ class [ style .tick ]
                , x1 <| px faceRadius
                , y1 <| px 0
                , x2 <| px (dialRadius + 10)
                , y2 <| px 0
                ]
                []
            ]
        , g
            [ class [ style .value ] ]
            [ circle
                [ class [ style .face ]
                , r <| px faceRadius
                ]
                []
            , g
                [ transform [ Scale 0.375 0.375 ] ]
                [ config.viewValue value ]
            ]
        , g
            [ class [ style .track, active ]

            -- , Mouse.onMove <|
            --     mouseCoordinates
            --         >> adjustDragPosition
            --         >> Drag
            --         >> toMsg
            -- , Mouse.onUp (\event -> Finish |> toMsg)
            -- , Mouse.onOut (\event -> Cancel |> toMsg)
            ]
            [ rect
                [ x <| px (-1.0 * dialRadius)
                , y <| px trackTop
                , height <| px (trackBottom - trackTop)
                , width <| px (dialRadius - faceRadius)
                , rx <| px ((dialRadius - faceRadius) / 2.0)
                ]
                []
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
            [ class [ style .thumb, active ]

            -- , Mouse.onDown <|
            --     mouseCoordinates
            --         >> adjustStartPosition
            --         >> Start
            --         >> toMsg
            , Touch.onStart <|
                touchCoordinates
                    >> adjustThumbPosition
                    >> Start
                    >> toMsg
            , Touch.onMove <|
                touchCoordinates
                    >> adjustThumbPosition
                    >> Drag
                    >> toMsg
            , Touch.onEnd (\event -> Finish |> toMsg)
            ]
            [ rect
                [ x <| px (-1.0 * dialRadius)
                , y <| px (position - halfThumbHeight)
                , height <| px thumbHeight
                , width <| px thumbWidth
                , rx <| px halfThumbWidth
                ]
                []
            ]
        ]
