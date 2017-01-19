module Music.Measure.View
    exposing
        ( view
        , layoutFor
        , fixedLayoutFor
        )

import Music.Time as Time exposing (Beat)
import Music.Staff as Staff
import Music.Note.View as NoteView
import Music.Measure.Model exposing (..)
import Music.Measure.Layout as Layout exposing (Layout)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Svg exposing (Svg, svg, g)
import Svg.Attributes
    exposing
        ( class
        , height
        , width
        , viewBox
        )


-- compute a layout for a measure


fixedLayoutFor : Measure -> Layout
fixedLayoutFor measure =
    let
        time =
            Time.common

        staff =
            Staff.treble
    in
        Layout.standard staff.basePitch time


layoutFor : Measure -> Layout
layoutFor measure =
    let
        givenTime =
            Time.common

        time =
            fitTime givenTime measure

        staff =
            Staff.treble
    in
        Layout.standard staff.basePitch time


view : Measure -> Html msg
view measure =
    let
        givenTime =
            Time.common

        time =
            fitTime givenTime measure

        overflowBeats =
            time.beats - givenTime.beats

        layout =
            layoutFor measure

        w =
            Layout.width layout

        h =
            Layout.height layout

        vb =
            [ 0.0, 0.0, w, h ]

        overflowWidth =
            w - Layout.width (fixedLayoutFor measure)

        drawNote =
            \( beat, note ) -> NoteView.view layout beat note

        noteSequence =
            toSequence time measure
    in
        div [ Html.Attributes.class "measure" ]
            [ if overflowBeats > 0 then
                div
                    [ class "measure-overflow"
                    , style
                        [ ( "width", toString overflowWidth ++ "px" ) ]
                    ]
                    []
              else
                text ""
            , svg
                [ class "measure-staff"
                , height (toString h)
                , width (toString w)
                , viewBox (String.join " " (List.map toString vb))
                ]
                [ Staff.draw layout
                , g [ class "measure-notes" ]
                    (List.map drawNote noteSequence)
                ]
            ]
