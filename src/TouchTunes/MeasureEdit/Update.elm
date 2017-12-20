module TouchTunes.MeasureEdit.Update exposing (update)

import TouchTunes.MeasureEdit.HeadUpDisplay as HeadUpDisplay exposing (HeadUpDisplay)
import TouchTunes.MeasureEdit.Action exposing (Action, Action(..))
import TouchTunes.MeasureEdit.Model exposing (MeasureEdit)
import Music.Measure.Update as MeasureUpdate
import Music.Pitch exposing (Pitch, stepNumber, fromStepNumber)
import Debug exposing (log)


update : Action -> MeasureEdit -> MeasureEdit
update action ed =
    case (log "action" action) of
        StartGesture loc ->
            let
                beat =
                    loc.beat

                pitch =
                    fromStepNumber loc.step
            in
                { ed
                    | measure = ed.saved
                    , hud = Just <| HeadUpDisplay ed.saved beat pitch
                }

        FinishGesture ->
            { ed
                | saved = ed.measure
                , hud = Nothing
            }

        MeasureAction msg ->
            { ed
                | measure = MeasureUpdate.update msg ed.saved
            }
