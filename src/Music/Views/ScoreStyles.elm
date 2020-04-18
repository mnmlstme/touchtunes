module Music.Views.ScoreStyles exposing
    ( part
    , partAbbrev
    , partBody
    , partHeader
    , parts
    )

import Css exposing (..)


parts : Style
parts =
    batch
        [ justifyContent center
        ]


part : Style
part =
    batch
        [ displayFlex
        , flexDirection row
        , flexWrap noWrap
        ]


partHeader : Style
partHeader =
    batch
        [ displayFlex
        , flexDirection column
        , justifyContent center
        ]


partAbbrev =
    batch []


partBody =
    batch
        [ flexGrow (num 100)
        , displayFlex
        , flexDirection row
        , justifyContent flexStart
        ]
