module Music.Time exposing
    ( Time
    , common
    , cut
    , toDuration
    )

import Music.Duration exposing (Duration)


type alias Time =
    { beatsPerMeasure : Int
    , getsOneBeat : Int
    }


common : Time
common =
    Time 4 4


cut : Time
cut =
    Time 2 2


toDuration : Time -> Duration
toDuration time =
    Duration time.beatsPerMeasure time.getsOneBeat
