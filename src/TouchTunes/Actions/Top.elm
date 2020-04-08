module TouchTunes.Actions.Top exposing (Msg(..))

import Music.Models.Beat exposing (Beat)
import Music.Models.Duration exposing (Duration)
import Music.Models.Key exposing (KeyName)
import Music.Models.Layout exposing (Layout, Location)
import Music.Models.Note exposing (Note)
import Music.Models.Pitch exposing (Pitch, Semitones)
import Music.Models.Time exposing (Time)
import TouchTunes.Models.Dial as Dial


type Msg
    = StartEdit Int Int Layout
    | NoteEdit ( Int, Int )
    | DragEdit ( Int, Int )
    | CommitEdit
    | CancelEdit
    | SubdivisionMsg Dial.Action
    | ChangeSubdivision Duration
    | AlterationMsg Dial.Action
    | ChangeAlteration Semitones
    | TimeMsg Dial.Action
    | ChangeTime Time
    | KeyMsg Dial.Action
    | ChangeKey KeyName
