module Music.Models.Layout exposing
    ( Layout
    , Location
    , Margins
    , Pixels
    , Tenths
    , beatSpacing
    , bottomStep
    , durationSpacing
    , fixedWidth
    , forMeasure
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
    , staff
    , subdivide
    , time
    , toPixels
    , toTenths
    , topStep
    ,  width
       -- , withDivisors
       --, withTime

    )

import Browser
import List.Extra exposing (initialize)
import List.Nonempty as Nonempty exposing (Nonempty)
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration, division)
import Music.Models.Measure as Measure
    exposing
        ( Attributes
        , Measure
        , noAttributes
        )
import Music.Models.Pitch as Pitch exposing (Pitch, StepNumber)
import Music.Models.Staff as Staff exposing (Staff)
import Music.Models.Time as Time exposing (Time)
import Tuple exposing (first, second)
import TypedSvg.Types exposing (Length, px)



-- Layout
-- Compute dimensions for laying out notes on a staff


type alias Layout =
    { zoom : Float
    , divisors : Nonempty Int
    , indirect : Attributes
    , direct : Attributes
    }


type alias Pixels =
    { px : Float
    }


type alias Tenths =
    { ths : Float
    }


getAttribute : (Attributes -> Maybe value) -> Layout -> Maybe value
getAttribute getter layout =
    case getter layout.direct of
        Just v ->
            Just v

        Nothing ->
            getter layout.indirect


time : Layout -> Time
time layout =
    Maybe.withDefault Time.common <| getAttribute .time layout


staff : Layout -> Staff
staff layout =
    Maybe.withDefault Staff.treble <| getAttribute .staff layout


basePitch : Layout -> Pitch
basePitch layout =
    let
        s =
            staff layout
    in
    s.basePitch


subdivide : Int -> Layout -> Layout
subdivide div layout =
    { layout | divisors = Nonempty.map (\d -> max 1 div) layout.divisors }


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
            Time.divisor (time layout)
                * Nonempty.get loc.beat.full layout.divisors
    in
    { step = loc.step
    , beat = Beat.add (time layout) (division divisor) loc.beat
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

        rmargin =
            sp |> Pixels

        lmargin =
            sp
                + (case layout.direct.time of
                    Just _ ->
                        2.0 * sp

                    Nothing ->
                        0.0
                  )
                |> Pixels
    in
    Margins vmargin rmargin vmargin lmargin


beatSpacing : Layout -> Pixels
beatSpacing layout =
    Tenths 40.0 |> toPixels layout


durationSpacing : Layout -> Duration -> Pixels
durationSpacing layout dur =
    let
        beats =
            Beat.toFloat <|
                Beat.fromDuration (time layout) dur
    in
    Tenths (40.0 * beats) |> toPixels layout


width : Layout -> Pixels
width layout =
    -- width of the layout based on notes
    let
        m =
            margins layout

        b =
            Nonempty.length layout.divisors

        bs =
            beatSpacing layout
    in
    m.left.px + m.right.px + toFloat b * bs.px |> Pixels


fixedWidth : Layout -> Pixels
fixedWidth layout =
    -- width of the layout based on time only
    let
        m =
            margins layout

        t =
            time layout

        b =
            t.beats

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
        - Pitch.stepNumber (basePitch layout)


scaleStep : Layout -> StepNumber -> Pixels
scaleStep layout sn =
    -- location of the middle of the step from the top of the layout
    let
        s =
            spacing layout

        m =
            margins layout

        n =
            Pitch.stepNumber (basePitch layout) - sn
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
    Pitch.stepNumber (basePitch layout)
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



-- compute a layout for a measure


divisorFor : Time -> Measure -> Int -> Int
divisorFor t measure i =
    Measure.offsets measure
        |> Nonempty.map (Beat.fromDuration t)
        |> Nonempty.filter (\b -> b.full == i) (Beat.fullBeat 1)
        |> Nonempty.map (\b -> b.divisor)
        |> Nonempty.foldl max 1


fitTime : Time -> Measure -> Time
fitTime t measure =
    -- compute a new time signature that notes will fit in
    let
        beats =
            length t measure
    in
    Beat.fitToTime t beats


length : Time -> Measure -> Beat
length t measure =
    -- count the total number of beats in a measure
    let
        tdur =
            Time.toDuration t

        mdur =
            Measure.length measure
    in
    if Duration.longerThan tdur mdur then
        Beat.fromDuration t <| mdur

    else
        Beat.fullBeat t.beats


forMeasure : Attributes -> Measure -> Layout
forMeasure attrs measure =
    -- the layout accounts for the notes in the measure
    let
        t =
            case measure.attributes.time of
                Just theTime ->
                    theTime

                Nothing ->
                    Maybe.withDefault Time.common attrs.time

        ft =
            fitTime t measure

        divs =
            initialize ft.beats (divisorFor t measure)
    in
    Layout
        2.0
        (Maybe.withDefault
            (Nonempty.fromElement 1)
            (Nonempty.fromList divs)
        )
        attrs
        measure.attributes
