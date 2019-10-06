module Music.Measure.Layout exposing
    ( Layout
    , Location
    , Margins
    , Pixels
    , Tenths
    , beatSpacing
    , bottomStep
    , halfSpacing
    , height
    , inPx
    , margins
    , positionOnStaff
    , positionToLocation
    , scaleBeat
    , scaleEndBeat
    , scaleFractionalBeat
    , scalePitch
    , scaleStartBeat
    , scaleStep
    , spacing
    , standard
    , toPixels
    , toTenths
    , topStep
    , unscaleBeat
    , unscalePitch
    , unscaleStep
    , width
    )

import Browser
import Music.Pitch as Pitch exposing (Pitch, StepNumber)
import Music.Time as Time exposing (Beat, Time)
import String
import Tuple exposing (first, second)
import TypedSvg.Types exposing (Length, px)



-- Layout
-- Compute dimensions for laying out notes on a staff


type alias Layout =
    { zoom : Float
    , basePitch : Pitch
    , time : Time
    }


type alias Pixels =
    { px : Float
    }


type alias Tenths =
    { ths : Float
    }


toPixels : Layout -> Tenths -> Pixels
toPixels layout tenths =
    Pixels <| layout.zoom * tenths.ths


toTenths : Layout -> Pixels -> Tenths
toTenths layout pixels =
    Tenths <| pixels.px / layout.zoom


inPx : Pixels -> Length
inPx =
    .px >> px


type alias Location =
    { step : StepNumber
    , beat : Beat
    , shiftx : Tenths
    , shifty : Tenths
    }


positionToLocation : Layout -> ( Int, Int ) -> Location
positionToLocation layout offset =
    let
        x =
            Pixels <| toFloat <| first offset

        beat =
            unscaleBeat layout x

        xb =
            scaleBeat layout beat

        y =
            Pixels <| toFloat <| second offset

        step =
            unscaleStep layout y

        ys =
            scaleStep layout step
    in
    { step = step
    , beat = beat
    , shiftx = toTenths layout <| Pixels <| x.px - xb.px
    , shifty = toTenths layout <| Pixels <| y.px - ys.px
    }


type alias Margins =
    { top : Pixels
    , right : Pixels
    , bottom : Pixels
    , left : Pixels
    }


spacing : Layout -> Pixels
spacing layout =
    -- the interline staff spacing in pixels
    Tenths 10.0 |> toPixels layout


halfSpacing : Layout -> Pixels
halfSpacing layout =
    Tenths 5.0 |> toPixels layout


margins : Layout -> Margins
margins layout =
    -- the margins around where notes are placed on staff
    let
        sp =
            spacing layout |> .px

        vmargin =
            4.5 * sp |> Pixels

        hmargin =
            spacing layout
    in
    Margins vmargin hmargin vmargin hmargin


beatSpacing : Layout -> Pixels
beatSpacing layout =
    Tenths 40.0 |> toPixels layout


width : Layout -> Pixels
width layout =
    -- width of the layout
    let
        m =
            margins layout

        b =
            toFloat layout.time.beats

        bs =
            beatSpacing layout
    in
    m.left.px + m.right.px + b * bs.px |> Pixels


height : Layout -> Pixels
height layout =
    -- height of the layout
    let
        m =
            margins layout

        s =
            spacing layout
    in
    m.top.px + m.bottom.px + 4 * s.px |> Pixels


topStep : Layout -> StepNumber
topStep layout =
    unscaleStep layout <|
        halfSpacing layout


bottomStep : Layout -> StepNumber
bottomStep layout =
    let
        h =
            height layout

        hs =
            halfSpacing layout
    in
    unscaleStep layout <| Pixels <| h.px - hs.px


positionOnStaff : Layout -> Pitch -> Int
positionOnStaff layout p =
    -- distance (in steps) above (below if negative) base pitch of staff
    Pitch.stepNumber p
        - Pitch.stepNumber layout.basePitch


scaleStep : Layout -> StepNumber -> Pixels
scaleStep layout sn =
    -- location of the middle of the step from the top of the layout
    let
        s =
            spacing layout

        m =
            margins layout

        n =
            Pitch.stepNumber layout.basePitch - sn
    in
    Pixels <|
        toFloat n
            / 2.0
            * s.px
            + m.top.px
            + (s.px / 2.0)


unscaleStep : Layout -> Pixels -> StepNumber
unscaleStep layout y =
    -- return the stepNumber, given Y pixels from top of layout
    let
        s =
            spacing layout

        m =
            margins layout

        n =
            round (2.0 * (y.px - m.top.px - s.px / 2.0) / s.px)
    in
    Pitch.stepNumber layout.basePitch
        - n


scalePitch : Layout -> Pitch -> Pixels
scalePitch layout p =
    -- location the middle of the note from the top of the layout
    Pitch.stepNumber p
        |> scaleStep layout


unscalePitch : Layout -> Pixels -> Pitch
unscalePitch layout y =
    -- return the pitch, given Y pixels from top of layout
    unscaleStep layout y
        |> Pitch.fromStepNumber


scaleBeat : Layout -> Beat -> Pixels
scaleBeat layout b =
    -- location of the center of the note on the staff
    scaleFractionalBeat layout <| 0.5 + toFloat b


scaleStartBeat : Layout -> Beat -> Pixels
scaleStartBeat layout b =
    -- location of the left edge of the beat on the staff
    scaleFractionalBeat layout <| toFloat b


scaleEndBeat : Layout -> Beat -> Pixels
scaleEndBeat layout b =
    -- location of the right edge of the beat on the staff
    scaleFractionalBeat layout <| toFloat (b + 1)


scaleFractionalBeat : Layout -> Float -> Pixels
scaleFractionalBeat layout x =
    -- scaled location of a specific moment within the beat
    let
        m =
            margins layout

        bs =
            beatSpacing layout
    in
    m.left.px + bs.px * x |> Pixels


unscaleBeat : Layout -> Pixels -> Beat
unscaleBeat layout x =
    -- return the beat, given X pixels from left of layout
    let
        m =
            margins layout

        bs =
            beatSpacing layout
    in
    floor ((x.px - m.left.px) / bs.px)


standard : Pitch -> Time -> Layout
standard =
    -- layout for standard (zoom level)
    Layout 2.0
