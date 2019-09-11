module TouchTunes.ScoreEdit
    exposing
        ( Action
        , ScoreEdit
        , empty
        , open
        , update
        , view
        )

import Array exposing (Array)
import Html
    exposing
        ( Html
        , article
        , dd
        , div
        , dl
        , dt
        , footer
        , h1
        , header
        , text
        )
import Html.Attributes exposing (class)
import CssModules exposing (css)
import Music.Score.Model as Score exposing (Score)
import TouchTunes.PartEdit as PartEdit exposing (PartEdit)
import String


type alias ScoreEdit =
    { active : Maybe ( Int, PartEdit )
    , score : Score
    }


empty : ScoreEdit
empty =
    ScoreEdit Nothing Score.empty


open : Score -> ScoreEdit
open score =
    ScoreEdit Nothing score


type Action
    = OnPart Int PartEdit.Action


children : ScoreEdit -> Array PartEdit
children editor =
    let
        edit i =
            case editor.active of
                Nothing ->
                    PartEdit.open

                Just ( n, active ) ->
                    if i == n then
                        \m -> active
                    else
                        PartEdit.open
    in
        Array.indexedMap edit editor.score.parts


update : Action -> ScoreEdit -> ScoreEdit
update msg editor =
    case msg of
        OnPart n action ->
            let
                subs =
                    children editor
            in
                case Array.get n subs of
                    Nothing ->
                        editor

                    Just p ->
                        let
                            updated =
                                PartEdit.update action p

                            newScore =
                                Score.set n updated.part editor.score
                        in
                            { editor
                                | active = Just ( n, updated )
                                , score = newScore
                            }


view : ScoreEdit -> Html Action
view editor =
    let
        frameStyles =
            css "./TouchTunes/frame.css"
                { frame = "frame"
                , fullscreen = "fullscreen"
                , header = "header"
                , body = "body"
                , footer = "footer"
                }

        styles =
            css "./Music/Score/score.css"
                { title = "title"
                , parts = "parts"
                , stats = "stats"
                }

        s =
            editor.score

        nParts =
            Score.countParts s

        nMeasures =
            Score.length s

        partView i child =
            Html.map (OnPart i) (PartEdit.view child)
    in
        article
            [ frameStyles.class .frame ]
            [ header [ frameStyles.class .header ]
                [ h1 [ styles.class .title ]
                    [ text s.title ]
                ]
            , div
                [ class <|
                    (frameStyles.toString .body)
                        ++ " "
                        ++ (styles.toString .parts)
                ]
              <|
                Array.toList <|
                    Array.indexedMap partView <|
                        children editor
            , footer [ frameStyles.class .footer ]
                [ dl [ styles.class .stats ]
                    [ dt []
                        [ text "Parts" ]
                    , dd []
                        [ text (String.fromInt nParts) ]
                    , dt []
                        [ text "Measures" ]
                    , dd []
                        [ text (String.fromInt nMeasures) ]
                    ]
                ]
            ]
