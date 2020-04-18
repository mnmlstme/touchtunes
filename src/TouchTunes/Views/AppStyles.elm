module TouchTunes.Views.AppStyles exposing
    ( app
    , body
    , footer
    , fullScreen
    )

import Css exposing (..)


app : Style
app =
    batch
        [ displayFlex
        , flexDirection column
        , justifyContent spaceBetween
        , flexGrow (num 100)
        , position relative
        , backgroundColor (hex "f8f8f8")
        ]


fullScreen : Style
fullScreen =
    batch
        [ position fixed
        , width (pct 100)
        , height (pct 100)
        ]


body : Style
body =
    batch
        [ flexGrow (num 100)
        , displayFlex
        , flexDirection column
        ]


footer : Style
footer =
    batch
        [ position absolute
        , bottom zero
        , left zero
        , width (pct 100)
        ]
