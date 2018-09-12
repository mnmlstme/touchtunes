module TouchTunes.MeasureEdit.Update exposing (update)

import Debug exposing (log)
import Music.Measure.Model exposing (Measure, modifyNote)
import Music.Note.Model exposing (Note, What(..))
import Music.Pitch exposing (Pitch, fromStepNumber, stepNumber)
import TouchTunes.MeasureEdit.Action exposing (Action(..))
import TouchTunes.MeasureEdit.HeadUpDisplay as HeadUpDisplay exposing (HeadUpDisplay)
import TouchTunes.MeasureEdit.Model exposing (MeasureEdit)


update : Action -> MeasureEdit -> MeasureEdit
update action ed =
    case log "action" action of
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

        ReplaceNote note at ->
            let
                modifier _ =
                    note
            in
                { ed | measure = modifyNote modifier at ed.measure }

        StretchNote dur at ->
            let
                modifier note =
                    { note | duration = dur }
            in
                { ed | measure = modifyNote modifier at ed.measure }

        RepitchNote pitch at ->
            let
                modifier note =
                    { note | do = Play pitch }
            in
                { ed | measure = modifyNote modifier at ed.measure }

        AlterNote semitones at ->
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
