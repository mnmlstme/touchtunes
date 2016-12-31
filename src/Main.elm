module Main exposing (..)

import Html
    exposing
        ( Html
        , section
        , header
        , footer
        , h1
        , p
        , dl
        , dd
        , dt
        , button
        , text
        )
import Html.Events exposing (onClick)
import Music.Score as Score exposing (Score)
import Example1 exposing (example)


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
            Model example
    in
        ( model, Cmd.none )



-- UPDATE


type Msg
    = Reset


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( { model | score = example }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        score =
            model.score

        nParts =
            Score.countParts score

        nMeasures =
            Score.countMeasures score
    in
        section []
            [ header []
                [ h1 [] [ text score.title ]
                ]
            , Score.view model.score
            , footer []
                [ button [ onClick Reset ] [ text "Reset" ]
                , dl []
                    [ dt []
                        [ text "Parts" ]
                    , dd []
                        [ text (toString nParts) ]
                    , dt []
                        [ text "Measures" ]
                    , dd []
                        [ text (toString nMeasures) ]
                    ]
                ]
            ]
