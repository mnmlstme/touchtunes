module Music.Views.MeasureStyles exposing (..)

import Css exposing (..)


measure =
    batch
        [ position relative
        ]


staff =
    batch
        [ overflow visible
        , property "stroke" "#333"
        , fill (hex "333")
        , pointerEvents none
        ]


time =
    batch
        [ fontWeight (int 800)
        , fontSize (px 20)
        , property "textAnchor" "middle"
        ]


key =
    batch
        [ fill (hex "333")
        ]
