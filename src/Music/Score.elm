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
countMeasures s =
    List.map Part.countMeasures s.parts
        |> List.foldl max 0


countParts : Score -> Int
countParts s =
    List.length s.parts


view : Score -> Html msg
view s =
    let
        nParts =
            countParts s

        nMeasures =
            countMeasures s
    in
        article
            [ class "score frame" ]
            [ header [ class "frame-header" ]
                [ h1 [] [ text s.title ]
                ]
            , div [ class "frame-body score-parts" ]
                (List.map Part.view s.parts)
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
