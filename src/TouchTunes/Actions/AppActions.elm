module TouchTunes.Actions.AppActions exposing (Msg(..))

import Http
import Music.Models.Beat exposing (Beat)
import Music.Models.Duration exposing (Duration)
import Music.Models.Key exposing (KeyName)
import Music.Models.Measure exposing (Attributes, Measure)
import Music.Models.Note exposing (Note)
import Music.Models.Part as Part
import Music.Models.Pitch exposing (Pitch, Semitones)
import Music.Models.Time exposing (Time)
import TouchTunes.Models.Dial as Dial


type Msg
    = Clear
    | Save
    | Saved (Result Http.Error String)
    | SaveAs String
    | GetCatalog
    | GotCatalog (Result Http.Error String)
    | GetScore String
    | GotScore String (Result Http.Error String)
    | StartEdit Part.Id Int Attributes Measure
    | NoteEdit ( Int, Int )
    | HarmonyEdit ( Int, Int )
    | DragEdit ( Int, Int )
    | FinishEdit
    | SaveEdit
    | CancelEdit
    | PreviousEdit
    | NextEdit
    | DoneEdit
    | SubdivisionMsg Dial.Action
    | AlterationMsg Dial.Action
    | TimeMsg Dial.Action
    | KeyMsg Dial.Action
    | HarmonyMsg Dial.Action
    | KindMsg Dial.Action
    | DegreeMsg Dial.Action
    | AltHarmonyMsg Dial.Action
    | BassMsg Dial.Action



-- | ChangeKey KeyName
