module Music.Part
    exposing
        ( Part
        , countMeasures
        , view
        )

import Music.Measure as Measure exposing (Measure)
import Html
    exposing
        ( Html
        , section
        , header
        , div
        , h3
        , text
        )
import Html.Attributes exposing (class)


type alias Part =
    { name : String
    , abbrev : String
    , measures : List Measure
    }


countMeasures : Part -> Int
countMeasures p =
    List.length p.measures


view : Part -> Html msg
view part =
    section [ class "part" ]
        [ header [ class "part-header" ]
            [ h3 [ class "part-abbrev" ]
                [ text part.abbrev ]
            ]
        , div [ class "part-body" ]
            (List.map Measure.view part.measures)
        ]
