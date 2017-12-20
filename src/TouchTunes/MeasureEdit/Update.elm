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
            { ed
                | measure = ed.saved
                , hud = HeadUpDisplay ed.saved <| Just loc
            }

        FinishGesture ->
            { ed
                | saved = ed.measure
                , hud = HeadUpDisplay ed.measure Nothing
            }

        MeasureAction msg ->
            { ed
                | measure = MeasureUpdate.update msg ed.saved
            }
