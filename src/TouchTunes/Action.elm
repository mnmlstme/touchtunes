module TouchTunes.Action exposing (Msg(..))

import Music.Beat exposing (Beat)
import Music.Duration exposing (Duration)
import Music.Measure.Layout exposing (Location)
import Music.Note.Model exposing (Note)
import Music.Pitch exposing (Pitch, Semitones)
import TouchTunes.Dial as Dial


type Msg
    = StartEdit Int Int ( Int, Int )
    | DragEdit Int Int ( Int, Int )
    | FinishEdit
    | CancelEdit
    | DurationMsg Dial.Action
    | ChangeDuration Duration
    | AlterationMsg Dial.Action
    | ChangeAlteration Semitones
