module TouchTunes.MeasureEdit.Action exposing (Action, Action(..))

import Music.Measure.Layout exposing (Location)
import Music.Note.Model exposing (Note)
import Music.Time exposing (Beat)
import Music.Duration exposing (Duration)
import Music.Pitch exposing (Pitch, Semitones)


type Action
    = Start Location
    | Finish
    | ReplaceNote Note Beat
    | StretchNote Duration Beat
    | RepitchNote Pitch Beat
    | AlterNote Semitones Beat
