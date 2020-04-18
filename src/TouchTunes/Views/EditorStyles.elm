module TouchTunes.Views.EditorStyles exposing (..)

import Css exposing (..)


controls : Style
controls =
    batch
        [ backgroundColor (rgba 255 255 255 0.9)
        , borderRadius (px 20)
        ]


controlsItem : Style
controlsItem =
    batch
        [ height (px 100)
        , width (px 100)
        , position relative
        ]


editor =
    batch
        [ position relative
        , padding (px 20)
        , margin auto
        , backgroundColor (rgba 255 255 255 0.9)
        , borderRadius (px 20)
        ]


ruler =
    batch
        [ position absolute
        , bottom (px 20)
        , left (px 20)
        ]


rulerRect =
    batch
        [ fill (hex "d4e6f5")
        , property "stroke" "none"
        ]


overlay =
    batch
        [ position absolute
        , top (px 20)
        , left (px 20)
        , cursor cell
        ]


underlay =
    batch
        [ property "fill-opacity" "0.2"
        ]


area =
    batch
        [ fill (rgba 255 255 255 0.05)
        , property "stroke" "none"
        ]


margins =
    batch
        [ fill (hex "eee8c0")
        ]


overflow =
    batch
        [ fill (rgba 255 48 0 0.25)
        ]


selection =
    batch
        [ property "fill" "none"
        , property "stroke" "#0072d7"
        , pointerEvents none
        ]


pitchLevel =
    batch
        [ property "stroke" "none"
        , fill (rgba 32 240 0 0.1)
        , pointerEvents none
        ]


frame =
    batch
        [ position absolute
        , height (pct 100)
        , width (pct 100)
        , padding (px 20)
        , flexGrow (num 100)
        , displayFlex
        , flexDirection row
        , alignItems center
        , backgroundColor (rgba 145 124 155 0.2)
        ]


header =
    batch
        [ displayFlex
        , marginLeft (px 175)
        , justifyContent spaceBetween
        ]
