module Music.Layout
    exposing
        ( Layout
        , Zoom
        , Tenths
        , Margins
        , layout
        , standard
        )

import Music.Pitch as Pitch exposing (Pitch)
import Music.Time exposing (Time, Beat)


-- Layout
-- All dimensions required to layout notes on a staff


type alias Layout =
    { zoom : Zoom
    , spacing : Float
    , margins : Margins
    , w : Float
    , h : Float
    , scalePitch : Pitch -> Float
    , scaleBeat : Beat -> Float
    , unscalePitch : Float -> Pitch
    }


type alias Margins =
    { top : Float
    , right : Float
    , bottom : Float
    , left : Float
    }



-- Tenths
-- All dimensions are in tenths of the interline staff spacing


type alias Tenths =
    Float



-- Zoom
-- Zoom is the number of Pixels per Tenth


type alias Zoom =
    Float


layout : Zoom -> Pitch -> Time -> Layout
layout zoom basePitch time =
    let
        beats =
            time.beats

        spacing =
            zoom * 10.0

        beatSpacing =
            zoom * 40.0

        vmargin =
            2.0 * spacing

        hmargin =
            spacing

        margins =
            Margins vmargin hmargin vmargin hmargin

        w =
            margins.left
                + margins.right
                + (toFloat beats)
                * beatSpacing

        h =
            margins.top + margins.bottom + 4 * spacing

        base =
            Pitch.stepNumber basePitch

        -- scalePitch locates the top of the note on staff
        scalePitch p =
            let
                n =
                    (Pitch.stepNumber p) - base
            in
                margins.top
                    + 3.0
                    * spacing
                    - (toFloat n)
                    / 2.0
                    * spacing

        -- unscalePitch returns the pitch, given Y pixels
        unscalePitch y =
            let
                ybase =
                    margins.top + 3.5 * spacing

                n =
                    round (2.0 * (ybase - y) / spacing)

                sn =
                    base + n
            in
                Pitch.fromStepNumber sn

        -- scaleBeat locates the center of the beat on staff
        scaleBeat b =
            margins.left + ((toFloat b) + 0.5) * beatSpacing
    in
        Layout zoom spacing margins w h scalePitch scaleBeat unscalePitch


standard : Pitch -> Time -> Layout
standard =
    layout 2.0
