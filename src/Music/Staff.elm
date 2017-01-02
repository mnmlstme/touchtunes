module Music.Staff
    exposing
        ( Staff
        , Tenths
        , treble
        , bass
        , layout
        , view
        )

import Music.Pitch exposing (Pitch, f, a)
import Music.Note exposing (Note)
import Html exposing (Html)
import Svg
    exposing
        ( Svg
        , svg
        , g
        , line
        )
import Svg.Attributes
    exposing
        ( class
        , height
        , width
        , viewBox
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
    Staff (f 4)


bass : Staff
bass =
    Staff (a 2)



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
    { scale : Scale
    , spacing : Float
    , margins : Margins
    , w : Float
    , h : Float
    }


layout : Scale -> Tenths -> Layout
layout scale width =
    let
        spacing =
            scale * 10.0

        vmargin =
            2.0 * spacing

        w =
            scale * width

        h =
            2 * vmargin + 4 * spacing
    in
        Layout scale spacing (Margins vmargin 0.0 vmargin 0.0) w h


staffLine : Layout -> Int -> Svg msg
staffLine layout n =
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
                    (staffLine layout)
                    (List.range 0 4)
                )
            ]
