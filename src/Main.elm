module Main exposing (Model, Msg(..), init, main, update, view)

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
import CssModules exposing (css)
import Browser exposing (Document)
import TouchTunes.ScoreEdit.Model as ScoreEdit exposing (ScoreEdit)
import TouchTunes.ScoreEdit.Action as ScoreEditAction
import TouchTunes.ScoreEdit.Update as ScoreEditUpdate
import TouchTunes.ScoreEdit.View as ScoreEditView


-- APP


main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { editor : ScoreEdit
    }


init : Model
init =
    Model ScoreEdit.empty



-- UPDATE


type Msg
    = Clear
    | ShowExample1
    | EditorAction ScoreEditAction.Action


update : Msg -> Model -> Model
update msg model =
    case msg of
        Clear ->
            let
                editor =
                    ScoreEdit.empty
            in
                Model editor

        ShowExample1 ->
            let
                editor =
                    ScoreEdit.open Example1.example
            in
                Model editor

        EditorAction action ->
            let
                updated =
                    ScoreEditUpdate.update action model.editor
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
                    (ScoreEditView.view model.editor)
                ]
            , footer [ styles.class .footer ]
                [ button [ onClick Clear ] [ text "Clear" ]
                , button [ onClick ShowExample1 ] [ text "Example 1" ]
                ]
            ]
