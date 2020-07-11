module TouchTunes.Actions.AppUpdate exposing (update)

import Http
import Json.Decode as Json exposing (field)
import Music.Json.Decode as Decode
import Music.Json.Encode as MusicJson
import Music.Models.Score as Score
import TouchTunes.Actions.EditorUpdate as EditorUpdate
import TouchTunes.Actions.Top exposing (Msg(..))
import TouchTunes.Models.App as App exposing (App, Screen(..))
import TouchTunes.Models.Catalog as Catalog exposing (Catalog)



-- UPDATE


update : Msg -> App -> ( App, Cmd Msg )
update msg app =
    case msg of
        Clear ->
            ( App.init Score.empty
            , Cmd.none
            )

        Save ->
            let
                body =
                    Http.jsonBody <| MusicJson.score app.score
            in
            ( app
            , case app.scoreId of
                Just id ->
                    Http.request
                        { method = "PUT"
                        , url = "../api/scores/" ++ id
                        , headers = []
                        , body = body
                        , expect = Http.expectString Saved
                        , timeout = Nothing
                        , tracker = Nothing
                        }

                Nothing ->
                    Http.post
                        { url = "../api/scores"
                        , body = body
                        , expect = Http.expectString Saved
                        }
            )

        Saved res ->
            ( app, Cmd.none )

        SaveAs s ->
            let
                renamed =
                    Score.changeTitle s app.score

                body =
                    Http.jsonBody <| MusicJson.score renamed
            in
            ( { app
                | score = renamed
                , scoreId = Nothing
              }
            , Http.post
                { url = "../api/scores"
                , body = body
                , expect = Http.expectString Saved
                }
            )

        GetCatalog ->
            ( { app
                | screen = Browsing Catalog.empty
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
                            Json.decodeString Catalog.decode str
                    in
                    ( case decoded of
                        Ok list ->
                            { app | screen = Browsing <| Catalog.fromList list }

                        Err err ->
                            { app
                                | message =
                                    Just <|
                                        "JSON decoder error: "
                                            ++ Json.errorToString err
                            }
                    , Cmd.none
                    )

                Err _ ->
                    ( { app | message = Just "Failed to load Catalog" }
                    , Cmd.none
                    )

        GetScore id ->
            ( { app
                | message = Nothing
              }
            , Http.get
                { url = "../api/scores/" ++ id
                , expect = Http.expectString (GotScore id)
                }
            )

        GotScore id res ->
            case res of
                Ok str ->
                    let
                        decoded =
                            Json.decodeString Decode.score str
                    in
                    case decoded of
                        Ok score ->
                            ( { app
                                | score = score
                                , screen = Viewing
                                , scoreId = Just id
                              }
                            , Cmd.none
                            )

                        Err err ->
                            ( { app
                                | message =
                                    Just <|
                                        "JSON decoder error: "
                                            ++ Json.errorToString err
                              }
                            , Cmd.none
                            )

                Err _ ->
                    ( { app | message = Just "Failed to load Score" }
                    , Cmd.none
                    )

        StartEdit id mnum _ _ ->
            ( App.open id mnum app
            , Cmd.none
            )

        CancelEdit ->
            ( App.close app
            , Cmd.none
            )

        StartAttributing ->
            ( App.attribute app
            , Cmd.none
            )

        ChangeTitle s ->
            ( { app | score = Score.changeTitle s app.score }
            , Cmd.none
            )

        DoneAttributing ->
            ( App.close app
            , Cmd.none
            )

        _ ->
            case app.screen of
                Editing e ->
                    let
                        edit =
                            { app | screen = Editing { e | editor = EditorUpdate.update msg e.editor } }

                        save a =
                            { a
                                | score = Score.setMeasure e.measureNum e.editor.measure app.score
                            }
                    in
                    case msg of
                        SaveEdit ->
                            ( save edit, Cmd.none )

                        NextEdit ->
                            ( App.open e.partId (e.measureNum + 1) <|
                                save edit
                            , Cmd.none
                            )

                        PreviousEdit ->
                            ( App.open e.partId (e.measureNum - 1) <|
                                save edit
                            , Cmd.none
                            )

                        DoneEdit ->
                            ( App.close <| save edit
                            , Cmd.none
                            )

                        _ ->
                            ( edit, Cmd.none )

                _ ->
                    ( app, Cmd.none )
