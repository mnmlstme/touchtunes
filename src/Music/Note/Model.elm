module Music.Note.Model
    exposing
        ( Note
        , heldFor
        , beats
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


type Modifier
    = ShiftX Tenths


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
