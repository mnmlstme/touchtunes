module TouchTunes.Controls exposing (Controls, new)

import Array as Array
import Music.Duration
    exposing
        ( Duration
        , dotted
        , half
        , quarter
        , whole
        )
import Music.Note.View exposing (StemOrientation(..), isWhole, viewNote)
import Svg exposing (Svg, circle, g, svg, text, text_)
import Svg.Attributes
    exposing
        ( class
        , cx
        , cy
        , height
        , r
        , textAnchor
        , transform
        , width
        )
import TouchTunes.Dial as Dial


type alias Controls =
    { durationDial : ( Dial.Config Duration, Maybe Dial.Interaction ) }


new : Controls
new =
    { durationDial =
        ( { options =
                Array.fromList
                    [ quarter
                    , dotted quarter
                    , half
                    , dotted half
                    , whole
                    , dotted whole
                    ]
          , segments = 18
          , viewValue = viewDuration
          }
        , Nothing
        )
    }


viewDuration : Duration -> Svg msg
viewDuration d =
    let
        valign =
            if isWhole d then
                0

            else
                20
    in
    g
        [ transform <|
            "translate(0,"
                ++ String.fromInt valign
                ++ ")"
        ]
        [ viewNote d StemUp ]
