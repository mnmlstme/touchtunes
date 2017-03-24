module Music.Measure.Model
    exposing
        ( Measure
        , new
        , fromNotes
        , time
        , notesLength
        , length
        , fitTime
          -- , insertNote
        , modifyNote
        , Sequence
        , toSequence
        , fromSequence
        )

import List.Nonempty as Nonempty exposing (Nonempty, (:::))
import Music.Time as Time exposing (Time, Beat)
import Music.Note.Model as Note exposing (Note)
import Music.Duration as Duration


type alias Measure =
    { notes : Nonempty Note
    }


new : Measure
new =
    Measure <|
        Nonempty.fromElement <|
            Note.blankFor Duration.whole


fromNotes : List Note -> Measure
fromNotes notes =
    case Nonempty.fromList notes of
        Nothing ->
            new

        Just nonempty ->
            Measure nonempty


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
            Nonempty.map (Duration.beats t << .duration) measure.notes
    in
        Nonempty.foldl1 (+) beats


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


cumulativeBeats : Measure -> Nonempty Beat
cumulativeBeats measure =
    -- gives the start beat for each note in measure
    let
        t =
            time measure

        beats =
            Nonempty.map (Duration.beats t << .duration) measure.notes
    in
        Nonempty.scanl (+) 0 beats


type alias Sequence =
    -- (possibly empty) lists of (Beat, Note) pairs
    List ( Beat, Note )


toSequence : Measure -> Sequence
toSequence measure =
    let
        startsAt =
            cumulativeBeats measure
    in
        Nonempty.toList <|
            Nonempty.map2 (,) startsAt measure.notes


fromSequence : Sequence -> Measure
fromSequence sequence =
    let
        justNotes seq =
            List.map (\( b, n ) -> n) seq
    in
        fromNotes <| justNotes sequence


splitSequence : Beat -> Sequence -> ( Sequence, Sequence )
splitSequence beat =
    let
        precedes beat ( b, _ ) =
            b < beat
    in
        List.partition <| precedes beat


findInSequence : Beat -> Sequence -> Maybe ( Beat, Note )
findInSequence beat sequence =
    let
        ( before, rest ) =
            splitSequence beat sequence
    in
        List.head rest


openSequence : Beat -> Sequence -> ( Sequence, Note, Sequence )
openSequence beat sequence =
    let
        ( before, rest ) =
            splitSequence beat sequence

        note =
            case List.head rest of
                Nothing ->
                    Note.blankFor Duration.quarter

                Just ( nextBeat, nextNote ) ->
                    if nextBeat == beat then
                        nextNote
                    else
                        Note.blankFor Duration.quarter

        after =
            case List.tail rest of
                Nothing ->
                    []

                Just list ->
                    list
    in
        ( before, note, after )



-- insertNote : Note -> Beat -> Measure -> Measure
-- insertNote note beat measure =
--     let
--         sequence =
--             toSequence measure
--
--         ( before, after ) =
--             splitSequence beat sequence
--
--         newSequence =
--             List.concat [ before, [ ( beat, note ) ], after ]
--     in
--         fromSequence newSequence


modifyNote : (Note -> Note) -> Beat -> Measure -> Measure
modifyNote f beat measure =
    let
        sequence =
            toSequence measure

        ( before, note, after ) =
            openSequence beat sequence

        newSequence =
            List.concat
                [ before
                , [ ( beat, f note ) ]
                , after
                ]
    in
        fromSequence newSequence
