module TouchTunes.Views.RulerView exposing (view)

import Html exposing (Html)
import List.Nonempty as Nonempty
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Layout as Layout exposing (Layout, Pixels)
import String exposing (fromFloat)
import Svg exposing (Svg, g, rect, svg)
import Svg.Attributes
    exposing
        ( class
        , height
        , width
        , x
        , y
        )
import TouchTunes.Views.EditorStyles exposing (css)


fromPixels : Pixels -> String
fromPixels p =
    fromFloat p.px


viewBand : Layout -> Float -> Float -> Svg msg
viewBand layout x_ w =
    let
        h =
            Layout.height layout |> .px

        hh =
            Layout.harmonyHeight layout |> .px

        sp =
            Layout.spacing layout |> .px

        pad =
            sp / 8.0
    in
    g []
        [ rect
            [ class (css .underharmony)
            , x <| fromFloat x_
            , y "0"
            , height <| fromFloat (hh - pad)
            , width <| fromFloat w
            ]
            []
        , rect
            [ class (css .understaff)
            , x <| fromFloat x_
            , y <| fromFloat (hh + pad)
            , height <| fromFloat (h - hh - pad)
            , width <| fromFloat w
            ]
            []
        , rect
            [ x <| fromFloat x_
            , y <| fromFloat <| h - sp / 4.0
            , height <| fromFloat <| sp / 4.0
            , width <| fromFloat w
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


view : Layout -> Svg msg
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
    g
        [ class (css .ruler) ]
        (List.concat
            [ [ g [ class (css .margins) ]
                    [ viewBand layout 0 (m.left.px - pad)
                    , viewBand layout (w.px - m.right.px + pad) (m.right.px - pad)
                    ]
              ]
            , if w.px > fixed.px then
                [ g [ class (css .overflow) ]
                    [ viewBand layout (fixed.px - m.right.px + pad) (w.px - fixed.px - 2.0 * pad) ]
                ]

              else
                []
            , [ g [] <|
                    List.map2
                        (viewBeat layout)
                        (Nonempty.toList layout.divisors)
                    <|
                        List.map Beat.fullBeat <|
                            List.range 0 (beats - 1)
              ]
            ]
        )
