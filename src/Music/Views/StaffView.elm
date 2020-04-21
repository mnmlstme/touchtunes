module Music.Views.StaffView exposing (draw)

import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Pixels
        )
import Music.Views.StaffStyles exposing (css)
import String exposing (fromFloat)
import Svg
    exposing
        ( Svg
        , g
        , line
        )
import Svg.Attributes
    exposing
        ( class
        , x1
        , x2
        , y1
        , y2
        )


draw : Layout -> Svg msg
draw layout =
    g [ class (css .staff) ]
        [ g [ class (css .lines) ]
            (List.map (drawStaffLine layout) (List.range 0 4))
        , g [ class (css .barline) ]
            [ drawBarLine layout ]
        ]


drawStaffLine : Layout -> Int -> Svg msg
drawStaffLine layout n =
    let
        s =
            Layout.spacing layout

        width =
            Layout.width layout

        y =
            toFloat n * s.px
    in
    line
        [ x1 "0"
        , x2 <| fromFloat width.px
        , y1 <| fromFloat y
        , y2 <| fromFloat y
        ]
        []


drawBarLine : Layout -> Svg msg
drawBarLine layout =
    let
        sp =
            Layout.spacing layout

        width =
            Layout.width layout

        height =
            4.0 * sp.px
    in
    line
        [ x1 <| fromFloat width.px
        , y1 "0"
        , x2 <| fromFloat width.px
        , y2 <| fromFloat height
        ]
        []
