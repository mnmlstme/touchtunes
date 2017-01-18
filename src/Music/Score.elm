module Music.Score
    exposing
        ( Score
        , score
        , empty
        , Action
        , update
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
import Music.Time exposing (Beat)
import Music.Part as Part exposing (Part)


type alias Score =
    { title : String
    , parts : Array Part
    }


type Action
    = OnPart Int Part.Action


empty : Score
empty =
    score "New Score" [ Part.empty ]


score : String -> List Part -> Score
score t list =
    Score t (Array.fromList list)


update : Action -> Score -> Score
update msg score =
    case msg of
        OnPart n action ->
            case Array.get n score.parts of
                Nothing ->
                    score

                Just p ->
                    { score | parts = Array.set n (Part.update action p) score.parts }


countMeasures : Score -> Int
countMeasures s =
    Array.map Part.countMeasures s.parts
        |> Array.foldl max 0


countParts : Score -> Int
countParts s =
    Array.length s.parts


view : Maybe ( Int, Int, Beat ) -> Score -> Html Action
view cursor s =
    let
        nParts =
            countParts s

        nMeasures =
            countMeasures s

        addr i =
            case cursor of
                Nothing ->
                    Nothing

                Just ( n, m, beat ) ->
                    if i == n then
                        Just ( m, beat )
                    else
                        Nothing

        partView i part =
            Html.map (OnPart i) (Part.view (addr i) part)
    in
        article
            [ class "score frame" ]
            [ header [ class "frame-header" ]
                [ h1 [ class "score-title" ]
                    [ text s.title ]
                ]
            , div [ class "frame-body score-parts" ]
                (Array.toList <| Array.indexedMap partView s.parts)
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
