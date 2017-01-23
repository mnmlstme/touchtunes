module Music.Measure.Model
    exposing
        ( Measure
        , empty
        , time
        , length
        , fitTime
        , nextBeat
        , toSequence
        , fromSequence
        , addInSequence
        , replaceInSequence
        , findInSequence
        )

-- import Debug exposing (log)

import Music.Time as Time exposing (Time, Beat)
import Music.Note.Model as Note exposing (Note)
import Music.Duration as Duration


type alias Measure =
    { notes : List Note
    }


empty : Measure
empty =
    Measure []



-- the time (signature) for a measure


time : Measure -> Time
time measure =
    -- TODO get from Timeline
    Time.common



-- count the total number of beats in a measure


length : Measure -> Beat
length measure =
    let
        t =
            time measure

        beats =
            List.map (Duration.beats t << .duration) measure.notes

        total =
            List.sum beats
    in
        max total t.beats



-- compute a new time signature that notes will fit in


fitTime : Measure -> Time
fitTime measure =
    let
        t =
            time measure

        beats =
            length measure
    in
        Time.longer t beats


cumulativeBeats : Measure -> List Beat
cumulativeBeats measure =
    let
        t =
            time measure

        beats =
            List.map (Duration.beats t << .duration) measure.notes
    in
        List.scanl (+) 0 beats


nextBeat : Beat -> Measure -> Beat
nextBeat fromBeat measure =
    let
        beatBoundaries =
            cumulativeBeats measure

        futureBeats =
            List.filter (\b -> b >= fromBeat) beatBoundaries
    in
        case List.head futureBeats of
            Just b ->
                b

            Nothing ->
                fromBeat



-- Sequences are lists of (Beat, Note) pairs


type alias Sequence =
    List ( Beat, Note )


precedes : Beat -> ( Beat, Note ) -> Bool
precedes beat ( b, _ ) =
    b < beat


toSequence : Measure -> Sequence
toSequence measure =
    let
        startsAt =
            cumulativeBeats measure
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
