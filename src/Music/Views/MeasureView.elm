module Music.Views.MeasureView exposing
    ( drawKey
    , drawTime
    , view
    )

import Html exposing (Html)
import Music.Models.Beat as Beat
import Music.Models.Key exposing (Key)
import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , scalePitch
        )
import Music.Models.Measure exposing (Measure, toSequence)
import Music.Models.Pitch as Pitch exposing (Pitch, flat, sharp)
import Music.Models.Time as Time exposing (Time)
import Music.Views.MeasureStyles exposing (css)
import Music.Views.NoteView as NoteView
import Music.Views.StaffView as StaffView
import Music.Views.Symbols as Symbols
import String exposing (fromFloat, fromInt)
import Svg exposing (Svg, g, svg, text, text_)
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
import Music.Models.Staff exposing (Staff)


drawTime : Layout -> Maybe Time -> Svg msg
drawTime layout time =
    let
        sp =
            Layout.spacing layout
    in
    case time of
        Just t ->
            g
                [ class (css .time)                ]
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

        margins =
            Layout.margins layout

        symbol =
            if p.alter > 0 then
                sharpSymbol

            else
                flatSymbol

        ypos =
            scalePitch layout p

        xpos =
            Pixels <| 0.75 * sp.px * toFloat n
    in
    g
        [ transform <|
            "translate("
                ++ fromFloat (xpos.px + sp.px)
                ++ ","
                ++ fromFloat (ypos.px - margins.top.px)
                ++ ")"
        ]
        [ Symbols.view symbol ]


drawKey : Layout -> Maybe Key -> Svg msg
drawKey layout key =
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

                marks =
                    abs k.fifths
            in
            g
                [ class (css .key)
                , transform <| "translate(0," ++ fromFloat sp.px ++ ")"
                ]
            <|
                List.indexedMap (drawKeySymbol layout) <|
                    List.append sharps flats

        Nothing ->
            text ""


drawClef : Layout -> Maybe Staff -> Svg msg
drawClef layout clef =
    case clef of
        Just c ->
            let
                sp =
                    Layout.spacing layout

                symbol =
                    Symbols.trebleClef
            in
            g
                [ class (css .clef)
                , transform <|
                    "translate("
                        ++ fromFloat (1.5 * sp.px)
                        ++ ","
                        ++ fromFloat sp.px
                        ++ ")"
                ]
                [ Symbols.view symbol ]

        Nothing ->
            text ""


view : Layout -> Measure -> Html msg
view layout measure =
    let
        t =
            Layout.time layout

        w =
            Layout.width layout

        h =
            Layout.height layout

        sp =
            Layout.spacing layout

        margins =
            Layout.margins layout

        keyOffset =
            Layout.keyOffset layout

        timeOffset =
            Layout.timeOffset layout

        drawNote =
            \( beat, note ) ->
                NoteView.draw layout beat note

        noteSequence =
            List.map (\( d, n ) -> ( Beat.fromDuration t d, n )) <|
                toSequence measure
    in
    svg
        [ class (css .measure)
        , height <| fromFloat h.px
        , width <| fromFloat w.px
        ]
    <|
        List.append
            [ g
                [ class (css .staff)
                , transform <|
                    "translate(0,"
                        ++ fromFloat margins.top.px
                        ++ ")"
                ]
                [ StaffView.draw layout ]
            , g
                [ class (css .clef)
                , transform <|
                    "translate(0,"
                        ++ fromFloat (margins.top.px + sp.px)
                        ++ ")"
                ]
                [ drawClef layout layout.direct.staff ]
            , g
                [ class (css .key)
                , transform <|
                    "translate("
                        ++ fromFloat keyOffset.px
                        ++ ","
                        ++ fromFloat (margins.top.px - sp.px)
                        ++ ")"
                ]
                [ drawKey layout layout.direct.key ]
            , g
                [ class (css .time)
                , transform <|
                    "translate("
                        ++ fromFloat timeOffset.px
                        ++ ","
                        ++ fromFloat margins.top.px
                        ++ ")"
                ]
                [ drawTime layout layout.direct.time ]
            ]
        <|
            List.map drawNote noteSequence
