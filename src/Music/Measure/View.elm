module Music.Measure.View exposing
    ( layoutFor
    , view
    )

import CssModules as CssModules
import Debug exposing (log)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, style)
import List.Extra exposing (initialize)
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
    -- this layout does not account for the notes in the measure
    let
        t =
            time measure

        staff =
            Staff.treble
    in
    Layout.standard staff t


layoutFor : Measure -> Layout
layoutFor measure =
    -- the layout accounts for the notes in the measure
    let
        t =
            fitTime measure

        staff =
            Staff.treble

        divs =
            initialize t.beatsPerMeasure (divisorFor measure)
    in
    Layout.standard staff t
        |> Layout.withDivisors divs


divisorFor : Measure -> Int -> Int
divisorFor measure i =
    Measure.startingBeats measure
        |> Nonempty.filter (\b -> b.full == i) (Beat.fullBeat 1)
        |> Nonempty.map (\b -> b.divisor)
        |> Nonempty.foldl max 1


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
                NoteView.view fixedLayout beat note

        noteSequence =
            toSequence measure
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
