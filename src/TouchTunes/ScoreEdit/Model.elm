module TouchTunes.ScoreEdit.Model
    exposing
        ( ScoreEdit
        , empty
        , open
        , children
        )

import Array exposing (Array)
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
