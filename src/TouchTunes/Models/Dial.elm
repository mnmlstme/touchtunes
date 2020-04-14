module TouchTunes.Models.Dial exposing
    ( Action(..)
    , Config
    , Dial
    , Tracking
    , init
    , update
    , value
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
import Maybe.Extra
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


type alias Config val msg =
    { options : Array val
    , viewValue : val -> Svg msg
    , segments : Int
    }


type alias Track =
    { originalIndex : Int
    , index : Int
    }


type alias Tracking =
    Maybe Track


type alias Dial val msg =
    { value : val
    , config : Config val msg
    , tracking : Tracking
    }


init : val -> Config val msg -> Dial val msg
init v config =
    Dial v config Nothing


value : Dial val msg -> val
value dial =
    dial.value


transientValue : Dial val msg -> val
transientValue dial =
    Maybe.withDefault dial.value <|
        Maybe.Extra.join <|
            Maybe.map (\t -> Array.get t.index dial.config.options) dial.tracking


update :
    Action
    -> Dial val msg
    -> Dial val msg
update dialAction dial =
    let
        i0 =
            case dial.tracking of
                Just theTrack ->
                    theTrack.originalIndex

                Nothing ->
                    Maybe.withDefault 0 <|
                        findIndex
                            ((==) dial.value)
                        <|
                            Array.toList dial.config.options
    in
    case dialAction of
        Start ->
            { dial
                | tracking =
                    Just
                        { originalIndex = i0
                        , index = i0
                        }
            }

        Set i ->
            { dial
                | tracking =
                    Just
                        { originalIndex = i0
                        , index = i
                        }
            }

        Cancel ->
            { dial | tracking = Nothing }

        Finish ->
            { dial
                | value = transientValue dial
                , tracking = Nothing
            }


collarRadius =
    100.0


dialRadius =
    50.0


faceRadius =
    32.0


css =
    .toString <|
        CssModules.css "./TouchTunes/Views/css/dial.css"
            { dial = "dial"
            , face = "face"
            , value = "value"
            , option = "option"
            , viewValue = "viewValue"
            , collar = "collar"
            , active = "active"
            }


view :
    Dial val msg
    -> (Action -> msg)
    -> Html msg
view dial toMsg =
    let
        { config, tracking } =
            dial

        theValue =
            transientValue dial

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
                    [ if v == theValue then
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
                , g
                    [ class [ css .viewValue ]
                    , transform [ Scale 0.375 0.375 ]
                    ]
                    [ config.viewValue v ]
                ]
    in
    svg
        [ class [ css .dial, active ]
        , height <| px (2.0 * collarRadius)
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
                [ r <| px faceRadius
                ]
                []
            , g
                [ class [ css .viewValue ]
                , transform [ Scale 0.5 0.5 ]
                ]
                [ config.viewValue theValue ]
            ]
        ]
