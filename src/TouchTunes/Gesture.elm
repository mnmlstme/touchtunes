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


type Action
    = StartGesture Location
    | ContinueGesture Location
    | FinishGesture


update : Action -> Gesture -> Gesture
update action gesture =
    case action of
        StartGesture from ->
            Touch from

        ContinueGesture to ->
            case gesture of
                Idle ->
                    gesture

                Touch from ->
                    Drag from to

                Drag from _ ->
                    Drag from to

        FinishGesture ->
            Idle
