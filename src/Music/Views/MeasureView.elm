module Music.Views.MeasureView exposing
    ( view
    , viewTime
    )

import CssModules as CssModules
import Debug exposing (log)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, style)
import Icon.SvgAsset as SvgAsset exposing (SvgAsset, svgAsset)
import List.Nonempty as Nonempty
import Music.Models.Beat as Beat
import Music.Models.Key as Key exposing (Key)
import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , inPx
        , scalePitch
        )
import Music.Models.Measure as Measure exposing (..)
import Music.Models.Pitch as Pitch exposing (Pitch, flat, sharp)
import Music.Models.Staff as Staff
import Music.Models.Time as Time exposing (Time)
import Music.Views.NoteView as NoteView
import Music.Views.StaffView as StaffView
import String exposing (fromInt)
import TypedSvg exposing (g, svg, text_)
import TypedSvg.Attributes as SvgAttr
    exposing
        ( fontSize
        , height
        , transform
        , width
        , x
        , y
        )
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Transform(..), px)


css =
    .toString <|
        CssModules.css "./Music/Views/css/measure.css"
            { measure = "measure"
            , staff = "staff"
            , time = "time"
            , key = "key"
            }


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
                [ SvgAttr.class [ css .time ]
                , transform [ Translate offset.px 0 ]
                ]
                [ text_
                    [ fontSize <| px (2.5 * sp.px)
                    , x <| px sp.px
                    , y <| px (2.0 * sp.px)
                    ]
                    [ text <| fromInt t.beats ]
                , text_
                    [ fontSize <| px (2.5 * sp.px)
                    , x <| px sp.px
                    , y <| px (4.0 * sp.px)
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
    svgAsset "./Music/Views/svg/tt-sharp.svg"


flatSymbol =
    svgAsset "./Music/Views/svg/tt-flat.svg"


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
    g [ transform [ Translate xpos.px ypos.px ] ] [ SvgAsset.view symbol ]


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
                [ SvgAttr.class [ css .key ]
                , transform [ Translate offset.px 0 ]
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
    div [ class <| css .measure ]
        [ svg
            [ SvgAttr.class [ css .staff ]
            , height <| inPx h
            , width <| inPx w
            ]
            [ g
                [ transform
                    [ Translate 0
                        (Layout.margins layout).top.px
                    ]
                ]
                [ StaffView.draw layout
                , viewTime layout layout.direct.time
                ]
            , viewKey layout layout.direct.key
            , g
                []
              <|
                List.map drawNote noteSequence
            ]
        ]
