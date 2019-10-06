module TouchTunes.Ruler exposing (view)

import CssModules as CssModules
import Html exposing (Html)
import Music.Measure.Layout as Layout exposing (inPx)
import Music.Measure.Model as Measure exposing (Measure)
import Music.Measure.View exposing (layoutFor)
import TypedSvg exposing (g, rect, svg)
import TypedSvg.Attributes
    exposing
        ( class
        , height
        , width
        , x
        , y
        )
import TypedSvg.Types exposing (px)


css =
    .toString <|
        CssModules.css "./TouchTunes/editor.css"
            { ruler = "ruler"
            }


view : Measure -> Html msg
view measure =
    let
        layout =
            layoutFor measure

        sp =
            Layout.spacing layout

        bsp =
            Layout.beatSpacing layout

        w =
            Layout.width layout

        pad =
            sp.px / 8.0

        beats =
            Measure.length measure

        viewSegment b =
            let
                xmid =
                    Layout.scaleBeat layout b
            in
            rect
                [ x <| px <| xmid.px - bsp.px / 2.0 + pad
                , y <| px 0
                , height <| px <| sp.px / 4.0
                , width <| px <| bsp.px - 2.0 * pad
                ]
                []
    in
    svg
        [ class [ css .ruler ]
        , height <| inPx sp
        , width <| inPx w
        ]
        (List.map
            viewSegment
            (List.range 0 (beats - 1))
        )
