module TouchTunes.Views.RulerView exposing (view)

import CssModules as CssModules
import Html exposing (Html)
import List.Nonempty as Nonempty
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Layout as Layout exposing (Layout, inPx)
import TypedSvg exposing (g, rect, svg)
import TypedSvg.Attributes
    exposing
        ( class
        , height
        , width
        , x
        , y
        )
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (px)


css =
    .toString <|
        CssModules.css "./TouchTunes/Views/css/editor.css"
            { ruler = "ruler"
            }


viewSegment : Layout -> Duration -> Beat -> Svg msg
viewSegment layout dur beat =
    let
        time =
            Layout.time layout

        sp =
            Layout.spacing layout

        pad =
            sp.px / 8.0

        xmin =
            Layout.scaleBeat layout beat

        xmax =
            Layout.scaleBeat layout <|
                Beat.add time dur beat
    in
    rect
        [ x <| px <| xmin.px + pad
        , y <| px 0
        , height <| px <| sp.px / 4.0
        , width <| px <| xmax.px - xmin.px - 2.0 * pad
        ]
        []


viewBeat : Layout -> Int -> Beat -> Svg msg
viewBeat layout divisor fullBeat =
    let
        time =
            Layout.time layout

        beats =
            List.map
                (\p -> { parts = p, divisor = divisor, full = fullBeat.full })
            <|
                List.range 0 (divisor - 1)

        dur =
            Beat.toDuration time <|
                { parts = 1, divisor = divisor, full = 0 }
    in
    g [] <|
        List.map
            (viewSegment layout dur)
            beats


view : Layout -> Html msg
view layout =
    let
        time =
            Layout.time layout

        sp =
            Layout.spacing layout

        w =
            Layout.width layout

        beats =
            time.beats
    in
    svg
        [ class [ css .ruler ]
        , height <| inPx sp
        , width <| inPx w
        ]
        (List.map2
            (viewBeat layout)
            (Nonempty.toList layout.divisors)
         <|
            List.map Beat.fullBeat <|
                List.range 0 (beats - 1)
        )
