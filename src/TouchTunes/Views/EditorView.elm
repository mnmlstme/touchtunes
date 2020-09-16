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
import Music.Models.Layout exposing (Layout)
import Music.Views.MeasureView as MeasureView
import String exposing (fromFloat)
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Models.Editor as Editor exposing (Editor)
import TouchTunes.Models.Overlay exposing (Selection(..))
import TouchTunes.Views.DialView as Dial
import TouchTunes.Views.EditorStyles exposing (css)
import TouchTunes.Views.OverlayView as OverlayView
import TouchTunes.Views.RulerView as RulerView
import Music.Models.Layout exposing (scaleBeat)


view : Editor -> Html Msg
view editor =
    article [ class (css .frame) ]
        [ viewControls editor
        , viewMeasure editor
        ]


viewScreen : Html Msg
viewScreen =
    div [ class (css .screen) ] []


viewControls : Editor -> Html Msg
viewControls editor =
    let
        controls =
            editor.controls

        overlay =
            editor.overlay
    in
    ul
        [ class (css .controls) ]
    <|
        List.map
            (\e -> li [] [ e ])
        <|
            case overlay.selection of
                HarmonySelection _ _ _ ->
                    [ Dial.view controls.kindDial Actions.KindMsg
                    , Dial.view controls.chordDial Actions.DegreeMsg
                    , Dial.view controls.altHarmonyDial Actions.AltHarmonyMsg
                    , Dial.view controls.bassDial Actions.BassMsg
                    ]

                NoteSelection _ _ _ ->
                    [ Dial.view controls.alterationDial Actions.AlterationMsg
                    , Dial.view controls.subdivisionDial Actions.SubdivisionMsg
                    ]

                NoSelection ->
                    [ Dial.view controls.timeDial Actions.TimeMsg
                    , Dial.view controls.keyDial Actions.KeyMsg
                    , Dial.view controls.subdivisionDial Actions.SubdivisionMsg
                    ]


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
    div
        [ class (css .editor) ]
        [ RulerView.view l
        , MeasureView.view l m
        , OverlayView.view m editor.overlay
        , viewInPlaceControls editor
        , viewNavigation editor
        ]


viewEraseButton : Beat -> Layout -> Html Msg
viewEraseButton b l =
    let
        left =
            .px <| scaleBeat l b
    in
    li
        [ class (css .below)
        , style "left" <| fromFloat left ++ "px"
        ]
        [ button [ onClick EraseSelection ]
          [ text "Erase" ]
        ]

viewInPlaceControls : Editor -> Html Msg
viewInPlaceControls editor =
    let
        c =
            editor.controls

        s =
            editor.overlay.selection

        l =
            editor.overlay.layout
    in
    ul
        [ class (css .inplace) ]
        [ case s of
            NoteSelection _ _ _ ->
                text ""

            HarmonySelection _ _ beat ->
                let
                    left =
                        .px <| scaleBeat l beat
                in
                li
                    [ class (css .above)
                    , style "left" <| fromFloat left ++ "px"
                    ]
                    [ Dial.view c.harmonyDial Actions.HarmonyMsg
                    ]

            NoSelection ->
                text ""
        , case s of
            NoteSelection _ loc _ ->
                viewEraseButton loc.beat l

            HarmonySelection _ _ beat ->
                viewEraseButton beat l

            NoSelection ->
                text ""
        ]


viewNavigation : Editor -> Html Msg
viewNavigation editor =
    ul [ class (css .navigation) ]
        [ li [ class (css .previous) ]
            [ button [ onClick PreviousEdit ]
                [ text "<<" ]
            ]
        , li [ class (css .previousNew) ]
            [ button [ onClick PreviousNew ]
                [ text "<+" ]
            ]
        , li [ class (css .cancel) ]
            [ button [ onClick CancelEdit ]
                [ text "×" ]
            ]
        , li [ class (css .done) ]
            [ button [ onClick DoneEdit ]
                [ text "✓" ]
            ]
        , li [ class (css .next) ]
            [ button [ onClick NextEdit ]
                [ text ">>" ]
            ]
        , li [ class (css .nextNew) ]
            [ button [ onClick NextNew ]
                [ text "+>" ]
            ]
        ]
