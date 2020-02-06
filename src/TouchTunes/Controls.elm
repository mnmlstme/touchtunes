module TouchTunes.Controls exposing
    ( Tracking
    , inactive
    , updateAlterationDial
    , updateDurationDial
    , viewAlterationDial
    , viewDurationDial
    )

import Array as Array
import Html exposing (Html)
import Music.Duration
    exposing
        ( Duration
        , dotted
        , eighth
        , half
        , quarter
        , whole
        )
import Music.Measure.Layout as Layout exposing (Layout)
import Music.Note.View exposing (StemOrientation(..), isWhole, viewNote)
import Music.Pitch as Pitch exposing (Semitones, alter)
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
    , alterationDial : Dial.Tracking
    }


inactive : Tracking
inactive =
    Tracking
        Nothing
        Nothing


layout : Layout
layout =
    Layout.zoomed 1.0 Staff.treble Time.common



-- durationDial: sets duration of note (quarter/half/eighth...)


durationDial : Dial.Config Duration msg
durationDial =
    { options =
        Array.fromList
            [ eighth
            , quarter
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
    Dial.view durationDial DurationMsg


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



-- alterationDial: sets alteration (sharp/flat/natural)


alterationDial : Dial.Config Semitones msg
alterationDial =
    { options =
        Array.fromList [ 2, 1, 0, -1, -2 ]
    , segments = 12
    , viewValue = viewAlteration
    }


viewAlterationDial =
    Dial.view alterationDial AlterationMsg


updateAlterationDial =
    Dial.update alterationDial ChangeAlteration


viewAlteration : Semitones -> Svg msg
viewAlteration alt =
    let
        -- choose a pitch which centers the alter+note+stem on staff
        pitch =
            alter alt Pitch.f 4

        staffHeight =
            Layout.height layout
    in
    g
        [ transform [ Translate 0 (-0.5 * staffHeight.px) ] ]
        [ viewNote layout quarter pitch ]
