module Main exposing (Model, Msg(..), main, update, view)

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


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }



-- MODEL


type alias Model =
    { editor : Editor
    }


initialModel : Model
initialModel =
    Model Editor.empty



-- UPDATE


type Msg
    = Clear
    | ShowExample1
    | EditorMessage TTAction.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Clear ->
            let
                editor =
                    Editor.empty
            in
            ( Model editor, Cmd.none )

        ShowExample1 ->
            let
                editor =
                    Editor.open Example1.example
            in
            ( Model editor, Cmd.none )

        EditorMessage ttmsg ->
            ( Model <| EditorUpdate.update ttmsg model.editor
            , Cmd.none
            )



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
                EditorMessage
                (EditorView.view model.editor)
            ]
        , footer [ styles.class .footer ]
            [ button [ onClick Clear ] [ text "Clear" ]
            , button [ onClick ShowExample1 ] [ text "Example 1" ]
            ]
        ]
