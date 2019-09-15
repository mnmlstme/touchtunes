module Main exposing (Model, Msg(..), init, main, update, view)

import Browser exposing (Document)
import CssModules exposing (css)
import Example1
import Html
    exposing
        ( Html
        , button
        , div
        , footer
        , header
        , section
        , text
        )
import Html.Events exposing (onClick)
import TouchTunes.Action as TTAction
import TouchTunes.Model as Editor exposing (Editor)
import TouchTunes.Update as EditorUpdate
import TouchTunes.View as EditorView



-- APP


main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { editor : Editor
    }


init : Model
init =
    Model Editor.empty



-- UPDATE


type Msg
    = Clear
    | ShowExample1
    | EditorAction TTAction.Action


update : Msg -> Model -> Model
update msg model =
    case msg of
        Clear ->
            let
                editor =
                    Editor.empty
            in
            Model editor

        ShowExample1 ->
            let
                editor =
                    Editor.open Example1.example
            in
            Model editor

        EditorAction action ->
            let
                updated =
                    EditorUpdate.update action model.editor
            in
            { model | editor = updated }



-- VIEW


view : Model -> Html Msg
view model =
    let
        styles =
            css "./app.css"
                { app = "app"
                , fullscreen = "fullscreen"
                , body = "body"
                , footer = "footer"
                }
    in
    section
        [ styles.classList
            [ ( .fullscreen, True )
            , ( .app, True )
            ]
        ]
        [ div [ styles.class .body ]
            [ Html.map
                EditorAction
                (EditorView.view model.editor)
            ]
        , footer [ styles.class .footer ]
            [ button [ onClick Clear ] [ text "Clear" ]
            , button [ onClick ShowExample1 ] [ text "Example 1" ]
            ]
        ]
