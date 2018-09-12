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
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Browser
import TouchTunes.ScoreEdit as ScoreEdit exposing (ScoreEdit)


-- APP


main : Program Never Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }



-- MODEL


type alias Model =
    { editor : ScoreEdit
    }


init : ( Model, Cmd Msg )
init =
    let
        model =
            Model ScoreEdit.empty
    in
        ( model, Cmd.none )



-- UPDATE


type Msg
    = Clear
    | ShowExample1
    | EditorAction ScoreEdit.Action


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Clear ->
            let
                editor =
                    ScoreEdit.empty
            in
                ( Model editor, Cmd.none )

        ShowExample1 ->
            let
                editor =
                    ScoreEdit.open Example1.example
            in
                ( Model editor, Cmd.none )

        EditorAction action ->
            let
                updated =
                    ScoreEdit.update action model.editor
            in
                ( { model | editor = updated }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    section [ class "fullscreen- frame" ]
        [ div [ class "frame-body" ]
            [ Html.map
                EditorAction
                (ScoreEdit.view model.editor)
            ]
        , footer [ class "frame-footer" ]
            [ button [ onClick Clear ] [ text "Clear" ]
            , button [ onClick ShowExample1 ] [ text "Example 1" ]
            ]
        ]
