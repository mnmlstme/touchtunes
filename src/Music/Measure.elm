module Music.Measure
    exposing
        ( Measure
        , view
        )

import Music.Note as Note exposing (Note)
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
    div [ class "measure" ]
        (List.map Note.view measure.notes)
