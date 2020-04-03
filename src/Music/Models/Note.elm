module Music.Models.Note exposing
    ( Note
    , What(..)
    , isPlayed
    , playFor
    , restFor
    )

import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Pitch as Pitch exposing (Pitch)


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
    = Tie StartStop


type StartStop
    = Start
    | Stop


playFor : Duration -> Pitch -> Note
playFor d p =
    Note (Play p) d []


restFor : Duration -> Note
restFor d =
    Note Rest d []


mod : Modifier -> Note -> Note
mod m note =
    { note | modifiers = m :: note.modifiers }


isPlayed : Note -> Bool
isPlayed n =
    case n.do of
        Play _ ->
            True

        Rest ->
            False
