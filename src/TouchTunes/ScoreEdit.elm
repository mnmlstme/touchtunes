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
import Music.Score as Score exposing (Score)
import TouchTunes.PartEdit as PartEdit exposing (PartEdit)
import String exposing (fromFloat)


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
            [ class "score frame" ]
            [ header [ class "frame-header" ]
                [ h1 [ class "score-title" ]
                    [ text s.title ]
                ]
            , div
                [ class "frame-body score-parts"
                ]
              <|
                Array.toList <|
                    Array.indexedMap partView <|
                        children editor
            , footer [ class "frame-footer" ]
                [ dl [ class "score-stats" ]
                    [ dt []
                        [ text "Parts" ]
                    , dd []
                        [ text (fromFloat nParts) ]
                    , dt []
                        [ text "Measures" ]
                    , dd []
                        [ text (fromFloat nMeasures) ]
                    ]
                ]
            ]
