module TouchTunes.Action exposing (Msg(..))

import Music.Duration exposing (Duration)
import Music.Measure.Layout exposing (Location)
import Music.Note.Model exposing (Note)
import Music.Pitch exposing (Pitch, Semitones)
import Music.Time exposing (Beat)
import TouchTunes.Dial as Dial


type Msg
    = StartEdit Int Int Location
    | FinishEdit
    | ReplaceNote Note Beat
    | StretchNote Duration Beat
    | RepitchNote Pitch Beat
    | AlterNote Semitones Beat
    | DurationControl Dial.Action
    | ChangeDuration Duration
