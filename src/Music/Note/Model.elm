module Music.Note.Model
    exposing
        ( Note
        , What(..)
        , rest
        , heldFor
        , shiftX
        , unshiftX
        , getShiftX
        )

import Music.Duration as Duration exposing (Duration)
import Music.Pitch as Pitch exposing (Pitch)
import Music.Measure.Layout exposing (Tenths)


type alias Note =
    { do : What
    , duration : Duration
    , modifiers : List Modifier
    }


type What
    = Play Pitch
    | Rest



-- TODO: | Strike for unpitched


type Modifier
    = ShiftX Tenths
    | Tie StartStop


type StartStop
    = Start
    | Stop


heldFor : Duration -> Pitch -> Note
heldFor d p =
    Note (Play p) d []


rest : Duration -> Note
rest d =
    Note Rest d []


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
