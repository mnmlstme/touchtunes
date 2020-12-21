module Vectrol.Models.Dial exposing
    ( Action(..)
    , Dial
    , Tracking
    , init
    , options
    , override
    , segments
    , tracking
    , transientValue
    , update
    , value
    , viewOption
    )

import Array as Array exposing (Array)
import Array.Extra exposing (indexedMapToList)
import Debug exposing (log)
import List.Extra exposing (findIndex)
import Maybe.Extra
import Svg exposing (Svg)
import Tuple exposing (pair)


type Action
    = Start
    | Drag (Maybe Int)
    | Finish
    | Cancel


type Config val msg
    = Config (Array val) (val -> Svg msg) Int


type alias Track =
    { originalIndex : Int
    , index : Int
    }


type alias Tracking =
    Maybe Track


type Dial val msg
    = Dial val (Config val msg) Tracking


init : Int -> (val -> Svg msg) -> List val -> val -> Dial val msg
init segs fn opts v =
    let
        config =
            Config (Array.fromList opts) fn segs
    in
    Dial v config Nothing


value : Dial val msg -> val
value dial =
    case dial of
        Dial v _ _ ->
            v


override : val -> Dial val msg -> Dial val msg
override v dial =
    case dial of
        Dial _ config trk ->
            Dial v config trk


options : Dial val msg -> Array val
options dial =
    case dial of
        Dial _ config _ ->
            case config of
                Config opts _ _ ->
                    opts


segments : Dial val msg -> Int
segments dial =
    case dial of
        Dial _ config _ ->
            case config of
                Config _ _ segs ->
                    segs


viewOption : Dial val msg -> (val -> Svg msg)
viewOption dial =
    case dial of
        Dial _ config _ ->
            case config of
                Config _ fn _ ->
                    fn


tracking : Dial val msg -> Tracking
tracking dial =
    case dial of
        Dial _ _ trk ->
            trk


transientValue : Dial val msg -> val
transientValue dial =
    let
        val =
            value dial

        opts =
            options dial

        trk =
            tracking dial
    in
    Maybe.withDefault val <|
        Maybe.Extra.join <|
            Maybe.map (\t -> Array.get t.index opts) trk


update :
    Action
    -> Dial val msg
    -> Dial val msg
update dialAction dial =
    let
        trk =
            tracking dial

        i0 =
            case trk of
                Just theTrack ->
                    theTrack.originalIndex

                Nothing ->
                    Maybe.withDefault 0 <|
                        findIndex
                            ((==) (value dial))
                        <|
                            Array.toList (options dial)
    in
    case dialAction of
        Start ->
            case dial of
                Dial val config _ ->
                    Dial val config <|
                        Just
                            { originalIndex = i0
                            , index = i0
                            }

        Drag mi ->
            let
                newIndex =
                    case mi of
                        Just i ->
                            i

                        Nothing ->
                            i0
            in
            case dial of
                Dial val config _ ->
                    Dial val config <|
                        Just
                            { originalIndex = i0
                            , index = newIndex
                            }

        Cancel ->
            case dial of
                Dial val config _ ->
                    Dial val config Nothing

        Finish ->
            case dial of
                Dial _ config _ ->
                    Dial (transientValue dial) config Nothing
