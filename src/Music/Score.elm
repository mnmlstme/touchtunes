module Music.Score
    exposing
        ( Score
        , view
        , countParts
        , countMeasures
        )

import Svg exposing (Svg, svg, g)
import Svg.Attributes exposing (class, width, height, viewBox)
import Music.Part as Part exposing (Part)


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


view : Score -> Svg msg
view score =
    let
        w =
            600

        h =
            400

        viewbox =
            String.join " "
                (List.map toString
                    [ 0, 0, w, h ]
                )
    in
        svg
            [ class "score"
            , width (toString 600)
            , height (toString 400)
            , viewBox viewbox
            ]
            [ g [] (List.map Part.view score.parts)
            ]
