module Music.Measure.Layout exposing
    ( Layout
    , Location
    , Margins
    , Pixels
    , Tenths
    , beatSpacing
    , bottomStep
    , durationSpacing
    , halfSpacing
    , height
    , inPx
    , locationAfter
    , margins
    , positionOnStaff
    , positionToLocation
    , scaleBeat
    , scalePitch
    , scaleStep
    , spacing
    , standard
    , subdivide
    , toPixels
    , toTenths
    , topStep
    , width
    , withDivisors
    , zoomed
    )

import Browser
import List.Extra exposing (initialize)
import List.Nonempty as Nonempty exposing (Nonempty)
import Music.Beat as Beat exposing (Beat)
import Music.Duration as Duration exposing (Duration, division)
import Music.Pitch as Pitch exposing (Pitch, StepNumber)
import Music.Staff.Model exposing (Staff)
import Music.Time as Time exposing (Time)
import Tuple exposing (first, second)
import TypedSvg.Types exposing (Length, px)



-- Layout
-- Compute dimensions for laying out notes on a staff


type alias Layout =
    { zoom : Float
    , basePitch : Pitch
    , time : Time
    , divisors : Nonempty Int
    }


type alias Pixels =
    { px : Float
    }


type alias Tenths =
    { ths : Float
    }


unitDivisors : Time -> Nonempty Int
unitDivisors time =
    let
        ones =
            initialize time.beatsPerMeasure (\_ -> 1)
    in
    Maybe.withDefault (Nonempty.fromElement 1) (Nonempty.fromList ones)


standard : Staff -> Time -> Layout
standard =
    -- layout for given staff and time at standard zoom level
    zoomed 2.0


zoomed : Float -> Staff -> Time -> Layout
zoomed zoom staff time =
    Layout zoom staff.basePitch time (unitDivisors time)


withDivisors : Nonempty Int -> Layout -> Layout
withDivisors divs layout =
    { layout | divisors = divs }


subdivide : Int -> Layout -> Layout
subdivide div layout =
    { layout | divisors = Nonempty.map (\d -> max d div) layout.divisors }


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
    }


positionToLocation : Layout -> ( Int, Int ) -> Location
positionToLocation layout offset =
    let
        x =
            Pixels <| toFloat <| first offset

        beat =
            unscaleBeat layout x

        y =
            Pixels <| toFloat <| second offset

        step =
            unscaleStep layout y
    in
    { step = step
    , beat = beat
    }


locationAfter : Layout -> Location -> Location
locationAfter layout loc =
    let
        divisor =
            layout.time.getsOneBeat
                * Nonempty.get loc.beat.full layout.divisors
    in
    { step = loc.step
    , beat = Beat.add layout.time (division divisor) loc.beat
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


durationSpacing : Layout -> Duration -> Pixels
durationSpacing layout dur =
    let
        beats =
            Beat.toFloat <|
                Beat.fromDuration layout.time dur
    in
    Tenths (40.0 * beats) |> toPixels layout


width : Layout -> Pixels
width layout =
    -- width of the layout
    let
        m =
            margins layout

        b =
            Nonempty.length layout.divisors

        bs =
            beatSpacing layout
    in
    m.left.px + m.right.px + toFloat b * bs.px |> Pixels


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
scaleBeat layout beat =
    -- location of the left edge of the beat on the staff
    let
        m =
            margins layout

        bs =
            beatSpacing layout
    in
    m.left.px + bs.px * Beat.toFloat beat |> Pixels


unscaleBeat : Layout -> Pixels -> Beat
unscaleBeat layout x =
    -- return the beat, given X pixels from left of layout
    let
        m =
            margins layout

        bs =
            beatSpacing layout

        scaled =
            (x.px - m.left.px) / bs.px

        divisor =
            Nonempty.get (floor scaled) layout.divisors

        totalDivs =
            floor (scaled * toFloat divisor)
    in
    { full = totalDivs // divisor
    , parts = modBy divisor totalDivs
    , divisor = divisor
    }
