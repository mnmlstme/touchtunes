module Music.Measure.View exposing
    ( layoutFor
    , view
    )

import CssModules as CssModules
import Debug exposing (log)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, style)
import Music.Beat as Beat
import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , inPx
        )
import Music.Measure.Model exposing (..)
import Music.Note.View as NoteView
import Music.Staff.Model as Staff
import Music.Staff.View as StaffView
import String
import TypedSvg exposing (g, svg)
import TypedSvg.Attributes as SvgAttr
    exposing
        ( height
        , transform
        , width
        )
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Transform(..))



-- compute a layout for a measure


fixedLayoutFor : Measure -> Layout
fixedLayoutFor measure =
    let
        t =
            time measure

        staff =
            Staff.treble
    in
    Layout.standard staff t


layoutFor : Measure -> Layout
layoutFor measure =
    let
        t =
            fitTime measure

        staff =
            Staff.treble
    in
    Layout.standard staff t


view : Measure -> Html msg
view measure =
    let
        css =
            .toString <|
                CssModules.css "./Music/Measure/measure.css"
                    { measure = "measure"
                    , staff = "staff"
                    , overflow = "overflow"
                    }

        givenTime =
            time measure

        t =
            fitTime measure

        overflowBeats =
            t.beatsPerMeasure - givenTime.beatsPerMeasure

        layout =
            layoutFor measure

        fixedLayout =
            fixedLayoutFor measure

        w =
            Layout.width layout

        ow =
            Layout.width fixedLayout

        h =
            Layout.height layout

        overflowWidth =
            w.px
                - ow.px
                + (Layout.margins layout).right.px

        drawNote =
            \( beat, note ) ->
                NoteView.view fixedLayout (Beat.toFloat beat) note

        noteSequence =
            log "measure sequence" <| toSequence measure
    in
    div [ class <| css .measure ]
        [ if overflowBeats > 0 then
            div
                [ class <| css .overflow
                , style "width" (String.fromFloat overflowWidth ++ "px")
                ]
                []

          else
            text ""
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
                [ StaffView.draw layout ]
            , g
                []
              <|
                List.map drawNote noteSequence
            ]
        ]
