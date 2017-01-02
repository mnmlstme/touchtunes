module Music.Measure
    exposing
        ( Measure
        , view
        )

import Music.Time as Time exposing (Time, Beat)
import Music.Note as Note exposing (Note)
import Music.Staff as Staff
import Html
    exposing
        ( Html
        , div
        , span
        , text
        )
import Html.Attributes exposing (class)


type alias Measure =
    { notes : List Note
    }


sequence : Time -> Measure -> List ( Beat, Note )
sequence time measure =
    let
        beats =
            List.map (Note.beats time) measure.notes

        startsAt =
            List.scanl (+) 0 beats
    in
        List.map2 (,) startsAt measure.notes


view : Measure -> Html msg
view measure =
    let
        time =
            Time.common

        staff =
            Staff.treble 2.0

        layout =
            Staff.layout staff time

        noteSequence =
            sequence time measure
    in
        div [ class "measure" ]
            [ Staff.view staff layout noteSequence ]
