module TouchTunes.MeasureEdit.Update exposing (update)

import TouchTunes.MeasureEdit.HeadUpDisplay as HeadUpDisplay exposing (HeadUpDisplay)
import TouchTunes.MeasureEdit.Action exposing (Action, Action(..))
import TouchTunes.MeasureEdit.Model exposing (MeasureEdit)
import Music.Measure.Model exposing (Measure, modifyNote)
import Music.Note.Model exposing (Note, What(..))
import Music.Pitch exposing (Pitch, stepNumber, fromStepNumber)
import Debug exposing (log)


update : Action -> MeasureEdit -> MeasureEdit
update action ed =
    case (log "action" action) of
        Start loc ->
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

        Finish ->
            { ed
                | saved = ed.measure
                , hud = Nothing
            }

        ReplaceWith note at ->
            let
                modifier _ =
                    note
            in
                { ed | measure = modifyNote modifier at ed.measure }

        StretchTo dur at ->
            let
                modifier note =
                    { note | duration = dur }
            in
                { ed | measure = modifyNote modifier at ed.measure }

        RepitchTo pitch at ->
            let
                modifier note =
                    { note | do = Play pitch }
            in
                { ed | measure = modifyNote modifier at ed.measure }

        AlterBy semitones at ->
            let
                modifier note =
                    case note.do of
                        Play pitch ->
                            { note
                                | do = Play { pitch | alter = semitones }
                            }

                        Rest ->
                            note
            in
                { ed | measure = modifyNote modifier at ed.measure }
