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
    case action of
        StartGesture loc ->
            Touch loc

        ContinueGesture loc ->
            case gesture of
                Idle ->
                    gesture

                Touch from ->
                    Drag from loc

                Drag from to ->
                    if abs (loc.beat - from.beat) < abs (to.beat - from.beat) then
                        Reversal from to loc
                    else
                        Drag from loc

                Reversal from to _ ->
                    if abs (loc.beat - from.beat) < abs (to.beat - from.beat) then
                        Reversal from to loc
                    else
                        Drag from loc

        FinishGesture ->
            Idle
