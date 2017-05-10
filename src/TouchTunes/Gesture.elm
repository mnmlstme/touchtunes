module TouchTunes.Gesture
    exposing
        ( Gesture
        , Gesture(..)
        , Action(..)
        , start
        , current
        , furthest
        , update
        )

import Music.Measure.Layout
    exposing
        ( Location
        )


type Gesture
    = Idle
    | Touch Location
    | Drag Location Location
    | Reversal Location Location Location


type Action
    = StartGesture Location
    | ContinueGesture Location
    | FinishGesture


start : Gesture -> Maybe Location
start g =
    case g of
        Idle ->
            Nothing

        Touch start ->
            Just start

        Drag start _ ->
            Just start

        Reversal start _ _ ->
            Just start


current : Gesture -> Maybe Location
current g =
    case g of
        Idle ->
            Nothing

        Touch current ->
            Just current

        Drag _ current ->
            Just current

        Reversal _ _ current ->
            Just current


furthest : Gesture -> Maybe Location
furthest g =
    case g of
        Idle ->
            Nothing

        Touch furthest ->
            Just furthest

        Drag _ furthest ->
            Just furthest

        Reversal _ furthest _ ->
            Just furthest


update : Action -> Gesture -> Gesture
update action gesture =
    let
        tolerance =
            5

        xMotion a b =
            a.beat
                /= b.beat
                || abs (a.shiftx.ths - b.shiftx.ths)
                > tolerance

        yMotion a b =
            a.step /= b.step
    in
        case action of
            StartGesture loc ->
                Touch loc

            ContinueGesture loc ->
                case gesture of
                    Idle ->
                        gesture

                    Touch from ->
                        if xMotion from loc then
                            Drag from loc
                        else if yMotion from loc then
                            Touch loc
                        else
                            gesture

                    Drag from to ->
                        if abs (loc.beat - from.beat) < abs (to.beat - from.beat) then
                            Reversal from to loc
                        else
                            Drag from loc

                    Reversal from to _ ->
                        if from.beat == loc.beat then
                            Touch loc
                        else if abs (loc.beat - from.beat) < abs (to.beat - from.beat) then
                            Reversal from to loc
                        else
                            Drag from loc

            FinishGesture ->
                Idle
