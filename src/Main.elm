module Main exposing (..)

import Array exposing (Array)
import Browser exposing (Document)
import Debug exposing (log)
import Html as Html
    exposing
        ( Html
        , a
        , button
        , div
        , footer
        , header
        , li
        , section
        , span
        , text
        , ul
        )
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Music.Models.Score as Score exposing (Score)
import TouchTunes.Actions.Top exposing (Msg(..))
import TouchTunes.Actions.AppUpdate exposing (update)
import TouchTunes.Models.App as App exposing (App)
import TouchTunes.Views.AppStyles exposing (css)
import TouchTunes.Views.AppView as AppView



-- APP


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( App.init Score.empty, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model = App




-- VIEW


view : Model -> Html Msg
view model =
    section
        [ classList
            [ ( css .app, True )
            , ( css .fullscreen, True )
            ]
        ]
        [ AppView.view model
        , footer
            [ class (css .footer) ]
            [ button [ onClick <| GetCatalog ] [ text "Catalog" ]
            , button [ onClick <| Save ] [ text "Save" ]
            , button [ onClick <| SaveAs ("Copy of " ++ model.score.title) ] [ text "Save a Copy" ]
            , button [ onClick <| Clear ] [ text "Clear" ]
            , span [ class (css .message) ] <|
                Maybe.withDefault [] <|
                    Maybe.map (\m -> [ text m ]) model.message
            ]
        ]



