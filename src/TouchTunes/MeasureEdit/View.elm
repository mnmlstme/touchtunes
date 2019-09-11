module TouchTunes.MeasureEdit.View exposing (view)

import Html exposing (Html, div, text)
import CssModules exposing (css)
import Html.Events exposing (on)
import Svg exposing (Svg, circle, g, rect, svg)
import Svg.Attributes exposing (class, transform)
import Json.Decode as Decode exposing (Decoder, field, int)
import Music.Measure.Layout as Layout
    exposing
        ( positionToLocation
        , beatSpacing
        , scaleStartBeat
        , Pixels
        , xPx
        , yPx
        , widthPx
        , heightPx
        )
import Music.Measure.View as MeasureView exposing (layoutFor)
import TouchTunes.MeasureEdit.Action as Action exposing (Action)
import TouchTunes.MeasureEdit.HeadUpDisplay as HeadUpDisplay exposing (HeadUpDisplay)
import TouchTunes.MeasureEdit.Model exposing (MeasureEdit)
import TouchTunes.MeasureEdit.Ruler as Ruler
import Tuple exposing (pair)


mouseOffset : Decoder ( Int, Int )
mouseOffset =
    Decode.map2 pair
        (field "offsetX" int)
        (field "offsetY" int)


view : MeasureEdit -> Html Action
view editor =
    let
        styles =
            css "./TouchTunes/MeasureEdit/editor.css"
                { editor = "editor"
                , selection = "selection"
                }

        layout =
            layoutFor editor.measure

        toLocation =
            positionToLocation layout

        down =
            on "mousedown" <|
                Decode.map Action.Start <|
                    Decode.map toLocation mouseOffset
    in
        div
            [ styles.class .editor
            , down
            ]
            [ case editor.selection of
                Just beat ->
                    svg
                        [ class <| styles.toString .selection
                        , heightPx <| Layout.height layout
                        , widthPx <| Layout.width layout
                        ]
                        [ rect
                            [ widthPx <| beatSpacing layout
                            , xPx <| scaleStartBeat layout beat
                            , yPx <| Pixels 0
                            , heightPx <| Layout.height layout
                            ]
                            []
                        ]

                Nothing ->
                    text ""
            , MeasureView.view editor.measure
            , Ruler.view editor.measure
            , case editor.hud of
                Just hud ->
                    HeadUpDisplay.view hud

                Nothing ->
                    text ""
            ]
