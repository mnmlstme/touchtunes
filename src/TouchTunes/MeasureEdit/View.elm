module TouchTunes.MeasureEdit.View
    exposing
        ( view
        )

import TouchTunes.MeasureEdit.Ruler as Ruler
import TouchTunes.MeasureEdit.Model exposing (MeasureEdit)
import TouchTunes.MeasureEdit.Action exposing (Action)
import TouchTunes.MeasureEdit.HeadUpDisplay as HeadUpDisplay exposing (HeadUpDisplay)
import Music.Measure.View as MeasureView exposing (layoutFor)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)


view : MeasureEdit -> Html Action
view editor =
    div
        [ class "measure-editor" ]
        [ MeasureView.view editor.measure
        , Ruler.view editor.measure
        , HeadUpDisplay.view editor.hud
        ]
