module TouchTunes.Controls exposing
    ( Tracking
    , inactive
    , updateAlterationDial
    , updateSubdivisionDial
    , viewAlterationDial
    , viewSubdivisionDial
    )

import Array as Array
import Html exposing (Html)
import Music.Duration
    exposing
        ( Duration
        , eighth
        , half
        , quarter
        )
import Music.Measure.Layout as Layout exposing (Layout)
import Music.Measure.Model as Measure
import Music.Note.View exposing (StemOrientation(..), isWhole, viewNote)
import Music.Pitch as Pitch exposing (Semitones, alter)
import Music.Staff.Model as Staff
import Music.Time as Time
import TouchTunes.Action exposing (Msg(..))
import TouchTunes.Dial as Dial
import TouchTunes.Overlay as Overlay
import TypedSvg exposing (g)
import TypedSvg.Attributes exposing (transform)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Transform(..), px)


type alias Tracking =
    { subdivisionDial : Dial.Tracking
    , alterationDial : Dial.Tracking
    , overlay : Overlay.Tracking
    }


inactive : Tracking
inactive =
    Tracking
        Nothing
        Nothing
        Nothing


layout : Layout
layout =
    Layout.forMeasure Measure.noAttributes Measure.new



-- subdivisionDial: sets subdividion of current beat (quarter/eighth...)
-- TODO: options depend on time signature


subdivisionDial : Dial.Config Duration msg
subdivisionDial =
    { options =
        Array.fromList
            [ eighth
            , quarter
            , half
            ]
    , segments = 10
    , viewValue = viewSubdivision
    }


viewSubdivisionDial =
    Dial.view subdivisionDial SubdivisionMsg


updateSubdivisionDial =
    Dial.update subdivisionDial ChangeSubdivision


viewSubdivision : Duration -> Svg msg
viewSubdivision d =
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
        Array.fromList [ -1, 0, 1 ]
    , segments = 10
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
