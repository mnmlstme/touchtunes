module TouchTunes.Views.EditorView exposing (view)

import Array exposing (Array)
import Array.Extra
import CssModules as CssModules
import Debug exposing (log)
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
import Html.Attributes exposing (class, classList)
import Html.Events.Extra.Pointer as Pointer
import Json.Decode as Decode exposing (Decoder, field, int)
import List.Nonempty as Nonempty exposing (Nonempty)
import Music.Models.Layout as Layout exposing (Layout)
import Music.Models.Measure as Measure exposing (Measure)
import Music.Models.Part as Part exposing (Part, propagateAttributes)
import Music.Models.Score as Score exposing (Score)
import Music.Models.Time as Time
import Music.Views.MeasureView as MeasureView
import TouchTunes.Actions.Top as Action exposing (Msg(..))
import TouchTunes.Models.Controls as Controls
import TouchTunes.Models.Dial as Dial
import TouchTunes.Models.Editor as Editor exposing (Editor)
import TouchTunes.Views.OverlayView as Overlay exposing (pointerCoordinates)
import TouchTunes.Views.RulerView as Ruler
import Tuple exposing (pair)


partCss =
    .toString <|
        CssModules.css "./Music/Views/css/part.css"
            { part = "part"
            , header = "header"
            , abbrev = "abbrev"
            , body = "body"
            }


frameCss =
    .toString <|
        CssModules.css "./TouchTunes/Views/css/frame.css"
            { frame = "frame"
            , header = "header"
            , body = "body"
            , controls = "controls"
            }


scoreCss =
    .toString <|
        CssModules.css "./Music/Views/css/score.css"
            { title = "title"
            , parts = "parts"
            , stats = "stats"
            }


editorCss =
    .toString <|
        CssModules.css "./TouchTunes/Views/css/editor.css"
            { editor = "editor" }


view : Editor -> Html Msg
view editor =
    let
        s =
            editor.score

        tracking =
            editor.tracking

        nParts =
            Score.countParts s

        nMeasures =
            Score.length s
    in
    article
        [ class <| frameCss .frame ]
        [ header [ class <| frameCss .header ]
            [ h1 [ class <| scoreCss .title ]
                [ text s.title ]
            , dl [ class <| scoreCss .stats ]
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
            [ classList
                [ ( frameCss .body, True )
                , ( scoreCss .parts, False )
                ]
            ]
          <|
            Array.toList <|
                Array.indexedMap (viewPart editor) editor.score.parts
        , nav
            [ class <| frameCss .controls ]
            [ Controls.viewSubdivisionDial
                tracking.subdivisionDial
                editor.subdivisionSetting
            , Controls.viewAlterationDial
                tracking.alterationDial
                editor.alterationSetting
            ]
        ]


viewPart : Editor -> Int -> Part -> Html Msg
viewPart editor i part =
    let
        layoutMeasures =
            Array.Extra.map2
                (\a m -> ( Layout.forMeasure a m, m ))
                (propagateAttributes part.measures)
                part.measures
    in
    section
        [ class <| partCss .part
        ]
        [ header [ class <| partCss .header ]
            [ h3 [ class <| partCss .abbrev ]
                [ text part.abbrev ]
            ]
        , div
            [ class <| partCss .body ]
          <|
            Array.toList <|
                Array.indexedMap (viewMeasure editor i) layoutMeasures
        ]


viewMeasure : Editor -> Int -> Int -> ( Layout, Measure ) -> Html Msg
viewMeasure editor i j ( layout, measure ) =
    let
        m =
            if editor.partNum == i && editor.measureNum == j then
                case Editor.measure editor of
                    Just theMeasure ->
                        theMeasure

                    Nothing ->
                        measure

            else
                measure

        l =
            if editor.partNum == i && editor.measureNum == j then
                let
                    t =
                        Layout.time layout

                    div =
                        editor.subdivisionSetting.divisor // Time.divisor t
                in
                Layout.subdivide div layout

            else
                layout

        cursor =
            if editor.partNum == i && editor.measureNum == j then
                editor.cursor

            else
                Nothing

        downHandler =
            Pointer.onDown <|
                pointerCoordinates
                    >> Tuple.mapBoth floor floor
                    >> Action.StartEdit layout i j
    in
    div
        [ class <| editorCss .editor, downHandler ]
        [ MeasureView.view layout m
        , case cursor of
            Just beat ->
                Overlay.view layout m beat

            Nothing ->
                text ""
        , Ruler.view l
        ]
