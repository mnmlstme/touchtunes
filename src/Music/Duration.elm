module Music.Duration
    exposing
        ( Duration
        , division
        , whole
        , half
        , quarter
        , eighth
        , sixteenth
        , thirtysecond
        , sixtyfourth
        , dotted
        , beats
        , isWhole
        )

import Music.Time exposing (Time, Beat)


-- Duration expressed as a certain integer number of
-- divisions (typically 1, 2, 4, 8, 16, ... but left open
-- allow for tuples of any size).
-- E.g., dotted quarter == Duration 3 8


type alias Duration =
    { count : Int
    , divisor : Int
    }


division : Int -> Duration
division =
    Duration 1


whole : Duration
whole =
    division 1


half : Duration
half =
    division 2


quarter : Duration
quarter =
    division 4


eighth : Duration
eighth =
    division 8


sixteenth : Duration
sixteenth =
    division 16


thirtysecond : Duration
thirtysecond =
    division 32


sixtyfourth : Duration
sixtyfourth =
    division 64


dotted : Duration -> Duration
dotted d =
    Duration (d.count * 3) (d.divisor * 2)


beats : Time -> Duration -> Beat
beats time d =
    d.count * (time.divisor // d.divisor)


isWhole : Time -> Duration -> Bool
isWhole time d =
    let
        b =
            beats time d
    in
        b >= time.beats
