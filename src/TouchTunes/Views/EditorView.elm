module TouchTunes.Views.EditorView exposing (view, viewScreen)

import Array exposing (Array)
import Array.Extra
import Debug exposing (log)
import Html
    exposing
        ( Html
        , article
        , button
        , dd
        , div
        , dl
        , dt
        , footer
        , h1
        , h3
        , header
        , li
        , section
        , text
        , ul
        )
import Html.Attributes exposing (class, classList, style)
import Html.Events exposing (onClick)
import Music.Models.Beat exposing (Beat)
import Music.Models.Key exposing (keyName)
import Music.Models.Layout as Layout exposing (Layout, Pixels, scaleBeat)
import Music.Views.MeasureView as MeasureView
import String exposing (fromFloat)
import Svg as Svg exposing (Svg, g, svg)
import Svg.Attributes as SvgAttr
    exposing
        ( height
        , transform
        , viewBox
        , width
        )
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Models.Editor as Editor exposing (Editor)
import TouchTunes.Models.Overlay exposing (Selection(..))
import Vectrol.Views.ButtonView as Button
import Vectrol.Views.DialView as Dial
import TouchTunes.Views.EditorStyles exposing (css)
import TouchTunes.Views.OverlayView as OverlayView
import TouchTunes.Views.RulerView as RulerView

fromPixels : Pixels -> String
fromPixels p =
    fromFloat p.px


view : Editor -> Html Msg
view editor =
    article [ class (css .frame) ]
        [ viewControls editor
        , viewMeasure editor
        ]


viewScreen : Html Msg
viewScreen =
    div [ class (css .screen) ] []


viewControls : Editor -> Svg Msg
viewControls editor =
    let
        controls =
            editor.controls

        overlay =
            editor.overlay

        dials =
            case overlay.selection of
                HarmonySelection _ _ _ ->
                    [ Dial.view KindMsg controls.kindDial
                    , Dial.view DegreeMsg controls.chordDial
                    , Dial.view AltHarmonyMsg controls.altHarmonyDial
                    , Dial.view BassMsg controls.bassDial
                    ]

                NoteSelection _ _ _ ->
                    [ Dial.view  AlterationMsg controls.alterationDial
                    , Dial.view  SubdivisionMsg controls.subdivisionDial
                    ]

                NoSelection ->
                    [ Dial.view TimeMsg controls.timeDial
                    , Dial.view KeyMsg controls.keyDial
                    , Dial.view SubdivisionMsg controls.subdivisionDial
                    ]

        s =
            100.0

        h =
            s * toFloat (List.length dials)

        w =
            s

        dialGroup i e =
            g
                [ transform <|
                    "translate(0,"
                        ++ fromFloat (toFloat i * s)
                        ++ ")"
                ]
                [ e ]
    in
    svg
        [ SvgAttr.class (css .controls)
        , height <| fromFloat h
        , width <| fromFloat w
        , viewBox <|
            fromFloat (-s / 2.0)
                ++ " "
                ++ fromFloat (-s / 2.0)
                ++ " "
                ++ fromFloat w
                ++ " "
                ++ fromFloat h
        ]
    <|
        List.indexedMap dialGroup dials


viewMeasure : Editor -> Html Msg
viewMeasure editor =
    let
        m =
            Editor.latent editor

        c =
            editor.controls

        l =
            editor.overlay.layout
    in
    svg
        [ SvgAttr.class (css .editor)
        , height <| fromPixels <| Layout.height l
        , width <| fromPixels <| Layout.width l
        ]
        [ RulerView.view l
        , MeasureView.view l m
        , OverlayView.view m editor.overlay
        , viewInPlaceControls editor
        , viewNavigation editor
        ]


viewEraseButton : Beat -> Layout -> Svg Msg
viewEraseButton b l =
    let
        left =
            .px <| scaleBeat l b

        top =
            .px (Layout.height l) - 20
    in
    g
        [ SvgAttr.class (css .below)
        , transform <| "translate(" ++ fromFloat left ++ "," ++ fromFloat top ++ ")"
        ]
        [ Button.view EraseSelection <| Svg.text_ [] [ Svg.text "Erase" ]
        ]


viewInPlaceControls : Editor -> Svg Msg
viewInPlaceControls editor =
    let
        c =
            editor.controls

        s =
            editor.overlay.selection

        l =
            editor.overlay.layout
    in
    g [ SvgAttr.class (css .inplace) ]
        [ case s of
            NoteSelection _ _ _ ->
                Svg.text ""

            HarmonySelection _ _ beat ->
                let
                    left =
                        .px <| scaleBeat l beat
                in
                g
                    [ SvgAttr.class (css .above)
                    , transform <| "translate(" ++ fromFloat left ++ ",20)"
                    ]
                    [ Dial.view HarmonyMsg c.harmonyDial
                    ]

            NoSelection ->
                text ""
        , case s of
            NoteSelection _ loc _ ->
                viewEraseButton loc.beat l

            HarmonySelection _ _ beat ->
                viewEraseButton beat l

            NoSelection ->
                Svg.text ""
        ]


viewNavigation : Editor -> Svg Msg
viewNavigation editor =
    g [ SvgAttr.class (css .navigation) ]
        [ g [ SvgAttr.class (css .previous) ]
            [ Button.view PreviousEdit <| Svg.text_ [] [ Svg.text "<<" ]
            ]
        , g [ SvgAttr.class (css .previousNew) ]
            [ Button.view PreviousNew  <| Svg.text_ [] [ Svg.text "<+" ]
            ]
        , g [ SvgAttr.class (css .cancel) ]
            [ Button.view CancelEdit <| Svg.text_ [] [ Svg.text "×" ]
            ]
        , g [ SvgAttr.class (css .done) ]
            [ Button.view DoneEdit <| Svg.text_ [] [ Svg.text "✓" ]
            ]
        , g [ SvgAttr.class (css .next) ]
            [ Button.view NextEdit <| Svg.text_ [] [ Svg.text ">>" ]
            ]
        , g [ SvgAttr.class (css .nextNew) ]
            [ Button.view NextNew <| Svg.text_ [] [ Svg.text "+>" ]
            ]
        ]
