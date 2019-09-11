module TouchTunes.ScoreEdit.View
    exposing
        ( view
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
import TouchTunes.ScoreEdit.Model as ScoreEdit exposing (ScoreEdit, children)
import TouchTunes.ScoreEdit.Action exposing (Action(..))


view : ScoreEdit -> Html Action
view editor =
    let
        frameStyles =
            css "./TouchTunes/ScoreEdit/frame.css"
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
                , dl [ styles.class .stats ]
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
            ]
