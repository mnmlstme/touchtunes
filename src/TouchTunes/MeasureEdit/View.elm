module TouchTunes.MeasureEdit.View
    exposing
        ( view
        )

import TouchTunes.MeasureEdit.Ruler as Ruler
import TouchTunes.MeasureEdit.Model exposing (MeasureEdit)
import TouchTunes.MeasureEdit.Action as Action exposing (Action)
import TouchTunes.MeasureEdit.HeadUpDisplay as HeadUpDisplay exposing (HeadUpDisplay)
import Music.Measure.View as MeasureView exposing (layoutFor)
import Music.Measure.Layout as Layout exposing (positionToLocation)
import Json.Decode as Decode exposing (Decoder, field, int)
import Mouse
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (on)


mouseOffset : Decoder Mouse.Position
mouseOffset =
    -- TODO: submit PR to elm-lang/mouse to add mouseOffset
    Decode.map2 Mouse.Position
        (field "offsetX" int)
        (field "offsetY" int)


view : MeasureEdit -> Html Action
view editor =
    let
        hudview =
            case editor.hud of
                Just hud ->
                    [ HeadUpDisplay.view hud ]

                Nothing ->
                    []

        layout =
            layoutFor editor.measure

        toLocation =
            positionToLocation layout

        down =
            on "mousedown" <|
                Decode.map Action.StartGesture <|
                    Decode.map toLocation mouseOffset
    in
        div
            [ class "measure-editor"
            , down
            ]
        <|
            List.append
                [ MeasureView.view editor.measure
                , Ruler.view editor.measure
                ]
                hudview
