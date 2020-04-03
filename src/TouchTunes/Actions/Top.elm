module TouchTunes.Actions.Top exposing (Msg(..))

import Music.Models.Beat exposing (Beat)
import Music.Models.Duration exposing (Duration)
import Music.Models.Layout exposing (Layout, Location)
import Music.Models.Note exposing (Note)
import Music.Models.Pitch exposing (Pitch, Semitones)
import TouchTunes.Models.Dial as Dial


type Msg
    = StartEdit Layout Int Int ( Int, Int )
    | DragEdit Layout ( Int, Int )
    | FinishEdit
    | CancelEdit
    | SubdivisionMsg Dial.Action
    | ChangeSubdivision Duration
    | AlterationMsg Dial.Action
    | ChangeAlteration Semitones
