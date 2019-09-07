module MusicTests exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Fuzz exposing (Fuzzer, intRange)


-- Modules under test:

import Music.Measure.Model as Measure
import Music.Time as Time
import Music.Note.Model as Note
import Music.Duration as Duration
import Music.Pitch as Pitch


newMeasureTest =
    describe "new measures" <|
        let
            m =
                Measure.new
        in
            [ test "are common (4/4) time" <|
                \_ ->
                    Measure.time m
                        |> Expect.equal Time.common
            , test "have 4 beats" <|
                \_ ->
                    Measure.length m
                        |> Expect.equal 4
            , test "contain exactly one note" <|
                \_ ->
                    Measure.toSequence m
                        |> List.length
                        |> Expect.equal 1
            , test "contains a note on beat 'one'" <|
                \_ ->
                    Measure.toSequence m
                        |> List.head
                        |> Maybe.map Tuple.first
                        |> Expect.equal (Just 0)
            , test "contains a whole rest" <|
                \_ ->
                    Measure.toSequence m
                        |> List.head
                        |> Maybe.map Tuple.second
                        |> Expect.equal (Just (Note.restFor Duration.whole))
            ]


insertFirstNoteTest =
    describe "after inserting the first note in a new measure" <|
        let
            m =
                Measure.new

            dur d =
                Duration.fromTimeBeats Time.common d

            insert d =
                \_ -> Note.playFor (dur d) (Pitch.c 4)

            m_ b d =
                Measure.modifyNote (insert d) b m

            testBeatDur =
                fuzz2 (intRange 0 3) (intRange 1 4)
        in
            [ testBeatDur "the measure has at least the same number of beats" <|
                \b d ->
                    m_ b d
                        |> Measure.length
                        |> Expect.atLeast (Measure.length m)
            , testBeatDur "the measure has no more beats than needed" <|
                \b d ->
                    m_ b d
                        |> Measure.length
                        |> Expect.atMost (max (b + d) 4)
            , testBeatDur "the measure will have exactly one played note" <|
                \b d ->
                    m_ b d
                        |> Measure.toSequence
                        |> List.map Tuple.second
                        |> List.filter Note.isPlayed
                        |> List.length
                        |> Expect.equal 1
            , testBeatDur "the measure will have at most two unplayed notes" <|
                \b d ->
                    m_ b d
                        |> Measure.toSequence
                        |> List.map Tuple.second
                        |> List.filter (not << Note.isPlayed)
                        |> List.length
                        |> Expect.atMost 2
            ]
