module Main exposing (..)

import Html
    exposing
        ( Html
        , section
        , header
        , footer
        , div
        , button
        , text
        )
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import TouchTunes.ScoreEdit as ScoreEdit exposing (ScoreEdit)
import Example1


-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (\model -> Sub.none)
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
                    ScoreEdit Example1.example
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
