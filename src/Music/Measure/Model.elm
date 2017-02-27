module Music.Measure.Model
    exposing
        ( Measure
        , empty
        , time
        , length
        , fitTime
        , nextBeat
        , Sequence
        , toSequence
        , fromSequence
        )

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
nextBeat beforeBeat measure =
    let
        beatBoundaries =
            cumulativeBeats measure

        priorBeats =
            List.reverse <|
                List.filter (\b -> b <= beforeBeat) beatBoundaries
    in
        case List.head priorBeats of
            Just b ->
                b

            Nothing ->
                0



-- Sequences are lists of (Beat, Note) pairs


type alias Sequence =
    List ( Beat, Note )


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
