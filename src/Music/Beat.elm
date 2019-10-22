module Music.Beat exposing
    ( Beat
    , add
    , durationFrom
    , earlierThan
    , equal
    , fitToTime
    , fromDuration
    , fullBeat
    , laterThan
    , roundTo
    , subtract
    , toDuration
    , toFloat
    , zero
    )

import Music.Duration as Duration exposing (Duration)
import Music.Time exposing (Time)


type alias Beat =
    { parts : Int
    , divisor : Int
    , full : Int
    }


zero : Beat
zero =
    Beat 0 0 0


fullBeat : Int -> Beat
fullBeat =
    Beat 0 0


toFloat : Beat -> Float
toFloat b =
    Basics.toFloat b.full
        + (if b.parts /= 0 then
            Basics.toFloat b.parts / Basics.toFloat b.divisor

           else
            0
          )


toDuration : Time -> Beat -> Duration
toDuration time beat =
    Duration.add
        (Duration beat.full time.getsOneBeat)
        (Duration beat.parts (beat.divisor * time.getsOneBeat))


fromDuration : Time -> Duration -> Beat
fromDuration time d =
    if d.divisor > time.getsOneBeat then
        let
            div =
                d.divisor // time.getsOneBeat
        in
        { full = d.count // div
        , parts = modBy div d.count
        , divisor = div
        }

    else
        fullBeat <| d.count * time.getsOneBeat // d.divisor


add : Time -> Duration -> Beat -> Beat
add t d b =
    fromDuration t <|
        Duration.add d <|
            toDuration t b


subtract : Time -> Duration -> Beat -> Beat
subtract t d b =
    fromDuration t <|
        Duration.subtract d <|
            toDuration t b


durationFrom : Time -> Beat -> Beat -> Duration
durationFrom t a b =
    Duration.subtract (toDuration t b) (toDuration t a)


laterThan : Beat -> Beat -> Bool
laterThan a b =
    toFloat a < toFloat b


earlierThan : Beat -> Beat -> Bool
earlierThan a b =
    toFloat a > toFloat b


equal : Beat -> Beat -> Bool
equal a b =
    toFloat a == toFloat b


fitToTime : Time -> Beat -> Time
fitToTime time beats =
    -- create a new Time that fits a given number of beats
    let
        b =
            max time.beatsPerMeasure
                (beats.full
                    + (if beats.parts /= 0 then
                        1

                       else
                        0
                      )
                )
    in
    Time b time.getsOneBeat


roundTo : Duration -> Float -> Beat
roundTo dur x =
    let
        divisor =
            dur.divisor

        totalParts =
            floor (x * Basics.toFloat divisor)
    in
    { full = totalParts // divisor
    , parts = modBy divisor totalParts
    , divisor = divisor
    }
