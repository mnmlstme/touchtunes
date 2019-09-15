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
import Html.Events exposing (on)
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
import TouchTunes.Action as Action exposing (Action)
import TouchTunes.Controls as Controls
import TouchTunes.Dial as Dial
import TouchTunes.HeadUpDisplay as HeadUpDisplay exposing (HeadUpDisplay)
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
            [ Dial.view Controls.durationDial editor.durationSetting
            ]
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

        layout =
            layoutFor measure

        toLocation =
            positionToLocation layout

        down =
            on "mousedown" <|
                Decode.map (Action.Start i j) <|
                    Decode.map toLocation mouseOffset

        selection =
            Nothing

        hud =
            Editor.hudForMeasure i j editor
    in
    div
        [ styles.class .editor
        , down
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
        , MeasureView.view measure
        , Ruler.view measure
        , case hud of
            Just theHud ->
                HeadUpDisplay.view theHud

            Nothing ->
                text ""
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
    section [ styles.class .part ]
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
