module TouchTunes.Views.EditorView exposing (view)

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
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder, field, int)
import List.Nonempty as Nonempty exposing (Nonempty)
import Music.Models.Key exposing (keyName)
import Music.Models.Layout as Layout exposing (Layout)
import Music.Models.Measure as Measure exposing (Measure)
import Music.Models.Part as Part exposing (Part)
import Music.Models.Score as Score exposing (Score)
import Music.Models.Time as Time
import Music.Views.MeasureView as MeasureView
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Models.Controls as Controls
import TouchTunes.Models.Editor as Editor exposing (Editor)
import TouchTunes.Models.Overlay exposing (Selection(..))
import TouchTunes.Views.DialView as Dial
import TouchTunes.Views.EditorStyles exposing (css)
import TouchTunes.Views.OverlayView as OverlayView
import TouchTunes.Views.RulerView as RulerView


view : Editor -> Html Msg
view editor =
    article [ class (css .frame) ]
        [ viewControls editor
        , viewMeasure editor
        ]


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
        (List.map
            (\e -> li [] [ e ])
         <|
            List.append
                (case overlay.selection of
                    HarmonySelection _ _ ->
                        [ Dial.view controls.rootDial Actions.RootMsg ]

                    NoteSelection _ _ _ ->
                        [ Dial.view controls.alterationDial Actions.AlterationMsg
                        ]

                    NoSelection ->
                        [ Dial.view controls.timeDial Actions.TimeMsg
                        , Dial.view controls.keyDial Actions.KeyMsg
                        ]
                )
                [ Dial.view controls.subdivisionDial Actions.SubdivisionMsg
                ]
        )


viewMeasure : Editor -> Html Msg
viewMeasure editor =
    let
        m =
            Editor.latent editor

        l =
            editor.overlay.layout
    in
    div
        [ class (css .editor) ]
        [ RulerView.view l
        , MeasureView.view l m
        , OverlayView.view m editor.overlay
        , viewNavigation editor
        ]


viewNavigation : Editor -> Html Msg
viewNavigation editor =
    ul [ class (css .navigation) ]
        [ li []
            [ button [ onClick PreviousEdit ]
                [ text "<Previous" ]
            ]
        , li []
            [ button [ onClick CancelEdit ]
                [ text "Cancel" ]
            ]
        , li []
            [ button [ onClick DoneEdit ]
                [ text "Done" ]
            ]
        , li []
            [ button [ onClick NextEdit ]
                [ text "Next>" ]
            ]
        ]
