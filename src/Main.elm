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
import Music.Score as Score exposing (Score)
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
    { score : Score
    }


init : ( Model, Cmd Msg )
init =
    let
        model =
            Model Example1.example
    in
        ( model, Cmd.none )



-- UPDATE


type Msg
    = Clear
    | ShowExample1
    | ScoreAction Score.Action


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Clear ->
            ( { model | score = Score.empty }, Cmd.none )

        ShowExample1 ->
            ( { model | score = Example1.example }, Cmd.none )

        ScoreAction action ->
            ( { model | score = Score.update action model.score }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    let
        score =
            model.score
    in
        section [ class "fullscreen- frame" ]
            [ div [ class "frame-body" ]
                [ Html.map
                    ScoreAction
                    (Score.view score)
                ]
            , footer [ class "frame-footer" ]
                [ button [ onClick Clear ] [ text "Clear" ]
                , button [ onClick ShowExample1 ] [ text "Example 1" ]
                ]
            ]
