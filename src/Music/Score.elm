module Music.Score
    exposing
        ( Score
        , view
        , countParts
        , countMeasures
        )

import Music.Part as Part exposing (Part)
import Html
    exposing
        ( Html
        , article
        , header
        , footer
        , h1
        , div
        , dl
        , dt
        , dd
        , text
        )
import Html.Attributes exposing (class)


type alias Score =
    { title : String
    , parts : List Part
    }


countMeasures : Score -> Int
countMeasures score =
    4


countParts : Score -> Int
countParts score =
    1


view : Score -> Html msg
view score =
    let
        nParts =
            countParts score

        nMeasures =
            countMeasures score
    in
        article
            [ class "score frame" ]
            [ header [ class "frame-header" ]
                [ h1 [] [ text score.title ]
                ]
            , div [ class "frame-body score-parts" ]
                (List.map Part.view score.parts)
            , footer [ class "frame-footer" ]
                [ dl [ class "score-stats" ]
                    [ dt []
                        [ text "Parts" ]
                    , dd []
                        [ text (toString nParts) ]
                    , dt []
                        [ text "Measures" ]
                    , dd []
                        [ text (toString nMeasures) ]
                    ]
                ]
            ]
