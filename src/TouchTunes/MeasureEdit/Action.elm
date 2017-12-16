module TouchTunes.MeasureEdit.Action exposing (Action, Action(..))

import Music.Measure.Update as MeasureUpdate
import Music.Measure.Layout exposing (Location)


type Action
    = StartGesture Location
    | FinishGesture
    | MeasureAction MeasureUpdate.Action
