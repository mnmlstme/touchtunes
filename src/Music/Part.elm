module Music.Part
    exposing
        ( Part
        , view
        )

import Svg exposing (Svg, g, text, text_)
import Svg.Attributes exposing (class, transform)


type alias Part =
    { name : String
    , abbrev : String
    }


view : Part -> Svg msg
view part =
    g [ transform "translate(60, 60)" ]
        [ text_ [ class "part-name" ]
            [ text part.abbrev ]
        ]
