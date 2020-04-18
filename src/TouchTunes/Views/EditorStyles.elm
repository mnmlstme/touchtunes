module TouchTunes.Views.EditorStyles exposing
    ( area
    , body
    , controls
    , controlsItem
    , controlsSvg
    , editor
    , frame
    , header
    , margins
    , overflow
    , overlay
    , pitchLevel
    , ruler
    , rulerRect
    , selection
    , underlay
    )

import Css exposing (..)


controls : Style
controls =
    batch
        [ position absolute
        , top zero
        , left zero
        , height (pct 100)
        , width (px 90)
        , displayFlex
        , flexDirection column
        , justifyContent center
        ]


controlsItem : Style
controlsItem =
    batch
        [ -- .controls > li {
          height (px 100)
        , position relative
        ]


controlsSvg : Style
controlsSvg =
    batch
        [ -- .controls > li > svg {
          position absolute
        , top zero
        , marginTop (pct -50)
        ]


editor =
    batch
        [ position relative
        ]


ruler =
    batch
        [ position absolute
        , bottom zero
        , left zero
        ]


rulerRect =
    batch
        [ fill (hex "d4e6f5")
        , property "stroke" "none"
        ]


overlay =
    batch
        [ position absolute
        , top zero
        , left zero
        , cursor cell
        ]


underlay =
    batch
        [ property "fillOpacity" "0.2"
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
        ]


pitchLevel =
    batch
        [ property "stroke" "none"
        , fill (rgba 32 240 0 0.1)
        , pointerEvents none
        ]


frame =
    batch
        [ displayFlex
        , flexDirection column
        , justifyContent spaceBetween
        , flexGrow (num 100) -- for child frame
        , position relative
        ]


header =
    batch
        [ displayFlex
        , marginLeft (px 175)
        , justifyContent spaceBetween
        ]


body =
    batch
        [ flexGrow (num 100)
        , displayFlex
        , flexDirection column
        , marginLeft (px 175)
        , Css.overflow auto
        ]
