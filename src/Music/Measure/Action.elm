module Music.Measure.Action
    exposing
        ( Action(..)
        , update
        )

import Debug exposing (log)
import Music.Duration as Duration
import Music.Time as Time exposing (Time, Beat)
import Music.Note as Note exposing (Note)
import Music.Measure.Model exposing (..)


type Action
    = InsertNote Note Beat
    | StretchNote Beat Beat


update : Action -> Measure -> Measure
update action measure =
    let
        -- TODO: get the current time signature for measure
        time =
            Time.common

        oldSequence =
            sequence time measure

        justNotes seq =
            List.map (\( b, n ) -> n) seq
    in
        case action of
            InsertNote note beat ->
                let
                    newSequence =
                        addInSequence ( beat, note ) oldSequence
                in
                    { measure | notes = justNotes newSequence }

            StretchNote fromBeat toBeat ->
                case (findInSequence fromBeat oldSequence) of
                    Nothing ->
                        measure

                    Just ( b, note ) ->
                        let
                            newDuration =
                                Duration.setBeats time (toBeat - b) note.duration

                            newNote =
                                Note note.pitch (log "newDuration" newDuration)

                            newSequence =
                                replaceInSequence ( b, newNote ) oldSequence
                        in
                            { measure | notes = justNotes newSequence }
