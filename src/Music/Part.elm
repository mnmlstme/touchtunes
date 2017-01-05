module Music.Part
    exposing
        ( Part
        , part
        , Action
        , update
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


type Action
    = MeasureAction Int Measure.Action


update : Action -> Part -> Part
update msg part =
    case msg of
        MeasureAction n action ->
            case Array.get n part.measures of
                Nothing ->
                    part

                Just m ->
                    { part
                        | measures =
                            Array.set n
                                (Measure.update action m)
                                part.measures
                    }


countMeasures : Part -> Int
countMeasures p =
    Array.length p.measures


view : Part -> Html Action
view part =
    let
        measureView n measure =
            Html.map (MeasureAction n) (Measure.view measure)
    in
        section [ class "part" ]
            [ header [ class "part-header" ]
                [ h3 [ class "part-abbrev" ]
                    [ text part.abbrev ]
                ]
            , div
                [ class "part-body" ]
                (Array.toList <| Array.indexedMap measureView part.measures)
            ]
