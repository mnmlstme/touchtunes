module Music.Staff
    exposing
        ( Staff
        , Tenths
        , treble
        , bass
        , layout
        , view
        )

import Music.Pitch as Pitch exposing (Pitch)
import Music.Note as Note exposing (Note)
import Html exposing (Html)
import Svg
    exposing
        ( Svg
        , svg
        , g
        , line
        , use
        )
import Svg.Attributes
    exposing
        ( class
        , height
        , width
        , viewBox
        , x
        , x1
        , x2
        , y
        , y1
        , y2
        , xlinkHref
        )


type alias Staff =
    { -- basePitch is the pitch of the lowest space on staff
      basePitch : Pitch
    , scale : Scale
    }


treble : Scale -> Staff
treble =
    Staff (Pitch.f 4)


bass : Scale -> Staff
bass =
    Staff (Pitch.a 2)



-- Tenths
-- All dimensions are in tenths of the interline staff spacing


type alias Tenths =
    Float



-- Scale
-- Scale is the number of Pixels per Tenth


type alias Scale =
    Float



-- Layout
-- All dimensions required to layout notes on a staff


type alias Margins =
    { top : Float
    , right : Float
    , bottom : Float
    , left : Float
    }


type alias Layout =
    { spacing : Float
    , margins : Margins
    , w : Float
    , h : Float
    , scalePitch : Pitch -> Float
    }


layout : Staff -> Tenths -> Layout
layout staff width =
    let
        spacing =
            staff.scale * 10.0

        vmargin =
            2.0 * spacing

        margins =
            Margins vmargin 0.0 vmargin 0.0

        w =
            staff.scale * width

        h =
            margins.top + margins.bottom + 4 * spacing

        base =
            Pitch.stepNumber staff.basePitch

        -- scalePitch locates the top of the note on staff
        scalePitch p =
            let
                n =
                    (Pitch.stepNumber p) - base
            in
                vmargin
                    + 3.0
                    * spacing
                    - (toFloat n)
                    / 2.0
                    * spacing
    in
        Layout spacing margins w h scalePitch


drawStaffLine : Layout -> Int -> Svg msg
drawStaffLine layout n =
    let
        x0 =
            layout.margins.left

        y0 =
            layout.margins.top

        y =
            y0 + toFloat n * layout.spacing
    in
        line
            [ x1 (toString x0)
            , x2 (toString (x0 + layout.w))
            , y1 (toString y)
            , y2 (toString y)
            ]
            []


drawNote : Layout -> Note -> Svg msg
drawNote layout note =
    let
        sym =
            "#quarter-note-stem-up"

        ypos =
            layout.scalePitch note.pitch
    in
        g []
            [ use
                [ xlinkHref sym
                , x "0"
                , y (toString ypos)
                , height "20"
                ]
                []
            ]


view : Staff -> Layout -> List Note -> Html msg
view staff layout notes =
    let
        vb =
            [ 0.0, 0.0, layout.w, layout.h ]
    in
        svg
            [ class "staff"
            , height (toString layout.h)
            , width (toString layout.w)
            , viewBox (String.join " " (List.map toString vb))
            ]
            [ g [ class "staff-lines" ]
                (List.map
                    (drawStaffLine layout)
                    (List.range 0 4)
                )
            , g [ class "staff-notes" ]
                (List.map
                    (drawNote layout)
                    notes
                )
            ]
