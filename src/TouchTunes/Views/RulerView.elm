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
            , underlay = "underlay"
            , margins = "margins"
            , overflow = "overflow"
            }


viewBand : Layout -> Float -> Float -> Svg msg
viewBand layout x_ w =
    let
        h =
            Layout.height layout

        sp =
            Layout.spacing layout
    in
    g []
        [ rect
            [ class [ css .underlay ]
            , x <| px <| x_
            , y <| px 0
            , height <| px <| h.px
            , width <| px <| w
            ]
            []
        , rect
            [ x <| px <| x_
            , y <| px <| h.px - sp.px / 4.0
            , height <| px <| sp.px / 4.0
            , width <| px <| w
            ]
            []
        ]


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
    viewBand layout (xmin.px + pad) (xmax.px - xmin.px - 2.0 * pad)


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

        h =
            Layout.height layout

        m =
            Layout.margins layout

        pad =
            sp.px / 8.0

        beats =
            time.beats

        fixed =
            Layout.fixedWidth layout
    in
    svg
        [ class [ css .ruler ]
        , height <| inPx h
        , width <| inPx w
        ]
        (List.concat
            [ [ g [ class [ css .margins ] ]
                    [ viewBand layout 0 (m.left.px - pad)
                    , viewBand layout (w.px - m.right.px + pad) (m.right.px - pad)
                    ]
              ]
            , if w.px > fixed.px then
                [ g [ class [ css .overflow ] ]
                    [ viewBand layout (fixed.px - m.right.px + pad) (w.px - fixed.px - 2.0 * pad) ]
                ]

              else
                []
            , List.map2
                (viewBeat layout)
                (Nonempty.toList layout.divisors)
              <|
                List.map Beat.fullBeat <|
                    List.range 0 (beats - 1)
            ]
        )
