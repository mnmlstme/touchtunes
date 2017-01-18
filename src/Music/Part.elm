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
import Music.Time exposing (Beat)
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


view : Maybe ( Int, Beat ) -> Part -> Html Action
view cursor part =
    let
        addr i =
            case cursor of
                Nothing ->
                    Nothing

                Just ( n, beat ) ->
                    if i == n then
                        Just beat
                    else
                        Nothing

        measureView i measure =
            Html.map
                (OnMeasure i)
                (MeasureView.view (addr i) measure)
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
