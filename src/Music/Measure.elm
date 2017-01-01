module Music.Measure
    exposing
        ( Measure
        , view
        )

import Html
    exposing
        ( Html
        , div
        , span
        , text
        )
import Html.Attributes exposing (class)


-- temporary Note alias:


type alias Note =
    String


type alias Measure =
    { notes : List Note
    }


view : Measure -> Html msg
view measure =
    let
        node s =
            span [ class "note" ] [ text s ]
    in
        div [ class "measure" ]
            (List.map node measure.notes)
