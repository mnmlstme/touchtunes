module TouchTunes.Views.SheetStyles exposing (..)

import Css exposing (..)


sheet : Style
sheet =
    batch []


frame : Style
frame =
    batch
        [ displayFlex
        , flexDirection column
        , justifyContent spaceBetween
        , flexGrow (num 100) -- for child frame
        , position absolute
        , width (pct 100)
        , height (pct 100)
        ]


pane : Style
pane =
    batch
        [ overflow auto
        , flexGrow (num 100)
        ]


header : Style
header =
    batch
        [ displayFlex
        , marginLeft (px 175)
        , justifyContent spaceBetween
        ]


body : Style
body =
    batch
        [ flexGrow (num 100)
        , displayFlex
        , flexDirection column
        , marginLeft (px 175)
        , overflow auto
        ]


title : Style
title =
    batch
        [ fontWeight (int 700)
        , textAlign center
        ]


stats : Style
stats =
    batch []


statsItem : Style
statsItem =
    batch
        [ display inlineBlock
        ]


statsData : Style
statsData =
    batch
        [ fontWeight bold
        ]


statsTerm : Style
statsTerm =
    batch
        [ marginLeft (em 1)
        ]
