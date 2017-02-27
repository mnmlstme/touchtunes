module Music.Measure.Model
    exposing
        ( Measure
        , empty
        , time
        , notesLength
        , length
        , fitTime
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


time : Measure -> Time
time measure =
    -- the time (signature) for a measure
    -- TODO get from Timeline
    Time.common


notesLength : Measure -> Beat
notesLength measure =
    -- sum of the number of beats of all notes in measure
    let
        t =
            time measure

        beats =
            List.map (Duration.beats t << .duration) measure.notes
    in
        List.sum beats


length : Measure -> Beat
length measure =
    -- count the total number of beats in a measure
    let
        t =
            time measure
    in
        max t.beats <| notesLength measure


fitTime : Measure -> Time
fitTime measure =
    -- compute a new time signature that notes will fit in
    let
        t =
            time measure

        beats =
            length measure
    in
        Time.longer t beats


cumulativeBeats : Measure -> List Beat
cumulativeBeats measure =
    -- gives the start beat for each note in measure
    let
        t =
            time measure

        beats =
            List.map (Duration.beats t << .duration) measure.notes
    in
        List.scanl (+) 0 beats


type alias Sequence =
    -- lists of (Beat, Note) pairs
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
