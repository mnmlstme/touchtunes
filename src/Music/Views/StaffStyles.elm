module Music.Views.StaffStyles exposing (..)

import Css exposing (..)


staff =
    batch
        [ property "strokeWidth" "1"
        , property "stroke" "#646464"
        ]


barline =
    batch
        [ property "strokeWidth" "2"
        ]


lines =
    batch
        []
