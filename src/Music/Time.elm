module Music.Time
    exposing
        ( Time
        , Beat
        , common
        , cut
        , longer
        )


type alias Time =
    { beats : Beat
    , divisor : Divisor
    }


type alias Beat =
    Int


type alias Divisor =
    Int


common : Time
common =
    Time 4 4


cut : Time
cut =
    Time 2 2


longer : Time -> Beat -> Time
longer time beat =
    let
        b =
            max time.beats beat
    in
        Time b time.divisor
