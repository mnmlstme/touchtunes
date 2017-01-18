module Music.Measure.Model
    exposing
        ( Measure
        , empty
        , totalBeats
        , fitTime
        , sequence
        , addInSequence
        , replaceInSequence
        , previousInSequence
        )

-- import Debug exposing (log)

import Music.Time as Time exposing (Time, Beat)
import Music.Note as Note exposing (Note)


type alias Measure =
    { notes : List Note
    }


empty : Measure
empty =
    Measure []



-- count the total number of beats in a measure


totalBeats : Time -> Measure -> Beat
totalBeats time measure =
    let
        beats =
            List.map (Note.beats time) measure.notes
    in
        List.sum beats



-- compute a new time signature that notes will fit in


fitTime : Time -> Measure -> Time
fitTime time measure =
    let
        beats =
            totalBeats time measure
    in
        Time.longer time beats



-- Sequences are lists of (Beat, Note) pairs


sequence : Time -> Measure -> List ( Beat, Note )
sequence time measure =
    let
        beats =
            List.map (Note.beats time) measure.notes

        startsAt =
            List.scanl (+) 0 beats
    in
        List.map2 (,) startsAt measure.notes


addInSequence : ( Beat, Note ) -> List ( Beat, Note ) -> List ( Beat, Note )
addInSequence ( beat, note ) sequence =
    let
        ( before, after ) =
            List.partition (\( b, n ) -> b < beat) sequence
    in
        List.concat [ before, [ ( beat, note ) ], after ]


replaceInSequence : ( Beat, Note ) -> List ( Beat, Note ) -> List ( Beat, Note )
replaceInSequence ( beat, note ) sequence =
    let
        ( before, after ) =
            List.partition (\( b, n ) -> b < beat) sequence

        rest =
            case (List.tail after) of
                Nothing ->
                    []

                Just list ->
                    list
    in
        List.concat [ before, [ ( beat, note ) ], rest ]


previousInSequence : Beat -> List ( Beat, Note ) -> Maybe ( Beat, Note )
previousInSequence beat sequence =
    let
        before =
            List.filter (\( b, n ) -> b < beat) sequence
    in
        List.head (List.reverse before)
