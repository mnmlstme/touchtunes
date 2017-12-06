module MusicTests exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Music.Time as Time
import Music.Measure.Model as Measure


newMeasureTest =
    test "a new measure is common (4/4) time" <|
        \_ ->
            let
                m =
                    Measure.new
            in
                Measure.time m
                    |> Expect.equal Time.common
