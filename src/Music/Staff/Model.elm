module Music.Staff.Model
    exposing
        ( Staff
        , bass
        , draw
        , treble
        )

import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , x1Px
        , x2Px
        , y1Px
        , y2Px
        )
import Music.Pitch as Pitch exposing (Pitch)
import Svg
    exposing
        ( Svg
        , g
        , line
        )
import Svg.Attributes exposing (class)
import CssModules exposing (css)


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
        styles =
            css "./Music/Staff/staff.css"
                { staff = "staff"
                , barline = "barline"
                , lines = "lines"
                }
    in
        g [ class <| styles.toString .staff ]
            [ g [ class <| styles.toString .lines ]
                (List.map (drawStaffLine layout) (List.range 0 4))
            , g [ class <| styles.toString .barline ]
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
            Pixels <| toFloat n * s.px
    in
        line
            [ x1Px <| Pixels 0
            , x2Px width
            , y1Px y
            , y2Px y
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
            Pixels <| 4.0 * sp.px
    in
        line
            [ x1Px width
            , y1Px <| Pixels 0
            , x2Px width
            , y2Px height
            ]
            []
