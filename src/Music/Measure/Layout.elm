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
        , spacing
        , beatSpacing
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
import Music.Time as Time exposing (Time, Beat)
import Svg exposing (Attribute)
import Svg.Attributes as Attributes


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


type alias Margins =
    { top : Pixels
    , right : Pixels
    , bottom : Pixels
    , left : Pixels
    }



-- the interline staff spacing in pixels


spacing : Layout -> Pixels
spacing layout =
    Tenths 10.0 |> toPixels layout



-- the margins around where notes are placed on staff


margins : Layout -> Margins
margins layout =
    let
        sp =
            spacing layout |> .px

        vmargin =
            2.0 * sp |> Pixels

        hmargin =
            spacing layout
    in
        Margins vmargin hmargin vmargin hmargin


beatSpacing : Layout -> Pixels
beatSpacing layout =
    Tenths 40.0 |> toPixels layout



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
        m.left.px + m.right.px + b * bs.px |> Pixels



-- height of the layout


height : Layout -> Pixels
height layout =
    let
        m =
            margins layout

        s =
            spacing layout
    in
        m.top.px + m.bottom.px + 4 * s.px |> Pixels



-- distance (in steps) above (below if negative) base pitch of staff


positionOnStaff : Layout -> Pitch -> Int
positionOnStaff layout p =
    let
        base =
            Pitch.stepNumber layout.basePitch
    in
        (Pitch.stepNumber p) - base



-- location the top of the note from the top of the staff


scalePitch : Layout -> Pitch -> Pixels
scalePitch layout p =
    let
        s =
            spacing layout

        n =
            0 - positionOnStaff layout p
    in
        Pixels <| (toFloat n / 2.0) * s.px



-- return the pitch, given Y pixels from top of layout


unscalePitch : Layout -> Pixels -> Pitch
unscalePitch layout y =
    let
        s =
            spacing layout

        m =
            margins layout

        n =
            round (2.0 * (y.px - m.top.px - s.px / 2.0) / s.px)

        base =
            Pitch.stepNumber layout.basePitch

        sn =
            base - n
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
        m.left.px + bs.px * (0.5 + toFloat b) |> Pixels



-- return the beat, given X pixels from left of layout


unscaleBeat : Layout -> Pixels -> Beat
unscaleBeat layout x =
    let
        m =
            margins layout

        bs =
            beatSpacing layout
    in
        floor ((x.px - m.left.px) / bs.px)



-- layout for standard (zoom level)


standard : Pitch -> Time -> Layout
standard =
    Layout 2.0
