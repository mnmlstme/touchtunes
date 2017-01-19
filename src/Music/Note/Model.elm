module Music.Note.Model
    exposing
        ( Note
        , heldFor
        , beats
        )

import Music.Time as Time exposing (Time, Beat)
import Music.Duration as Duration exposing (Duration)
import Music.Pitch as Pitch exposing (Pitch)


type alias Note =
    { pitch : Pitch
    , duration : Duration
    }


heldFor : Duration -> Pitch -> Note
heldFor d p =
    Note p d


beats : Time -> Note -> Beat
beats time note =
    Duration.beats time note.duration
