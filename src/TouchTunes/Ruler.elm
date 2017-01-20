module TouchTunes.Ruler exposing (view)

import Music.Measure.Model as Measure exposing (Measure)
import Music.Measure.View exposing (layoutFor)
import Music.Measure.Layout as Layout
import Svg exposing (Svg, svg, g, rect)
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
            sp / 8.0

        beats =
            Measure.length measure

        viewSegment b =
            let
                xmid =
                    Layout.scaleBeat layout b
            in
                rect
                    [ x <| toString (xmid - bsp / 2.0 + pad)
                    , y <| toString 0
                    , height <| toString (sp / 4.0)
                    , width <| toString (bsp - 2.0 * pad)
                    ]
                    []
    in
        svg
            [ class "measure-ruler"
            , height <| toString sp
            , width <| toString w
            ]
            (List.map
                viewSegment
                (List.range 0 (beats - 1))
            )
