module Music.Views.MeasureView exposing
    ( view
    , viewKey
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
import Music.Models.Staff as Staff exposing (Staff)
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
        , viewBox
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
            svg
                [ class (css .time)
                , width <| fromFloat <| 4.0 * sp.px
                , height <| fromFloat <| 4.0 * sp.px
                , viewBox <|
                    "0 0 "
                        ++ (fromFloat <| 4.0 * sp.px)
                        ++ " "
                        ++ (fromFloat <| 4.0 * sp.px)
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
        [ transform
            ("translate("
                ++ fromFloat (xpos.px + sp.px)
                ++ ","
                ++ fromFloat (ypos.px - margins.top.px)
                ++ ")"
            )
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

                marks =
                    abs k.fifths

                h =
                    Layout.height layout
            in
            svg
                [ class (css .key)
                , width <| fromFloat <| (0.75 + toFloat marks) * sp.px
                , height <| fromFloat <| 5.0 * sp.px
                , viewBox <|
                    "0 "
                        ++ (fromFloat <| -1.0 * sp.px)
                        ++ " "
                        ++ (fromFloat <| (1.0 + toFloat marks) * sp.px)
                        ++ " "
                        ++ (fromFloat <| 5.0 * sp.px)
                ]
            <|
                List.indexedMap (drawKeySymbol layout) <|
                    List.append sharps flats

        Nothing ->
            text ""


viewClef : Layout -> Maybe Staff -> Svg msg
viewClef layout clef =
    case clef of
        Just c ->
            let
                sp =
                    Layout.spacing layout

                symbol =
                    Symbols.trebleClef
            in
            svg
                [ class (css .clef)
                , width <| fromFloat <| 3.0 * sp.px
                , height <| fromFloat <| 5.0 * sp.px
                , viewBox <|
                    (fromFloat <| -1.5 * sp.px)
                        ++ " "
                        ++ (fromFloat <| -1.0 * sp.px)
                        ++ " "
                        ++ (fromFloat <| 3.0 * sp.px)
                        ++ " "
                        ++ (fromFloat <| 5.0 * sp.px)
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

        fixed =
            Layout.fixedWidth layout

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
                        ("translate(0," ++ fromFloat margins.top.px ++ ")")
                    ]
                    [ StaffView.draw layout ]
                ]
            , div
                [ class (css .clef)
                , style "top" <| fromFloat (margins.top.px + sp.px) ++ "px"
                , style "left" "0"
                ]
                [ viewClef layout layout.direct.staff ]
            , div
                [ class (css .key)
                , style "top" <| fromFloat (margins.top.px - sp.px) ++ "px"
                , style "left" <| fromFloat keyOffset.px ++ "px"
                ]
                [ viewKey layout layout.direct.key ]
            , div
                [ class (css .time)
                , style "top" <| fromFloat margins.top.px ++ "px"
                , style "left" <| fromFloat timeOffset.px ++ "px"
                ]
                [ viewTime layout layout.direct.time ]
            ]
        <|
            List.map drawNote noteSequence
