module TouchTunes.Dial exposing (Config, Interaction, view)

import Array as Array exposing (Array)
import Array.Extra exposing (indexedMapToList)
import CssModules exposing (css)
import Html exposing (Html)
import Html.Events
    exposing
        ( on
        , onMouseDown
        , onMouseOut
        , onMouseUp
        )
import Json.Decode as Decode exposing (Decoder, field, int)
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
import TouchTunes.Action exposing (DialAction(..))
import Tuple exposing (pair)


type alias Interaction =
    { position : Int
    , originalIndex : Int
    , positionOffset : Int
    }


type alias Config valueType =
    { options : Array valueType
    , viewValue : valueType -> Svg (DialAction valueType)
    , segments : Int
    }


mouseOffset : Decoder ( Int, Int )
mouseOffset =
    Decode.map2 pair
        (field "offsetX" int)
        (field "offsetY" int)


view :
    ( Config valueType, Maybe Interaction )
    -> valueType
    -> Html (DialAction valueType)
view ( config, interaction ) value =
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
            case interaction of
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
            case interaction of
                Just theInteraction ->
                    theInteraction.position

                Nothing ->
                    0

        initialRotation =
            case interaction of
                Just theInteraction ->
                    theInteraction.originalIndex * sect

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
                    (\( x, y ) -> Start ( x, y - faceRadius ))
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
                    (\( x, y ) -> Drag ( x, y + trackTop ))
                    mouseOffset
            , onMouseUp Finish
            , onMouseOut Cancel
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
