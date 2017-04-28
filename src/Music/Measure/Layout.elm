module Music.Measure.Layout
    exposing
        ( Layout
        , Pixels
        , Tenths
        , Margins
        , toPixels
        , toTenths
        , heightPx
        , widthPx
        , xPx
        , x1Px
        , x2Px
        , yPx
        , y1Px
        , y2Px
        , cxPx
        , cyPx
        , rPx
        , Location
        , positionToLocation
        , spacing
        , halfSpacing
        , beatSpacing
        , width
        , height
        , margins
        , positionOnStaff
        , scalePitch
        , unscalePitch
        , scaleStep
        , unscaleStep
        , scaleBeat
        , unscaleBeat
        , standard
        )

import Music.Pitch as Pitch exposing (Pitch, StepNumber)
import Music.Time as Time exposing (Time, Beat)
import Svg exposing (Attribute)
import Svg.Attributes as Attributes
import Mouse


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


pxAttribute : (String -> Attribute msg) -> (Pixels -> Attribute msg)
pxAttribute strAttr =
    .px >> toString >> strAttr


heightPx : Pixels -> Attribute msg
heightPx =
    pxAttribute Attributes.height


widthPx : Pixels -> Attribute msg
widthPx =
    pxAttribute Attributes.width


xPx : Pixels -> Attribute msg
xPx =
    pxAttribute Attributes.x


x1Px : Pixels -> Attribute msg
x1Px =
    pxAttribute Attributes.x1


x2Px : Pixels -> Attribute msg
x2Px =
    pxAttribute Attributes.x2


yPx : Pixels -> Attribute msg
yPx =
    pxAttribute Attributes.y


y1Px : Pixels -> Attribute msg
y1Px =
    pxAttribute Attributes.y1


y2Px : Pixels -> Attribute msg
y2Px =
    pxAttribute Attributes.y2


cxPx : Pixels -> Attribute msg
cxPx =
    pxAttribute Attributes.cx


cyPx : Pixels -> Attribute msg
cyPx =
    pxAttribute Attributes.cy


rPx : Pixels -> Attribute msg
rPx =
    pxAttribute Attributes.r


type alias Location =
    { step : StepNumber
    , beat : Beat
    , shiftx : Tenths
    , shifty : Tenths
    }


positionToLocation : Layout -> Mouse.Position -> Location
positionToLocation layout offset =
    let
        x =
            Pixels <| toFloat offset.x

        beat =
            unscaleBeat layout x

        xb =
            scaleBeat layout beat

        y =
            Pixels <| toFloat offset.y

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


positionOnStaff : Layout -> Pitch -> Int
positionOnStaff layout p =
    -- distance (in steps) above (below if negative) base pitch of staff
    (Pitch.stepNumber p)
        - (Pitch.stepNumber layout.basePitch)


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
    let
        m =
            margins layout

        bs =
            beatSpacing layout
    in
        m.left.px + bs.px * (0.5 + toFloat b) |> Pixels


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
