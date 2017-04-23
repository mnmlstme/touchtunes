module Music.Duration
    exposing
        ( Duration
        , fromTimeBeats
        , whole
        , half
        , quarter
        , eighth
        , sixteenth
        , thirtysecond
        , sixtyfourth
        , dotted
        , beats
        , setBeats
        , isWhole
        , longerThan
        , shorterThan
        , equal
        , add
        , shortenBy
        )

import Arithmetic exposing (lcm)
import Music.Time exposing (Time, Beat)


-- Duration expressed as a certain integer number of
-- divisions (typically 1, 2, 4, 8, 16, ... but left open
-- allow for tuples of any size).
-- E.g., dotted quarter == Duration 3 8


type alias Duration =
    -- TODO: reverse the order so count is last argument to constructor
    { count : Int
    , divisor : Int
    }


fromTimeBeats : Time -> Beat -> Duration
fromTimeBeats time beat =
    Duration beat time.divisor


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


setBeats : Time -> Beat -> Duration -> Duration
setBeats time b d =
    let
        count =
            b * (d.divisor // time.divisor)
    in
        Duration count d.divisor


isWhole : Time -> Duration -> Bool
isWhole time d =
    let
        b =
            beats time d
    in
        b >= time.beats


commonDivisor : Duration -> Duration -> Int
commonDivisor a b =
    lcm a.divisor b.divisor


changeDivisor : Int -> Duration -> Duration
changeDivisor div dur =
    Duration (dur.count * div // dur.divisor) div


makeCommon : ( Duration, Duration ) -> ( Duration, Duration )
makeCommon ( a, b ) =
    let
        change =
            changeDivisor <| commonDivisor a b
    in
        ( change a, change b )


longerThan : Duration -> Duration -> Bool
longerThan a b =
    let
        ( ac, bc ) =
            makeCommon ( a, b )
    in
        ac.count > bc.count


shorterThan : Duration -> Duration -> Bool
shorterThan a b =
    let
        ( ac, bc ) =
            makeCommon ( a, b )
    in
        ac.count < bc.count


equal : Duration -> Duration -> Bool
equal a b =
    let
        ( ac, bc ) =
            makeCommon ( a, b )
    in
        ac.count == bc.count


add : Duration -> Duration -> Duration
add a b =
    let
        ( ac, bc ) =
            makeCommon ( a, b )
    in
        { bc | count = ac.count + bc.count }


shortenBy : Beat -> Duration -> Duration
shortenBy n d =
    { d | count = d.count - n }
