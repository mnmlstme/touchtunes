module Music.Measure.View
    exposing
        ( view
        , layoutFor
        , fixedLayoutFor
        )

import Music.Staff as Staff
import Music.Note.View as NoteView
import Music.Measure.Model exposing (..)
import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , heightPx
        , widthPx
        )
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Svg exposing (Svg, svg, g)
import Svg.Attributes
    exposing
        ( class
        , transform
        )


-- compute a layout for a measure


fixedLayoutFor : Measure -> Layout
fixedLayoutFor measure =
    let
        t =
            time measure

        staff =
            Staff.treble
    in
        Layout.standard staff.basePitch t


layoutFor : Measure -> Layout
layoutFor measure =
    let
        t =
            fitTime measure

        staff =
            Staff.treble
    in
        Layout.standard staff.basePitch t


view : Measure -> Html msg
view measure =
    let
        givenTime =
            time measure

        t =
            fitTime measure

        overflowBeats =
            t.beats - givenTime.beats

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

        staffPosition =
            String.join ","
                (List.map toString
                    [ 0
                    , (Layout.margins layout).top.px
                    ]
                )

        overflowWidth =
            w.px
                - ow.px
                + (Layout.margins layout).right.px

        drawNote =
            \( beat, note ) -> NoteView.view fixedLayout beat note

        noteSequence =
            toSequence measure
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
                , heightPx h
                , widthPx w
                ]
                [ g
                    [ transform
                        ("translate(" ++ staffPosition ++ ")")
                    ]
                    [ Staff.draw layout ]
                , g
                    [ class "measure-notes" ]
                  <|
                    List.map drawNote noteSequence
                ]
            ]
