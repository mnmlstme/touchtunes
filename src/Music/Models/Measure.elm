module Music.Models.Measure exposing
    ( Attributes
    , Measure
    , Sequence
    , aggregateRests
    , essentialAttributes
    , fromNotes
    , fromSequence
    , initial
    , length
    , modifyNote
    , new
    , noAttributes
    , offsets
    , toSequence
    , withAttributes
    )

import Debug exposing (log)
import List.Extra exposing (find, scanl)
import List.Nonempty as Nonempty exposing (Nonempty)
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


withAttributes : Attributes -> Measure -> Measure
withAttributes attrs measure =
    { measure | attributes = attrs }


essentialAttributes : Attributes -> Attributes -> Attributes
essentialAttributes indirect direct =
    { direct
        | -- remove direct time if same as indirect time
          time =
            case direct.time of
                Just dtime ->
                    case indirect.time of
                        Just itime ->
                            if Time.equal itime dtime then
                                Nothing

                            else
                                Just dtime

                        Nothing ->
                            Just dtime

                Nothing ->
                    Nothing
    }


type alias Offset =
    -- duration from start of the measure
    Duration


type alias Sequence =
    -- (possibly empty) lists of (Offset, Note) pairs
    List ( Offset, Note )


length : Measure -> Offset
length measure =
    -- sum of the duration of all notes in measure
    let
        durs =
            Nonempty.map .duration measure.notes
    in
    Nonempty.foldl1 Duration.add durs


offsets : Measure -> Nonempty Offset
offsets measure =
    -- gives the starting offset () for each note
    let
        beats =
            Nonempty.map .duration measure.notes

        head =
            Nonempty.head beats

        tail =
            scanl Duration.add head <|
                Nonempty.tail beats
    in
    Nonempty.Nonempty Duration.zero tail


toSequence : Measure -> Sequence
toSequence measure =
    Nonempty.toList <|
        Nonempty.map2 (\a b -> ( a, b )) (offsets measure) measure.notes


fromSequence : Attributes -> Sequence -> Measure
fromSequence attrs sequence =
    fromNotes attrs <|
        List.map (\( b, n ) -> n) sequence


findNote : Offset -> Measure -> Maybe Note
findNote offset measure =
    Maybe.map (\( _, n ) -> n) <|
        find (\( d, _ ) -> Duration.equal offset d) <|
            toSequence measure


modifyNote : (Note -> Note) -> Offset -> Measure -> Measure
modifyNote f offset measure =
    let
        seq =
            toSequence measure

        note =
            Maybe.withDefault
                (Note.restFor Duration.quarter)
                (findNote offset measure)
    in
    spliceSequence ( offset, f note ) seq
        |> fromSequence measure.attributes
        |> aggregateRests


spliceNote : ( Offset, Note ) -> ( Offset, Note ) -> Sequence
spliceNote ( b0, n0 ) ( b1, n1 ) =
    let
        e0 =
            Duration.add n0.duration b0

        e1 =
            Duration.add n1.duration b1

        clipFromTo b e n =
            { n | duration = Duration.subtract b e }

        restFromTo b e _ =
            restFor <| Duration.subtract b e
    in
    if not <| Duration.longerThan b0 e1 then
        -- no intersection
        [ ( b1, n1 ) ]

    else if not <| Duration.longerThan b1 e0 then
        -- no intersection
        [ ( b1, n1 ) ]

    else if Duration.equal b0 b1 then
        if Duration.shorterThan e1 e0 then
            -- insert n0 and rest for the remainder of n1
            [ ( b0, n0 )
            , ( e0, restFromTo e0 e1 n1 )
            ]

        else
            -- replace n1 with n0
            [ ( b0, n0 ) ]

    else if Duration.shorterThan b0 b1 then
        if Duration.shorterThan e1 e0 then
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

    else if Duration.shorterThan e1 e0 then
        -- clip off beginning of n1
        [ ( e0, clipFromTo e0 e1 n1 ) ]

    else
        -- completely spliced out
        []


spliceSequence : ( Offset, Note ) -> Sequence -> Sequence
spliceSequence bn seq =
    List.map (spliceNote bn) seq
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
