module TouchTunes.MeasureEdit.Ruler exposing (view)

import Music.Measure.Layout as Layout
    exposing
        ( Pixels
        , heightPx
        , widthPx
        , xPx
        , yPx
        )
import Music.Measure.Model as Measure exposing (Measure)
import Music.Measure.View exposing (layoutFor)
import Svg exposing (Svg, g, rect, svg)
import Svg.Attributes
    exposing
        ( class
        , height
        , width
        , x
        , y
        )


view : Measure -> Svg msg
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
                [ xPx <| Pixels (xmid.px - bsp.px / 2.0 + pad)
                , yPx <| Pixels 0
                , heightPx <| Pixels (sp.px / 4.0)
                , widthPx <| Pixels (bsp.px - 2.0 * pad)
                ]
                []
    in
    svg
        [ class "measure-ruler"
        , heightPx sp
        , widthPx w
        ]
        (List.map
            viewSegment
            (List.range 0 (beats - 1))
        )
