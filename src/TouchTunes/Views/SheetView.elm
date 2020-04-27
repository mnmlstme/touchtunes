module TouchTunes.Views.SheetView exposing (view)

import Array exposing (Array)
import Array.Extra
import Debug exposing (log)
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
        , h3
        , header
        , li
        , section
        , text
        , ul
        )
import Html.Attributes exposing (class, classList)
import Html.Events.Extra.Pointer as Pointer
import Json.Decode as Decode exposing (Decoder, field, int)
import List.Nonempty as Nonempty exposing (Nonempty)
import Music.Models.Key exposing (keyName)
import Music.Models.Layout as Layout exposing (Layout)
import Music.Models.Measure as Measure exposing (Measure)
import Music.Models.Part as Part exposing (Id, Part)
import Music.Models.Score as Score exposing (Score)
import Music.Models.Time as Time
import Music.Views.MeasureView as MeasureView
import Music.Views.PartStyles as PartStyles
import Music.Views.ScoreStyles as ScoreStyles
import TouchTunes.Actions.Top as Actions exposing (Msg)
import TouchTunes.Models.Sheet as Sheet exposing (Sheet)
import TouchTunes.Views.SheetStyles exposing (css)


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
        [ class (css .frame) ]
        [ header [ class (css .header) ]
            [ h1 [ class (ScoreStyles.css .title) ]
                [ text s.title ]
            , dl [ class (ScoreStyles.css .stats) ]
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
            [ classList
                [ ( css .pane, True )
                , ( ScoreStyles.css .parts, True )
                ]
            ]
          <|
            List.map (viewPart viewer s) s.parts
        ]


viewPart : Sheet -> Score -> Part -> Html Msg
viewPart viewer score part =
    let
        layoutMeasures =
            Array.Extra.map2
                (\a m -> ( Layout.forMeasure a m, m ))
                (Score.attributes score)
                score.measures
    in
    section
        [ class (PartStyles.css .part)
        ]
        [ header [ class (PartStyles.css .header) ]
            [ h3 [ class (PartStyles.css .abbrev) ]
                [ text part.abbrev ]
            ]
        , div
            [ class (PartStyles.css .body) ]
          <|
            Array.toList <|
                Array.indexedMap (viewMeasure viewer part.id) layoutMeasures
        ]


viewMeasure : Sheet -> Part.Id -> Int -> ( Layout, Measure ) -> Html Msg
viewMeasure viewer id j ( layout, measure ) =
    div
        [ Pointer.onDown <|
            \_ -> Actions.StartEdit id j layout.indirect measure
        ]
        [ MeasureView.view layout measure ]
