module Music.Models.Beat exposing
    ( Beat
    , add
    , durationFrom
    , earlierThan
    , equal
    , fitToTime
    , fromDuration
    , fullBeat
    , halfBeat
    , laterThan
    , subtract
    , toDuration
    , toFloat
    , zero
    )

import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Time as Time exposing (Time)


type alias Beat =
    { full : Int
    , parts : Int
    , divisor : Int
    }


zero : Beat
zero =
    Beat 0 0 1


fullBeat : Int -> Beat
fullBeat n =
    Beat n 0 1


halfBeat : Int -> Beat
halfBeat n =
    Beat 0 n 2


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
        (Duration beat.full <| Time.divisor time)
        (Duration beat.parts (beat.divisor * Time.divisor time))


fromDuration : Time -> Duration -> Beat
fromDuration time d =
    if d.divisor > Time.divisor time then
        let
            div =
                d.divisor // Time.divisor time
        in
        { full = d.count // div
        , parts = modBy div d.count
        , divisor = div
        }

    else
        fullBeat <| d.count * Time.divisor time // d.divisor


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
    Duration.subtract (toDuration t a) (toDuration t b)


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
            max time.beats
                (beats.full
                    + (if beats.parts /= 0 then
                        1

                       else
                        0
                      )
                )
    in
    Time b time.beatType
