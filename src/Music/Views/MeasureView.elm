module Music.Views.MeasureView exposing
    ( view
    , viewTime
    )

import Html exposing (Html, div, text)
import Html.Attributes as HtmlAttr exposing (style)
import List.Nonempty as Nonempty
import Music.Models.Beat as Beat
import Music.Models.Key as Key exposing (Key)
import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , scalePitch
        )
import Music.Models.Measure as Measure exposing (..)
import Music.Models.Pitch as Pitch exposing (Pitch, flat, sharp)
import Music.Models.Staff as Staff
import Music.Models.Time as Time exposing (Time)
import Music.Views.MeasureStyles exposing (css)
import Music.Views.NoteView as NoteView
import Music.Views.StaffView as StaffView
import Music.Views.Symbols as Symbols
import String exposing (fromFloat, fromInt)
import Svg exposing (Svg, g, svg, text_)
import Svg.Attributes
    exposing
        ( class
        , fontSize
        , height
        , transform
        , width
        , x
        , y
        )


viewTime : Layout -> Maybe Time -> Svg msg
viewTime layout time =
    let
        sp =
            Layout.spacing layout

        offset =
            Layout.timeOffset layout
    in
    case time of
        Just t ->
            g
                [ class (css .time)
                , transform ("translate(" ++ fromFloat offset.px ++ ",0)")
                ]
                [ text_
                    [ fontSize <| fromFloat <| 3.0 * sp.px
                    , x <| fromFloat <| 0.8 * sp.px
                    , y <| fromFloat <| 2.0 * sp.px
                    ]
                    [ text <| fromInt t.beats ]
                , text_
                    [ fontSize <| fromFloat <| 3.0 * sp.px
                    , x <| fromFloat <| 1.2 * sp.px
                    , y <| fromFloat <| 4.0 * sp.px
                    ]
                    [ text <| fromInt (Time.divisor t) ]
                ]

        Nothing ->
            text ""


sharpPitches =
    [ sharp Pitch.f 5
    , sharp Pitch.c 5
    , sharp Pitch.g 5
    , sharp Pitch.d 5
    , sharp Pitch.a 4
    , sharp Pitch.e_ 5
    ]


flatPitches =
    [ flat Pitch.b 4
    , flat Pitch.e_ 5
    , flat Pitch.a 4
    , flat Pitch.d 5
    , flat Pitch.g 4
    , flat Pitch.c 5
    ]


sharpSymbol =
    Symbols.sharp


flatSymbol =
    Symbols.flat


drawKeySymbol : Layout -> Int -> Pitch -> Svg msg
drawKeySymbol layout n p =
    let
        sp =
            Layout.spacing layout

        symbol =
            if p.alter > 0 then
                sharpSymbol

            else
                flatSymbol

        ypos =
            scalePitch layout p

        xpos =
            Pixels <| sp.px * toFloat n
    in
    g
        [ transform
            ("translate(" ++ fromFloat xpos.px ++ "," ++ fromFloat ypos.px ++ ")")
        ]
        [ Symbols.view symbol ]


viewKey : Layout -> Maybe Key -> Svg msg
viewKey layout key =
    case key of
        Just k ->
            let
                sp =
                    Layout.spacing layout

                sharps =
                    if k.fifths > 0 then
                        List.take k.fifths sharpPitches

                    else
                        []

                flats =
                    if k.fifths < 0 then
                        List.take (0 - k.fifths) flatPitches

                    else
                        []

                offset =
                    Layout.keyOffset layout
            in
            g
                [ class (css .key)
                , transform ("translate(" ++ fromFloat offset.px ++ ",0)")
                ]
            <|
                List.indexedMap (drawKeySymbol layout) <|
                    List.append sharps flats

        Nothing ->
            text ""


view : Layout -> Measure -> Html msg
view layout measure =
    let
        t =
            Layout.time layout

        w =
            Layout.width layout

        fixed =
            Layout.fixedWidth layout

        h =
            Layout.height layout

        drawNote =
            \( beat, note ) ->
                NoteView.view layout beat note

        noteSequence =
            List.map (\( d, n ) -> ( Beat.fromDuration t d, n )) <|
                toSequence measure
    in
    div [ HtmlAttr.class (css .measure) ] <|
        List.append
            [ svg
                [ class (css .staff)
                , height <| fromFloat h.px
                , width <| fromFloat w.px
                ]
                [ g
                    [ transform
                        ("translate(0," ++ fromFloat (Layout.margins layout).top.px ++ ")")
                    ]
                    [ StaffView.draw layout
                    , viewTime layout layout.direct.time
                    ]
                , viewKey layout layout.direct.key
                ]
            ]
        <|
            List.map drawNote noteSequence
