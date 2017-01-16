module Music.Layout
    exposing
        ( Layout
        , Margins
        , spacing
        , width
        , height
        , margins
        , positionOnStaff
        , scalePitch
        , unscalePitch
        , scaleBeat
        , unscaleBeat
        , standard
        )

import Music.Pitch as Pitch exposing (Pitch)
import Music.Time exposing (Time, Beat)


-- Layout
-- Compute dimensions for laying out notes on a staff


type alias Layout =
    { zoom : Float
    , basePitch : Pitch
    , time : Time
    }


type alias Pixels =
    Float


type alias Margins =
    { top : Pixels
    , right : Pixels
    , bottom : Pixels
    , left : Pixels
    }



-- the interline staff spacing in pixels


spacing : Layout -> Pixels
spacing layout =
    10.0 * layout.zoom



-- the margins around where notes are placed on staff


margins : Layout -> Margins
margins layout =
    let
        vmargin =
            2.0 * spacing layout

        hmargin =
            spacing layout
    in
        Margins vmargin hmargin vmargin hmargin


beatSpacing : Layout -> Pixels
beatSpacing layout =
    layout.zoom * 40.0



-- width of the layout


width : Layout -> Pixels
width layout =
    let
        m =
            margins layout

        b =
            toFloat layout.time.beats

        bs =
            beatSpacing layout
    in
        m.left + m.right + b * bs



-- height of the layout


height : Layout -> Pixels
height layout =
    let
        m =
            margins layout

        s =
            spacing layout
    in
        m.top + m.bottom + 4 * s



-- distance (in steps) above base pitch of staff


positionOnStaff : Layout -> Pitch -> Int
positionOnStaff layout p =
    let
        base =
            Pitch.stepNumber layout.basePitch
    in
        (Pitch.stepNumber p) - base



-- location the top of the note on staff


scalePitch : Layout -> Pitch -> Pixels
scalePitch layout p =
    let
        m =
            margins layout

        s =
            spacing layout

        n =
            positionOnStaff layout p
    in
        m.top + (3.0 - toFloat n / 2.0) * s



-- return the pitch, given Y pixels


unscalePitch : Layout -> Pixels -> Pitch
unscalePitch layout y =
    let
        m =
            margins layout

        s =
            spacing layout

        ybase =
            m.top + 3.5 * s

        n =
            round (2.0 * (ybase - y) / s)

        base =
            Pitch.stepNumber layout.basePitch

        sn =
            base + n
    in
        Pitch.fromStepNumber sn



-- location of the center of the note on the staff


scaleBeat : Layout -> Beat -> Pixels
scaleBeat layout b =
    let
        m =
            margins layout

        bs =
            beatSpacing layout
    in
        m.left + bs * (0.5 + toFloat b)



-- return the beat, given X pixels


unscaleBeat : Layout -> Pixels -> Beat
unscaleBeat layout x =
    let
        m =
            margins layout

        bs =
            beatSpacing layout
    in
        round ((x - m.left) / bs)



-- layout for standard (zoom level)


standard : Pitch -> Time -> Layout
standard =
    Layout 2.0
