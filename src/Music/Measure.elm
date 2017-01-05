module Music.Measure
    exposing
        ( Measure
        , measure
        , view
        )

import Music.Time as Time exposing (Time, Beat)
import Music.Note as Note exposing (Note)
import Music.Staff as Staff
import Music.Layout as Layout exposing (Layout)
import Html exposing (Html, div)
import Html.Attributes
import Svg exposing (Svg, svg, g)
import Svg.Attributes
    exposing
        ( class
        , height
        , width
        , viewBox
        )


type alias Measure =
    { notes : List Note
    }


measure : List Note -> Measure
measure =
    Measure


sequence : Time -> Measure -> List ( Beat, Note )
sequence time measure =
    let
        beats =
            List.map (Note.beats time) measure.notes

        startsAt =
            List.scanl (+) 0 beats
    in
        List.map2 (,) startsAt measure.notes


view : Measure -> Html msg
view measure =
    let
        time =
            Time.common

        staff =
            Staff.treble

        layout =
            Layout.standard staff.basePitch time

        vb =
            [ 0.0, 0.0, layout.w, layout.h ]

        drawNote =
            \( beat, note ) -> Note.draw layout beat note

        noteSequence =
            sequence time measure
    in
        div [ Html.Attributes.class "measure" ]
            [ svg
                [ class "measure-staff"
                , height (toString layout.h)
                , width (toString layout.w)
                , viewBox (String.join " " (List.map toString vb))
                ]
                [ Staff.draw layout
                , g [ class "measure-notes" ]
                    (List.map drawNote noteSequence)
                ]
            ]
