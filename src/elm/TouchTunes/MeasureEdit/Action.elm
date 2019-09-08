module TouchTunes.MeasureEdit.Action exposing (Action(..))

import Music.Duration exposing (Duration)
import Music.Measure.Layout exposing (Location)
import Music.Note.Model exposing (Note)
import Music.Pitch exposing (Pitch, Semitones)
import Music.Time exposing (Beat)


type Action
    = Start Location
    | Finish
    | ReplaceNote Note Beat
    | StretchNote Duration Beat
    | RepitchNote Pitch Beat
    | AlterNote Semitones Beat
