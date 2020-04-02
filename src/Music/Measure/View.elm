module Music.Measure.View exposing
    ( view
    , viewTime
    )

import CssModules as CssModules
import Debug exposing (log)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, style)
import List.Nonempty as Nonempty
import Music.Beat as Beat
import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , inPx
        )
import Music.Measure.Model as Measure exposing (..)
import Music.Note.View as NoteView
import Music.Staff.Model as Staff
import Music.Staff.View as StaffView
import Music.Time as Time exposing (Time)
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
        CssModules.css "./Music/Measure/measure.css"
            { measure = "measure"
            , staff = "staff"
            , overflow = "overflow"
            , time = "time"
            }


viewTime : Layout -> Maybe Time -> Svg msg
viewTime layout time =
    let
        sp =
            Layout.spacing layout
    in
    case time of
        Just t ->
            g [ SvgAttr.class [ css .time ] ]
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


view : Layout -> Measure -> Html msg
view layout measure =
    let
        w =
            Layout.width layout

        fixed =
            Layout.fixedWidth layout

        h =
            Layout.height layout

        overflowWidth =
            w.px - fixed.px

        drawNote =
            \( beat, note ) ->
                NoteView.view layout beat note

        noteSequence =
            toSequence (Layout.time layout) measure
    in
    div [ class <| css .measure ]
        [ if overflowWidth > 0 then
            div
                [ class <| css .overflow
                , style "width" (String.fromFloat overflowWidth ++ "px")
                ]
                []

          else
            Html.text ""
        , svg
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
            , g
                []
              <|
                List.map drawNote noteSequence
            ]
        ]
