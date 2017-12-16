module TouchTunes.MeasureEdit.Update exposing (update)

import TouchTunes.MeasureEdit.HeadUpDisplay as HeadUpDisplay exposing (HeadUpDisplay)
import TouchTunes.MeasureEdit.Action exposing (Action, Action(..))
import TouchTunes.MeasureEdit.Model exposing (MeasureEdit)
import Music.Measure.Update as MeasureUpdate
import Debug exposing (log)


update : Action -> MeasureEdit -> MeasureEdit
update action ed =
    case (log "action" action) of
        StartGesture loc ->
            { ed | hud = HeadUpDisplay ed.measure <| Just loc }

        FinishGesture ->
            { ed | hud = HeadUpDisplay ed.measure Nothing }

        MeasureAction msg ->
            { ed | measure = MeasureUpdate.update (log "msg" msg) ed.measure }
