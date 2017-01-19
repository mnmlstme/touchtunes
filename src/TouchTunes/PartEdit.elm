module TouchTunes.PartEdit
    exposing
        ( PartEdit
        , view
        , Action
        , update
        )

import TouchTunes.MeasureEdit as MeasureEdit exposing (MeasureEdit)
import Music.Time exposing (Beat)
import Music.Part as Part exposing (Part)
import Array exposing (Array)
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


type alias PartEdit =
    { part : Part
    }


type Action
    = OnMeasure Int MeasureEdit.Action


children : PartEdit -> Array MeasureEdit
children editor =
    Array.map (MeasureEdit Nothing) editor.part.measures


update : Action -> PartEdit -> PartEdit
update msg editor =
    case msg of
        OnMeasure n action ->
            let
                subs =
                    children editor
            in
                case Array.get n subs of
                    Nothing ->
                        editor

                    Just m ->
                        let
                            updated =
                                MeasureEdit.update action m

                            newPart =
                                Part.set n updated.measure editor.part
                        in
                            { editor | part = newPart }


view : PartEdit -> Html Action
view editor =
    let
        measureView i child =
            Html.map (OnMeasure i) (MeasureEdit.view child)
    in
        section [ class "part" ]
            [ header [ class "part-header" ]
                [ h3 [ class "part-abbrev" ]
                    [ text editor.part.abbrev ]
                ]
            , div
                [ class "part-body" ]
              <|
                Array.toList <|
                    Array.indexedMap measureView <|
                        children editor
            ]
