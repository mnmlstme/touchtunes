module Music.Staff.Model exposing
    ( Staff
    , bass
    , draw
    , treble
    )

import CssModules as CssModules
import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , inPx
        )
import Music.Pitch as Pitch exposing (Pitch)
import TypedSvg
    exposing
        ( g
        , line
        )
import TypedSvg.Attributes exposing (class, x1, x2, y1, y2)
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (px)


type alias Staff =
    { -- basePitch is the pitch of the top space on staff
      basePitch : Pitch
    }


treble : Staff
treble =
    Staff (Pitch.e_ 5)


bass : Staff
bass =
    Staff (Pitch.g 3)


draw : Layout -> Svg msg
draw layout =
    let
        css =
            .toString <|
                CssModules.css "./Music/Staff/staff.css"
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
