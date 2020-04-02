module TouchTunes.Action exposing (Msg(..))

import Music.Beat exposing (Beat)
import Music.Duration exposing (Duration)
import Music.Measure.Layout exposing (Layout, Location)
import Music.Note.Model exposing (Note)
import Music.Pitch exposing (Pitch, Semitones)
import TouchTunes.Dial as Dial


type Msg
    = StartEdit Layout Int Int ( Int, Int )
    | DragEdit Layout ( Int, Int )
    | FinishEdit
    | CancelEdit
    | SubdivisionMsg Dial.Action
    | ChangeSubdivision Duration
    | AlterationMsg Dial.Action
    | ChangeAlteration Semitones
