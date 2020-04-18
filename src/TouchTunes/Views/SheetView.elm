module TouchTunes.Views.SheetView exposing (view)

import Array exposing (Array)
import Array.Extra
import Debug exposing (log)
import Html.Styled
    exposing
        ( Html
        , article
        , dd
        , div
        , dl
        , dt
        , footer
        , fromUnstyled
        , h1
        , h3
        , header
        , li
        , section
        , text
        , ul
        )
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder, field, int)
import List.Nonempty as Nonempty exposing (Nonempty)
import Music.Models.Key exposing (keyName)
import Music.Models.Layout as Layout exposing (Layout)
import Music.Models.Measure as Measure exposing (Measure)
import Music.Models.Part as Part exposing (Part, propagateAttributes)
import Music.Models.Score as Score exposing (Score)
import Music.Models.Time as Time
import Music.Views.MeasureView as MeasureView
import Music.Views.ScoreStyles as ScoreStyles
import TouchTunes.Actions.Top as Actions exposing (Msg)
import TouchTunes.Models.Sheet as Sheet exposing (Sheet)
import TouchTunes.Views.SheetStyles as Styles


view : Sheet -> Html Msg
view viewer =
    let
        s =
            viewer.score

        nParts =
            Score.countParts s

        nMeasures =
            Score.length s
    in
    article
        [ css [ Styles.frame ] ]
        [ header [ css [ Styles.header ] ]
            [ h1 [ css [ Styles.title ] ]
                [ text s.title ]
            , dl [ css [ Styles.stats ] ]
                [ dt [ css [ Styles.statsItem ] ]
                    [ text "Parts" ]
                , dd [ css [ Styles.statsItem ] ]
                    [ text (String.fromInt nParts) ]
                , dt [ css [ Styles.statsItem ] ]
                    [ text "Measures" ]
                , dd [ css [ Styles.statsItem ] ]
                    [ text (String.fromInt nMeasures) ]
                ]
            ]
        , div
            [ css
                [ Styles.frame
                , ScoreStyles.parts
                ]
            ]
          <|
            Array.toList <|
                Array.indexedMap (viewPart viewer) s.parts
        ]


viewPart : Sheet -> Int -> Part -> Html Msg
viewPart viewer i part =
    let
        layoutMeasures =
            Array.Extra.map2
                (\a m -> ( Layout.forMeasure a m, m ))
                (propagateAttributes part.measures)
                part.measures
    in
    section
        [ css [ ScoreStyles.part ]
        ]
        [ header [ css [ ScoreStyles.partHeader ] ]
            [ h3 [ css [ ScoreStyles.partAbbrev ] ]
                [ text part.abbrev ]
            ]
        , div
            [ css [ ScoreStyles.partBody ] ]
          <|
            Array.toList <|
                Array.indexedMap (viewMeasure viewer i) layoutMeasures
        ]


viewMeasure : Sheet -> Int -> Int -> ( Layout, Measure ) -> Html Msg
viewMeasure viewer i j ( layout, measure ) =
    div
        [ onClick <| Actions.StartEdit i j layout ]
        [ MeasureView.view layout measure ]
