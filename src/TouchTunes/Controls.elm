module TouchTunes.Controls exposing (durationDial)

import Svg exposing (Svg, circle, g, svg, text, text_)
import Svg.Attributes
    exposing
        ( class
        , transform
        , height
        , width
        , r
        , cx
        , cy
        , textAnchor
        )
import Music.Duration exposing (Duration)
import Music.Note.View as Note
import TouchTunes.Dial as Dial


durationDial : Dial.Config Duration msg
durationDial =
    { options = []
    , viewValue = viewDuration
    }


viewDuration : Duration -> Svg msg
viewDuration d =
    g [ transform "scale(0.25,0.25)" ]
        [ Note.viewNote d Note.StemUp
        ]
