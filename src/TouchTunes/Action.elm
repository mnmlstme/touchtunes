module TouchTunes.Action exposing
    ( Action(..)
    , DialAction(..)
    )

import Music.Duration exposing (Duration)
import Music.Measure.Layout exposing (Location)
import Music.Note.Model exposing (Note)
import Music.Pitch exposing (Pitch, Semitones)
import Music.Time exposing (Beat)


type Action
    = StartEdit Int Int Location
    | FinishEdit
    | ReplaceNote Note Beat
    | StretchNote Duration Beat
    | RepitchNote Pitch Beat
    | AlterNote Semitones Beat
    | DurationControl (DialAction Duration)


type DialAction valueType
    = Start ( Int, Int )
    | Finish
    | Cancel
    | Drag ( Int, Int )
    | ChangeValue valueType
