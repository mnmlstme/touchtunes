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
import Music.Measure.Layout as Layout exposing (Layout)
import Music.Note.View exposing (StemOrientation(..), isWhole, viewNote)
import Music.Pitch as Pitch
import Music.Staff.Model as Staff
import Music.Time as Time
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


layout : Layout
layout =
    Layout.zoomed 1.0 Staff.treble Time.common


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
        -- choose a pitch which centers the note+stem on staff
        pitch =
            if isWhole d then
                Pitch.b 4

            else
                Pitch.e_ 4

        staffHeight =
            Layout.height layout
    in
    g
        [ transform [ Translate 0 (-0.5 * staffHeight.px) ] ]
        [ viewNote layout d pitch ]
