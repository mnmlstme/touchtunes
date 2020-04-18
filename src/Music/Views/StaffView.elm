module Music.Views.StaffView exposing (draw)

import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Pixels
        )
import Music.Views.StaffStyles as Styles
import String exposing (fromFloat)
import Svg.Styled
    exposing
        ( Svg
        , g
        , line
        )
import Svg.Styled.Attributes
    exposing
        ( css
        , x1
        , x2
        , y1
        , y2
        )


draw : Layout -> Svg msg
draw layout =
    g [ css [ Styles.staff ] ]
        [ g [ css [ Styles.lines ] ]
            (List.map (drawStaffLine layout) (List.range 0 4))
        , g [ css [ Styles.barline ] ]
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
