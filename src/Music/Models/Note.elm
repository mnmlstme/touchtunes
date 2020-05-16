module Music.Models.Note exposing
    ( Note
    , What(..)
    , harmonize
    , isPlayed
    , modPitch
    , pitch
    , playFor
    , restFor
    )

import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Harmony exposing (Harmony)
import Music.Models.Pitch as Pitch exposing (Pitch)


type alias Note =
    { do : What
    , duration : Duration
    , modifiers : List Modifier
    , harmony : Maybe Harmony
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
    Note (Play p) d [] Nothing


restFor : Duration -> Note
restFor d =
    Note Rest d [] Nothing


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


modPitch : (Pitch -> Pitch) -> Note -> Note
modPitch fn note =
    case note.do of
        Play p ->
            { note | do = Play <| fn p }

        Rest ->
            note


pitch : Note -> Maybe Pitch
pitch note =
    case note.do of
        Play p ->
            Just p

        Rest ->
            Nothing


harmonize : Harmony -> Note -> Note
harmonize harmony note =
    { note | harmony = Just harmony }
