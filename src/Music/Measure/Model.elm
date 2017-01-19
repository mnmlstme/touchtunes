module Music.Measure.Model
    exposing
        ( Measure
        , empty
        , totalBeats
        , fitTime
        , toSequence
        , fromSequence
        , addInSequence
        , replaceInSequence
        , findInSequence
        )

-- import Debug exposing (log)

import Music.Time as Time exposing (Time, Beat)
import Music.Note.Model as Note exposing (Note)


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


type alias Sequence =
    List ( Beat, Note )


precedes : Beat -> ( Beat, Note ) -> Bool
precedes beat ( b, _ ) =
    b < beat


toSequence : Time -> Measure -> Sequence
toSequence time measure =
    let
        beats =
            List.map (Note.beats time) measure.notes

        startsAt =
            List.scanl (+) 0 beats
    in
        List.map2 (,) startsAt measure.notes


fromSequence : Sequence -> Measure
fromSequence sequence =
    let
        justNotes seq =
            List.map (\( b, n ) -> n) seq
    in
        Measure (justNotes sequence)


addInSequence : ( Beat, Note ) -> Sequence -> Sequence
addInSequence ( beat, note ) sequence =
    let
        ( before, after ) =
            List.partition (precedes beat) sequence
    in
        List.concat [ before, [ ( beat, note ) ], after ]


replaceInSequence : ( Beat, Note ) -> Sequence -> Sequence
replaceInSequence ( beat, note ) sequence =
    let
        ( before, after ) =
            List.partition (precedes beat) sequence

        rest =
            case (List.tail after) of
                Nothing ->
                    []

                Just list ->
                    list
    in
        List.concat [ before, [ ( beat, note ) ], rest ]


findInSequence : Beat -> Sequence -> Maybe ( Beat, Note )
findInSequence beat sequence =
    let
        ( before, after ) =
            List.partition (precedes beat) sequence
    in
        List.head after
