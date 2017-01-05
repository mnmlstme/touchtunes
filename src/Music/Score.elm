module Music.Score
    exposing
        ( Score
        , score
        , view
        , countParts
        , countMeasures
        )

import Array as Array exposing (Array)
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
import Music.Part as Part exposing (Part)


type alias Score =
    { title : String
    , parts : Array Part
    }


score : String -> List Part -> Score
score t list =
    Score t (Array.fromList list)


countMeasures : Score -> Int
countMeasures s =
    Array.map Part.countMeasures s.parts
        |> Array.foldl max 0


countParts : Score -> Int
countParts s =
    Array.length s.parts


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
                (Array.toList <| Array.map Part.view s.parts)
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
