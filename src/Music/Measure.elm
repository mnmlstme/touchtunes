module Music.Measure
    exposing
        ( Measure
        , view
        )

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


view : Measure -> Html msg
view measure =
    let
        width =
            200

        staff =
            Staff.treble

        layout =
            Staff.layout 2.0 width
    in
        div [ class "measure" ]
            [ Staff.view staff layout measure.notes ]



-- (List.map Note.view measure.notes)
