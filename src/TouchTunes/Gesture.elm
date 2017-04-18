module TouchTunes.Gesture
    exposing
        ( Gesture
        , Gesture(..)
        , Action(..)
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
