module Music.Note.Model
    exposing
        ( Note
        , heldFor
        , beats
        , shiftX
        , unshiftX
        , getShiftX
        )

import Music.Time as Time exposing (Time, Beat)
import Music.Duration as Duration exposing (Duration)
import Music.Pitch as Pitch exposing (Pitch)
import Music.Measure.Layout exposing (Tenths)


type alias Note =
    { pitch : Pitch
    , duration : Duration
    , modifiers : List Modifier
    }


type StartStop
    = Start
    | Stop


type Modifier
    = ShiftX Tenths
    | Tie StartStop


heldFor : Duration -> Pitch -> Note
heldFor d p =
    Note p d []


beats : Time -> Note -> Beat
beats time note =
    Duration.beats time note.duration


mod : Modifier -> Note -> Note
mod m note =
    { note | modifiers = m :: note.modifiers }


shiftX : Tenths -> Note -> Note
shiftX dx =
    mod (ShiftX dx)


unshiftX : Note -> Note
unshiftX n =
    let
        check m =
            case m of
                ShiftX _ ->
                    False

                _ ->
                    True
    in
        { n | modifiers = List.filter check n.modifiers }


getShiftX : Note -> Maybe Tenths
getShiftX n =
    let
        check m =
            case m of
                ShiftX tenths ->
                    Just tenths

                _ ->
                    Nothing

        shifts =
            List.filterMap check n.modifiers
    in
        List.head shifts
