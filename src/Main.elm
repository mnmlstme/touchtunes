module Main exposing (Model, main, update, view)

import Browser exposing (Document)
import Example1
import Html as Html
    exposing
        ( Html
        , button
        , div
        , footer
        , header
        , section
        , text
        )
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Music.Models.Score as Score exposing (Score)
import TouchTunes.Actions.Top as Actions
import TouchTunes.Models.App as App exposing (App)
import TouchTunes.Views.AppStyles exposing (css)
import TouchTunes.Views.AppView as AppView



-- APP


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }


type Msg
    = Open Score
    | AppMessage Actions.Msg



-- MODEL


type alias Model =
    { app : App
    }


initialModel : Model
initialModel =
    Model <| App.init Score.empty



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Open score ->
            ( { model | app = App.init score }
            , Cmd.none
            )

        AppMessage appmsg ->
            ( { model | app = App.update appmsg model.app }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    section
        [ classList
            [ ( css .app, True )
            , ( css .fullscreen, True )
            ]
        ]
        [ Html.map AppMessage <| AppView.view model.app
        , footer
            [ class (css .footer) ]
            [ button [ onClick <| Open Score.empty ] [ text "Clear" ]
            , button [ onClick <| Open Example1.example ] [ text "Example 1" ]
            ]
        ]
