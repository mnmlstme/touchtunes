module Music.Measure.Model exposing
    ( Measure
    , Sequence
    , aggregateRests
    , fitTime
    , fromNotes
    , fromSequence
    , length
    , modifyNote
    , new
    , notesLength
    , startingBeats
    , time
    , toSequence
    )

import Debug exposing (log)
import List.Extra exposing (find, scanl)
import List.Nonempty as Nonempty exposing (Nonempty)
import Music.Beat as Beat exposing (Beat)
import Music.Duration as Duration exposing (Duration)
import Music.Note.Model as Note exposing (Note, restFor)
import Music.Time as Time exposing (Time)


type alias Measure =
    { notes : Nonempty Note
    }


new : Measure
new =
    Measure <|
        Nonempty.fromElement <|
            Note.restFor Duration.whole


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


notesLength : Measure -> Duration
notesLength measure =
    -- sum of the duration of all notes in measure
    let
        durs =
            Nonempty.map .duration measure.notes
    in
    Nonempty.foldl1 Duration.add durs


length : Measure -> Beat
length measure =
    -- count the total number of beats in a measure
    let
        t =
            time measure

        tdur =
            Time.toDuration t

        mdur =
            notesLength measure
    in
    if Duration.longerThan tdur mdur then
        Beat.fromDuration t <| mdur

    else
        Beat.fullBeat t.beatsPerMeasure


fitTime : Measure -> Time
fitTime measure =
    -- compute a new time signature that notes will fit in
    let
        t =
            time measure

        beats =
            length measure
    in
    Beat.fitToTime t beats


startingBeats : Measure -> Nonempty Beat
startingBeats measure =
    -- gives the starting beat for each note
    let
        t =
            time measure

        beats =
            Nonempty.map .duration measure.notes

        head =
            Nonempty.head beats

        tail =
            List.map (Beat.fromDuration t) <|
                scanl Duration.add head <|
                    Nonempty.tail beats
    in
    Nonempty.Nonempty Beat.zero tail


type alias Sequence =
    -- (possibly empty) lists of (Beat, Note) pairs
    List ( Beat, Note )


toSequence : Measure -> Sequence
toSequence measure =
    let
        startsAt =
            startingBeats measure
    in
    Nonempty.toList <|
        Nonempty.map2 (\a b -> ( a, b )) startsAt measure.notes


fromSequence : Sequence -> Measure
fromSequence sequence =
    let
        justNotes seq =
            List.map (\( b, n ) -> n) seq
    in
    fromNotes <| justNotes sequence


modifyNote : (Note -> Note) -> Beat -> Measure -> Measure
modifyNote f beat measure =
    let
        seq =
            toSequence measure

        t =
            time measure

        sameBeat ( b, _ ) =
            Beat.equal beat b

        note =
            case find sameBeat seq of
                Just ( _, n ) ->
                    n

                Nothing ->
                    Note.restFor Duration.quarter
    in
    spliceSequence t ( beat, f note ) seq
        |> fromSequence
        |> aggregateRests


spliceNote : Time -> ( Beat, Note ) -> ( Beat, Note ) -> Sequence
spliceNote t ( b0, n0 ) ( b1, n1 ) =
    let
        e0 =
            Beat.add t n0.duration b0

        e1 =
            Beat.add t n1.duration b1

        clipFromTo b e _ =
            restFor <| Beat.durationFrom t b e
    in
    if not <| Beat.laterThan b0 e1 then
        -- no intersection
        [ ( b1, n1 ) ]

    else if not <| Beat.laterThan b1 e0 then
        -- no intersection
        [ ( b1, n1 ) ]

    else if Beat.equal b0 b1 then
        if Beat.earlierThan e1 e0 then
            -- insert n0 and clip off beginning of n1
            [ ( b0, n0 )
            , ( e0, clipFromTo e0 e1 n1 )
            ]

        else
            -- replace n1 with n0
            [ ( b0, n0 ) ]

    else if Beat.earlierThan b0 b1 then
        if Beat.earlierThan e1 e0 then
            -- split n1 into two and insert n0 in the middle
            [ ( b1, clipFromTo b1 b0 n1 )
            , ( b0, n0 )
            , ( e0, clipFromTo e0 e1 n1 )
            ]

        else
            -- clip off end of n1 and insert n0
            [ ( b1, clipFromTo b1 b0 n1 )
            , ( b0, n0 )
            ]

    else if Beat.earlierThan e1 e0 then
        -- clip off beginning of n1
        [ ( e0, clipFromTo e0 e1 n1 ) ]

    else
        -- completely spliced out
        []


spliceSequence : Time -> ( Beat, Note ) -> Sequence -> Sequence
spliceSequence t bn seq =
    List.map (spliceNote t bn) seq
        |> List.concat


aggregateRests : Measure -> Measure
aggregateRests measure =
    let
        -- agg operates right to left so that previous note is head of list
        agg : Nonempty Note -> Nonempty Note -> Nonempty Note
        agg singleton sofar =
            let
                note =
                    Nonempty.head singleton

                prevNote =
                    Nonempty.head sofar
            in
            case ( prevNote.do, note.do ) of
                ( Note.Rest, Note.Rest ) ->
                    Nonempty.replaceHead
                        { prevNote
                            | duration =
                                Duration.add prevNote.duration note.duration
                        }
                        sofar

                _ ->
                    Nonempty.cons note sofar
    in
    Nonempty.map Nonempty.fromElement measure.notes
        |> Nonempty.reverse
        |> Nonempty.foldl1 agg
        |> Measure
