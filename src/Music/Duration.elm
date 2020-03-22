module Music.Duration exposing
    ( Duration
    , add
    , divideBy
    , division
    , dotted
    , eighth
    , equal
    , half
    , longerThan
    , quarter
    , shorterThan
    , sixteenth
    , sixtyfourth
    , subtract
    , thirtysecond
    , times
    , whole
    , zero
    )

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


zero : Duration
zero =
    Duration 0 1


times : Int -> Duration -> Duration
times multiplier dur =
    { dur | count = multiplier * dur.count }


divideBy : Int -> Duration -> Duration
divideBy divisor dur =
    { dur | divisor = divisor * dur.divisor }


dotted : Duration -> Duration
dotted d =
    Duration (d.count * 3) (d.divisor * 2)


commonDivisor : Duration -> Duration -> Int
commonDivisor a b =
    -- this only works if one divisor is a multiple of the other
    max a.divisor b.divisor


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
    ac.count < bc.count


shorterThan : Duration -> Duration -> Bool
shorterThan a b =
    let
        ( ac, bc ) =
            makeCommon ( a, b )
    in
    ac.count > bc.count


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
    reduce { bc | count = ac.count + bc.count }


subtract : Duration -> Duration -> Duration
subtract a b =
    let
        ( ac, bc ) =
            makeCommon ( a, b )
    in
    reduce { bc | count = bc.count - ac.count }


reduce : Duration -> Duration
reduce d =
    -- TODO this properly by finding greatest common factor
    if modBy d.divisor d.count == 0 then
        Duration (d.count // d.divisor) 1

    else if modBy (d.divisor // 2) d.count == 0 then
        Duration (2 * d.count // d.divisor) 2

    else if modBy (d.divisor // 4) d.count == 0 then
        Duration (4 * d.count // d.divisor) 4

    else
        d
