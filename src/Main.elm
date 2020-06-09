module Main exposing (Model, main, update, view)

import Array exposing (Array)
import AutumnLeaves
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
import Http
import Json.Decode as Json exposing (field)
import Music.Json.Decode as Decode
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
    | GetCatalog
    | GotCatalog (Result Http.Error String)
    | GetScore String
    | GotScore (Result Http.Error String)
    | AppMessage Actions.Msg



-- MODEL


type alias Model =
    { app : App
    , catalog : Array CatalogEntry
    , message : Maybe String
    }


initialModel : Model
initialModel =
    Model (App.init Score.empty) Array.empty Nothing



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Open score ->
            ( { model | app = App.init score }
            , Cmd.none
            )

        GetCatalog ->
            ( { model
                | catalog = Array.empty
                , message = Nothing
              }
            , Http.get
                { url = "../api/scores"
                , expect = Http.expectString GotCatalog
                }
            )

        GotCatalog res ->
            case res of
                Ok str ->
                    let
                        decoded =
                            Json.decodeString catalogDecoder str
                    in
                    ( case decoded of
                        Ok list ->
                            { model | catalog = Array.fromList list }

                        Err err ->
                            { model
                                | message =
                                    Just <|
                                        "JSON decoder error: "
                                            ++ Json.errorToString err
                            }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | message = Just "Failed to load Catalog" }
                    , Cmd.none
                    )

        GetScore id ->
            ( { model
                | message = Nothing
              }
            , Http.get
                { url = "../api/scores/" ++ id
                , expect = Http.expectString GotScore
                }
            )

        GotScore res ->
            case res of
                Ok str ->
                    let
                        decoded =
                            Json.decodeString Decode.score str
                    in
                    case decoded of
                        Ok score ->
                            ( { model | app = App.init score }, Cmd.none )

                        Err err ->
                            ( { model
                                | message =
                                    Just <|
                                        "JSON decoder error: "
                                            ++ Json.errorToString err
                              }
                            , Cmd.none
                            )

                Err _ ->
                    ( { model | message = Just "Failed to load Catalog" }
                    , Cmd.none
                    )

        AppMessage appmsg ->
            ( { model | app = App.update appmsg model.app }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    section
        [ classList
            [ ( css .app, True )
            , ( css .fullscreen, True )
            ]
        ]
        [ Html.map AppMessage <| AppView.view model.app
        , div
            [ classList
                [ ( css .catalog, True )
                , ( css .active, not <| Array.isEmpty model.catalog )
                ]
            ]
            [ ul [] <|
                List.map
                    (\e ->
                        li []
                            [ a [ onClick <| GetScore e.id ] [ text e.title ] ]
                    )
                <|
                    Array.toList model.catalog
            ]
        , footer
            [ class (css .footer) ]
            [ button [ onClick <| Open Score.empty ] [ text "Clear" ]
            , button [ onClick <| Open AutumnLeaves.score ] [ text "Autumn Leaves" ]
            , button [ onClick <| GetCatalog ] [ text "Catalog" ]
            , span [ class (css .message) ] <|
                Maybe.withDefault [] <|
                    Maybe.map (\m -> [ text m ]) model.message
            ]
        ]



-- CATALOG


type alias CatalogEntry =
    { id : String
    , title : String
    }


catalogDecoder : Json.Decoder (List CatalogEntry)
catalogDecoder =
    Json.list <|
        Json.map2
            CatalogEntry
            (field "id" Json.string)
            (field "title" Json.string)
