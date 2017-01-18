module Music.Part
    exposing
        ( Part
        , empty
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
import Music.Measure.Model as Measure exposing (Measure)
import Music.Measure.Action as MeasureAction
import Music.Measure.View as MeasureView


type alias Part =
    { name : String
    , abbrev : String
    , measures : Array Measure
    }


empty : Part
empty =
    Part
        "Piano"
        "Pno."
        (Array.repeat 4 Measure.empty)


type Action
    = OnMeasure Int MeasureAction.Action


update : Action -> Part -> Part
update msg part =
    case msg of
        OnMeasure n action ->
            case Array.get n part.measures of
                Nothing ->
                    part

                Just m ->
                    { part
                        | measures =
                            Array.set n
                                (MeasureAction.update action m)
                                part.measures
                    }


countMeasures : Part -> Int
countMeasures p =
    Array.length p.measures


view : Part -> Html Action
view part =
    let
        measureView n measure =
            Html.map (OnMeasure n) (MeasureView.view measure)
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
