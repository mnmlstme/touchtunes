module Music.Models.Measure exposing
    ( Attributes
    , Measure
    , Sequence
    , aggregateRests
    , fromNotes
    , fromSequence
    , initial
    , length
    , modifyNote
    , new
    , noAttributes
    , notesLength
    , startingBeats
    , toSequence
    )

import Debug exposing (log)
import List.Extra exposing (find, scanl)
import List.Nonempty as Nonempty exposing (Nonempty)
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Note as Note exposing (Note, restFor)
import Music.Models.Staff as Staff exposing (Staff)
import Music.Models.Time as Time exposing (Time)


type alias Measure =
    { attributes : Attributes
    , notes : Nonempty Note
    }


type alias Attributes =
    { staff : Maybe Staff
    , time : Maybe Time
    }


noAttributes =
    { staff = Nothing
    , time = Nothing
    }


new : Measure
new =
    fromAttributes noAttributes


initial : Staff -> Time -> Measure
initial s t =
    let
        attrs =
            { staff = Just s
            , time = Just t
            }
    in
    fromAttributes attrs


fromAttributes : Attributes -> Measure
fromAttributes attrs =
    Measure attrs <|
        Nonempty.fromElement <|
            Note.restFor Duration.whole


fromNotes : Attributes -> List Note -> Measure
fromNotes attrs notes =
    case Nonempty.fromList notes of
        Nothing ->
            fromAttributes attrs

        Just nonempty ->
            Measure attrs nonempty



-- time : Measure -> Time
-- time measure =
--     -- the time (signature) for a measure
--     -- TODO get default from Timeline
--     Maybe.withDefault Time.common measure.attributes.time


notesLength : Measure -> Duration
notesLength measure =
    -- sum of the duration of all notes in measure
    let
        durs =
            Nonempty.map .duration measure.notes
    in
    Nonempty.foldl1 Duration.add durs


length : Time -> Measure -> Beat
length t measure =
    -- count the total number of beats in a measure
    let
        tdur =
            Time.toDuration t

        mdur =
            notesLength measure
    in
    if Duration.longerThan tdur mdur then
        Beat.fromDuration t <| mdur

    else
        Beat.fullBeat t.beats


startingBeats : Time -> Measure -> Nonempty Beat
startingBeats t measure =
    -- gives the starting beat for each note
    let
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


toSequence : Time -> Measure -> Sequence
toSequence t measure =
    let
        startsAt =
            startingBeats t measure
    in
    Nonempty.toList <|
        Nonempty.map2 (\a b -> ( a, b )) startsAt measure.notes


fromSequence : Attributes -> Sequence -> Measure
fromSequence attrs sequence =
    let
        justNotes seq =
            List.map (\( b, n ) -> n) seq
    in
    fromNotes attrs <| justNotes sequence


findNote : Time -> Beat -> Measure -> Maybe Note
findNote t beat measure =
    let
        seq =
            toSequence t measure

        sameBeat ( b, _ ) =
            Beat.equal beat b
    in
    Maybe.map (\( _, n ) -> n)
        (find sameBeat seq)


modifyNote : (Note -> Note) -> Time -> Beat -> Measure -> Measure
modifyNote f t beat measure =
    let
        seq =
            toSequence t measure

        note =
            Maybe.withDefault
                (Note.restFor Duration.quarter)
                (findNote t beat measure)
    in
    spliceSequence t ( beat, f note ) seq
        |> fromSequence measure.attributes
        |> aggregateRests


spliceNote : Time -> ( Beat, Note ) -> ( Beat, Note ) -> Sequence
spliceNote t ( b0, n0 ) ( b1, n1 ) =
    let
        e0 =
            Beat.add t n0.duration b0

        e1 =
            Beat.add t n1.duration b1

        clipFromTo b e n =
            { n | duration = Beat.durationFrom t b e }

        restFromTo b e _ =
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
            -- insert n0 and rest for the remainder of n1
            [ ( b0, n0 )
            , ( e0, restFromTo e0 e1 n1 )
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
        |> Measure measure.attributes
