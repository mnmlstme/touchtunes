module Music.Staff
    exposing
        ( Staff
        , treble
        , bass
        , draw
        )

import Music.Pitch as Pitch exposing (Pitch)
import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , x1Px
        , x2Px
        , y1Px
        , y2Px
        )
import Svg
    exposing
        ( Svg
        , g
        , line
        )
import Svg.Attributes exposing (class)


type alias Staff =
    { -- basePitch is the pitch of the lowest space on staff
      basePitch : Pitch
    }


treble : Staff
treble =
    Staff (Pitch.f 4)


bass : Staff
bass =
    Staff (Pitch.a 2)


draw : Layout -> Svg msg
draw layout =
    g [ class "staff" ]
        [ g [ class "staff-lines" ]
            (List.map (drawStaffLine layout) (List.range 0 4))
        , g [ class "staff-barline" ]
            [ drawBarLine layout ]
        ]


drawStaffLine : Layout -> Int -> Svg msg
drawStaffLine layout n =
    let
        m =
            Layout.margins layout

        s =
            Layout.spacing layout

        width =
            Layout.width layout

        y =
            Pixels <| m.top.px + toFloat n * s.px
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
        m =
            Layout.margins layout

        width =
            Layout.width layout

        height =
            Layout.height layout
    in
        line
            [ x1Px width
            , y1Px m.top
            , x2Px width
            , y2Px <| Pixels <| height.px - m.bottom.px
            ]
            []
