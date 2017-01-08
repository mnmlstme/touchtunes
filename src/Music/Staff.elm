module Music.Staff
    exposing
        ( Staff
        , treble
        , bass
        , draw
        )

import Music.Pitch as Pitch exposing (Pitch)
import Music.Layout as Layout exposing (Layout)
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
            m.top + toFloat n * s
    in
        line
            [ x1 "0"
            , x2 <| toString width
            , y1 <| toString y
            , y2 <| toString y
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
            [ x1 <| toString width
            , y1 <| toString m.top
            , x2 <| toString width
            , y2 <| toString <| height - m.bottom
            ]
            []
