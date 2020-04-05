module Music.Models.Time exposing
    ( BeatType(..)
    , Time
    , common
    , cut
    , divisor
    , equal
    , toDuration
    )

import Music.Models.Duration exposing (Duration)
import TypedSvg.Core exposing (Svg)


type BeatType
    = Two
    | Four
    | Eight


type alias Time =
    { beats : Int
    , beatType : BeatType
    }


common : Time
common =
    Time 4 Four


cut : Time
cut =
    Time 2 Two


equal : Time -> Time -> Bool
equal atime btime =
    atime.beatType
        == btime.beatType
        && atime.beats
        == btime.beats


divisor : Time -> Int
divisor time =
    case time.beatType of
        Two ->
            2

        Four ->
            4

        Eight ->
            8


toDuration : Time -> Duration
toDuration time =
    Duration time.beats <| divisor time
