module Music.Part
    exposing
        ( Part
        , part
        , countMeasures
        , view
        )

import Array as Array exposing (Array)
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
import Music.Measure as Measure exposing (Measure)


type alias Part =
    { name : String
    , abbrev : String
    , measures : Array Measure
    }


part : String -> String -> List Measure -> Part
part n a list =
    Part n a (Array.fromList list)


countMeasures : Part -> Int
countMeasures p =
    Array.length p.measures


view : Part -> Html msg
view part =
    section [ class "part" ]
        [ header [ class "part-header" ]
            [ h3 [ class "part-abbrev" ]
                [ text part.abbrev ]
            ]
        , div [ class "part-body" ]
            (Array.toList <| Array.map Measure.view part.measures)
        ]
