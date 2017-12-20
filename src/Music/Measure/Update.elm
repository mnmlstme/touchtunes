module Music.Measure.Update exposing (Action, Action(..), update)

import Music.Measure.Model exposing (Measure, modifyNote)
import Music.Note.Model exposing (Note, What(..))
import Music.Time exposing (Beat)
import Music.Duration exposing (Duration)
import Music.Pitch exposing (Pitch, Semitones)


type Action
    = ReplaceNote Note Beat
    | StretchNote Duration Beat
    | RepitchNote Pitch Beat
    | AlterNote Semitones Beat


update : Action -> Measure -> Measure
update action m =
    case action of
        ReplaceNote note at ->
            let
                modifier _ =
                    note
            in
                modifyNote modifier at m

        StretchNote dur at ->
            let
                modifier note =
                    { note | duration = dur }
            in
                modifyNote modifier at m

        RepitchNote pitch at ->
            let
                modifier note =
                    { note | do = Play pitch }
            in
                modifyNote modifier at m

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
                modifyNote modifier at m
