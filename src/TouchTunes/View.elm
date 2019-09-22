module TouchTunes.View exposing (view)

import Array exposing (Array)
import CssModules exposing (css)
import Html
    exposing
        ( Html
        , article
        , dd
        , div
        , dl
        , dt
        , footer
        , h1
        , h3
        , header
        , nav
        , section
        , text
        )
import Html.Attributes exposing (class)
import Html.Events exposing (on, onMouseUp)
import Json.Decode as Decode exposing (Decoder, field, int)
import Music.Measure.Layout as Layout
    exposing
        ( Pixels
        , beatSpacing
        , heightPx
        , positionToLocation
        , scaleStartBeat
        , widthPx
        , xPx
        , yPx
        )
import Music.Measure.Model as Measure exposing (Measure)
import Music.Measure.View as MeasureView exposing (layoutFor)
import Music.Part.Model as Part exposing (Part)
import Music.Score.Model as Score exposing (Score)
import Svg exposing (Svg, circle, g, rect, svg)
import Svg.Attributes exposing (class, transform)
import TouchTunes.Action as Action exposing (Action(..))
import TouchTunes.Controls as Controls
import TouchTunes.Dial as Dial
import TouchTunes.Model as Editor exposing (Editor)
import TouchTunes.Ruler as Ruler
import Tuple exposing (pair)


view : Editor -> Html Action
view editor =
    let
        frameStyles =
            css "./TouchTunes/frame.css"
                { frame = "frame"
                , header = "header"
                , body = "body"
                , controls = "controls"
                }

        styles =
            css "./Music/Score/score.css"
                { title = "title"
                , parts = "parts"
                , stats = "stats"
                }

        s =
            editor.score

        controls =
            editor.controls

        nParts =
            Score.countParts s

        nMeasures =
            Score.length s
    in
    article
        [ frameStyles.class .frame ]
        [ header [ frameStyles.class .header ]
            [ h1 [ styles.class .title ]
                [ text s.title ]
            , dl [ styles.class .stats ]
                [ dt []
                    [ text "Parts" ]
                , dd []
                    [ text (String.fromInt nParts) ]
                , dt []
                    [ text "Measures" ]
                , dd []
                    [ text (String.fromInt nMeasures) ]
                ]
            ]
        , div
            [ class <|
                frameStyles.toString .body
                    ++ " "
                    ++ styles.toString .parts
            ]
          <|
            Array.toList <|
                Array.indexedMap (viewPart editor) editor.score.parts
        , nav
            [ frameStyles.class .controls ]
            [ Html.map DurationControl <|
                Dial.view controls.durationDial editor.durationSetting
            ]
        ]


viewPart : Editor -> Int -> Part -> Html Action
viewPart editor i part =
    let
        styles =
            css "./Music/Part/part.css"
                { part = "part"
                , header = "header"
                , abbrev = "abbrev"
                , body = "body"
                }
    in
    section
        [ styles.class .part
        , onMouseUp Action.FinishEdit
        ]
        [ header [ styles.class .header ]
            [ h3 [ styles.class .abbrev ]
                [ text part.abbrev ]
            ]
        , div
            [ styles.class .body ]
          <|
            Array.toList <|
                Array.indexedMap (viewMeasure editor i) part.measures
        ]


mouseOffset : Decoder ( Int, Int )
mouseOffset =
    Decode.map2 pair
        (field "offsetX" int)
        (field "offsetY" int)


viewMeasure : Editor -> Int -> Int -> Measure -> Html Action
viewMeasure editor i j measure =
    let
        styles =
            css "./TouchTunes/editor.css"
                { editor = "editor"
                , selection = "selection"
                }

        m =
            case editor.measure of
                Just theMeasure ->
                    if editor.partNum == i && editor.measureNum == j then
                        theMeasure

                    else
                        measure

                Nothing ->
                    measure

        layout =
            layoutFor m

        toLocation =
            positionToLocation layout

        selection =
            Nothing
    in
    div
        [ styles.class .editor
        , on "mousedown" <|
            Decode.map (Action.StartEdit i j) <|
                Decode.map toLocation mouseOffset
        ]
        [ case selection of
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
        , MeasureView.view m
        , Ruler.view measure
        ]
