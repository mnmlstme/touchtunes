module Music.Measure.Update exposing (Action, Action(..), update)

import Music.Measure.Model exposing (Measure, modifyNote)
import Music.Note.Model exposing (Note, What(..))
import Music.Time exposing (Beat)
import Music.Duration exposing (Duration)
import Music.Pitch exposing (Pitch)


type Action
    = InsertNote Note Beat
    | StretchNote Duration Beat
    | RepitchNote Pitch Beat


update : Action -> Measure -> Measure
update action m =
    case action of
        InsertNote note at ->
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
