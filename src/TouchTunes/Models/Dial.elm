module TouchTunes.Models.Dial exposing
    ( Action(..)
    , Config
    , Dial
    , Tracking
    , init
    , override
    , transientValue
    , update
    , value
    )

import Array as Array exposing (Array)
import Array.Extra exposing (indexedMapToList)
import Debug exposing (log)
import Svg exposing (Svg)
import List.Extra exposing (findIndex)
import Maybe.Extra
import Tuple exposing (pair)


type Action
    = Start
    | Drag (Maybe Int)
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


override : val -> Dial val msg -> Dial val msg
override v dial =
    { dial | value = v }

    
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

        Drag mi ->
            let
                newIndex =
                    case mi of
                        Just i ->
                            i

                        Nothing ->
                            i0
            in
            { dial
                | tracking =
                    Just
                        { originalIndex = i0
                        , index = newIndex
                        }
            }

        Cancel ->
            { dial | tracking = Nothing }

        Finish ->
            { dial
                | value = transientValue dial
                , tracking = Nothing
            }
