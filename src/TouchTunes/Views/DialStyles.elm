module TouchTunes.Views.DialStyles exposing
    ( collar
    , collarActive
    , collarCircle
    , dial
    , dialActive
    , face
    , option
    , optionCircle
    , value
    , valueCircle
    , viewValue
    )

import Css exposing (..)


white =
    hex "fff"


black =
    hex "000"


dial =
    batch
        [ property "stroke" "#f0f0f0"
        , fill white
        , zIndex (int 1)
        ]


dialActive =
    batch
        [ dial
        , zIndex (int 2)
        ]


collar =
    batch
        [ visibility hidden
        , opacity zero
        , fill white
        ]


collarActive =
    batch
        [ collar
        , visibility visible
        , opacity (num 1)
        ]


collarCircle =
    batch
        [ -- .collar > circle {
          fill (hex "484244")
        , property "fillOpacity" "0.2"
        ]


option =
    batch
        [ fill (hex "484244")
        ]


optionCircle =
    batch
        [ fill white
        ]


face =
    batch
        [ fill black
        , property "stroke" "#ffffc3"
        , property "strokeWidth" "1"
        ]


value =
    batch
        [ fill (hex "484244")
        ]


valueCircle =
    batch
        [ fill (hex "e4e0e4")
        , property "stroke" "#68b2f0"
        ]


viewValue =
    batch
        [ pointerEvents none
        ]


viewValueText =
    batch
        [ property "userSelect" "none"
        , fontWeight (int 800)
        ]
