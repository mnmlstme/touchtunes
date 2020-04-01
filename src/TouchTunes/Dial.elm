module TouchTunes.Dial exposing
    ( Action(..)
    , Config
    , Tracking
    , update
    , view
    )

import Array as Array exposing (Array)
import Array.Extra exposing (indexedMapToList)
import CssModules as CssModules
import Debug exposing (log)
import Html exposing (Html)
import Html.Events.Extra.Pointer as Pointer
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
    = Start
    | Set Int
    | Finish
    | Cancel


type alias Config valueType msg =
    { options : Array valueType
    , viewValue : valueType -> Svg msg
    , segments : Int
    }


type alias Track =
    { originalIndex : Int
    , index : Int
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
        Start ->
            ( Just
                { originalIndex = i0
                , index = i0
                }
            , Nothing
            )

        Set i ->
            ( Just
                { originalIndex = i0
                , index = i
                }
            , Maybe.map onChange <|
                Array.get i config.options
            )

        Cancel ->
            ( Nothing
            , Maybe.map onChange <|
                Array.get i0 config.options
            )

        Finish ->
            ( Nothing
            , Nothing
            )


collarRadius =
    100.0


dialRadius =
    50.0


faceRadius =
    32.0


css =
    .toString <|
        CssModules.css "./TouchTunes/dial.css"
            { dial = "dial"
            , face = "face"
            , value = "value"
            , option = "option"
            , collar = "collar"
            , active = "active"
            }


view :
    Config valueType msg
    -> (Action -> msg)
    -> Tracking
    -> valueType
    -> Html msg
view config toMsg tracking value =
    let
        active =
            case tracking of
                Just _ ->
                    css .active

                Nothing ->
                    ""

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
                    [ if v == value then
                        css .value

                      else
                        css .option
                    ]
                , transform
                    [ Rotate (-1 * ri) 0 0
                    , Translate (dialRadius / 2.0 + collarRadius / 2.0) 0
                    , Rotate ri 0 0
                    , Scale 0.66 0.66
                    ]
                , Pointer.onDown (\_ -> Set i |> toMsg)
                , Pointer.onEnter (\_ -> Set i |> toMsg)
                , Pointer.onUp (\_ -> Finish |> toMsg)
                ]
                [ circle
                    [ r <| px faceRadius ]
                    []
                , g [ transform [ Scale 0.375 0.375 ] ]
                    [ config.viewValue v ]
                ]
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
            [ class [ css .collar, active ]
            , Pointer.onLeave (\_ -> Cancel |> toMsg)
            ]
          <|
            List.append
                [ circle
                    [ r <| px collarRadius ]
                    []
                ]
            <|
                indexedMapToList viewOption config.options
        , g
            [ class [ css .value ]
            , Pointer.onDown (\_ -> Start |> toMsg)
            ]
            [ circle
                [ class [ css .option ]
                , r <| px faceRadius
                ]
                []
            , g
                [ transform [ Scale 0.375 0.375 ] ]
                [ config.viewValue value ]
            ]
        ]
