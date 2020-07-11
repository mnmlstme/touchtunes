module TouchTunes.Views.SheetView exposing (formHeader, view)

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
        , form
        , h1
        , h3
        , header
        , input
        , li
        , section
        , text
        , ul
        )
import Html.Attributes exposing (class, classList, value)
import Html.Events exposing (onClick, onSubmit)
import Html.Events.Extra exposing (onChange)
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
        [ viewHeader s
        , div
            [ classList
                [ ( css .pane, True )
                , ( ScoreStyles.css .measures, True )
                ]
            ]
          <|
            List.map (viewPart viewer s) s.parts
        ]


viewHeader : Score -> Html Msg
viewHeader s =
    header
        [ class (css .header)
        , onClick Actions.StartAttributing
        ]
        [ h3 [ class (ScoreStyles.css .parts) ]
            [ text <|
                String.join " / " <|
                    List.map .name s.parts
            ]
        , h1 [ class (ScoreStyles.css .title) ]
            [ text s.title ]
        , h3 [ class (ScoreStyles.css .attribution) ]
            []
        ]


formHeader : Score -> Html Msg
formHeader s =
    form
        [ classList
            [ ( css .header, True )
            , ( css .form, True )
            ]
        , onSubmit Actions.DoneAttributing
        ]
        [ h3 [ class (ScoreStyles.css .parts) ]
            [ text <|
                String.join " / " <|
                    List.map .name s.parts
            ]
        , h1 [ class (ScoreStyles.css .title) ]
            [ input
                [ onChange Actions.ChangeTitle
                , value s.title
                ]
                []
            ]
        , h3 [ class (ScoreStyles.css .attribution) ]
            []
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
