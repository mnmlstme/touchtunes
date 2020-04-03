module Music.Views.StaffView exposing (draw)

import CssModules as CssModules
import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , inPx
        )
import TypedSvg
    exposing
        ( g
        , line
        )
import TypedSvg.Attributes exposing (class, x1, x2, y1, y2)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (px)


draw : Layout -> Svg msg
draw layout =
    let
        css =
            .toString <|
                CssModules.css "./Music/Views/css/staff.css"
                    { staff = "staff"
                    , barline = "barline"
                    , lines = "lines"
                    }
    in
    g [ class [ css .staff ] ]
        [ g [ class [ css .lines ] ]
            (List.map (drawStaffLine layout) (List.range 0 4))
        , g [ class [ css .barline ] ]
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
        [ x1 <| px 0
        , x2 <| inPx width
        , y1 <| px y
        , y2 <| px y
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
        [ x1 <| inPx width
        , y1 <| px 0
        , x2 <| inPx width
        , y2 <| px height
        ]
        []
