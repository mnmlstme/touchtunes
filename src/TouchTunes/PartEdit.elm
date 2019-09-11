module TouchTunes.PartEdit
    exposing
        ( Action
        , PartEdit
        , open
        , update
        , view
        )

import Array exposing (Array)
import Html
    exposing
        ( Html
        , div
        , h3
        , header
        , section
        , text
        )
import CssModules exposing (css)
import Music.Part.Model as Part exposing (Part)
import TouchTunes.MeasureEdit.Action as MeasureEditAction
import TouchTunes.MeasureEdit.Model as MeasureEdit exposing (MeasureEdit)
import TouchTunes.MeasureEdit.Update as MeasureEditUpdate
import TouchTunes.MeasureEdit.View as MeasureEditView


type alias PartEdit =
    { active : Maybe ( Int, MeasureEdit )
    , part : Part
    }


type Action
    = OnMeasure Int MeasureEditAction.Action


open : Part -> PartEdit
open part =
    PartEdit Nothing part


children : PartEdit -> Array MeasureEdit
children editor =
    let
        edit i =
            case editor.active of
                Nothing ->
                    MeasureEdit.open

                Just ( n, active ) ->
                    if i == n then
                        \m -> active
                    else
                        MeasureEdit.open
    in
        Array.indexedMap edit editor.part.measures


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
                                MeasureEditUpdate.update action m

                            newPart =
                                Part.set n updated.measure editor.part
                        in
                            { editor
                                | active = Just ( n, updated )
                                , part = newPart
                            }


view : PartEdit -> Html Action
view editor =
    let
        styles =
            css "./Music/Part/part.css"
                { part = "part"
                , header = "header"
                , abbrev = "abbrev"
                , body = "body"
                }

        measureView i child =
            Html.map (OnMeasure i) (MeasureEditView.view child)
    in
        section [ styles.class .part ]
            [ header [ styles.class .header ]
                [ h3 [ styles.class .abbrev ]
                    [ text editor.part.abbrev ]
                ]
            , div
                [ styles.class .body ]
              <|
                Array.toList <|
                    Array.indexedMap measureView <|
                        children editor
            ]
