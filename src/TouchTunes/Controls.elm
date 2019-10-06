module TouchTunes.Controls exposing
    ( Tracking
    , inactive
    , updateDurationDial
    , viewDurationDial
    )

import Array as Array
import Html exposing (Html)
import Music.Duration
    exposing
        ( Duration
        , dotted
        , half
        , quarter
        , whole
        )
import Music.Note.View exposing (StemOrientation(..), isWhole, viewNote)
import TouchTunes.Action exposing (Msg(..))
import TouchTunes.Dial as Dial
import TypedSvg exposing (g)
import TypedSvg.Attributes exposing (transform)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Transform(..), px)


type alias Tracking =
    { durationDial : Dial.Tracking
    }


inactive : Tracking
inactive =
    Tracking
        Nothing


durationDial : Dial.Config Duration msg
durationDial =
    { options =
        Array.fromList
            [ quarter
            , dotted quarter
            , half
            , dotted half
            , whole
            , dotted whole
            ]
    , segments = 18
    , viewValue = viewDuration
    }


viewDurationDial =
    Dial.view durationDial DurationControl


updateDurationDial =
    Dial.update durationDial ChangeDuration


viewDuration : Duration -> Svg msg
viewDuration d =
    let
        valign =
            if isWhole d then
                0

            else
                20
    in
    g
        [ transform [ Translate 0 valign ] ]
        [ viewNote d StemUp ]
