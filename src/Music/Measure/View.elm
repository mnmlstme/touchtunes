module Music.Measure.View exposing (view)

import Music.Time as Time
import Music.Staff as Staff
import Music.Note as Note
import Music.Measure.Model exposing (..)
import Music.Measure.Action exposing (Action)
import Music.Measure.Edit as Edit exposing (Edit)
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


view : Measure -> Html Action
view measure =
    let
        givenTime =
            Time.common

        time =
            fitTime givenTime measure

        overflowBeats =
            time.beats - givenTime.beats

        staff =
            Staff.treble

        layoutForTime =
            Layout.standard staff.basePitch

        layout =
            layoutForTime time

        w =
            Layout.width layout

        h =
            Layout.height layout

        vb =
            [ 0.0, 0.0, w, h ]

        overflowWidth =
            w - Layout.width (layoutForTime givenTime)

        drawNote =
            \( beat, note ) -> Note.draw layout beat note

        noteSequence =
            sequence time measure

        edit =
            Edit layout
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
            , Edit.view edit
            ]
