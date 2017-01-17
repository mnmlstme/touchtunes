module Music.Measure
    exposing
        ( Measure
        , empty
        , measure
        , Action
        , update
        , view
        )

-- import Debug exposing (log)

import Music.Time as Time exposing (Time, Beat)
import Music.Note as Note exposing (Note, heldFor)
import Music.Staff as Staff
import Music.Layout as Layout exposing (Layout)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (Decoder, field, int)
import Mouse
import Svg exposing (Svg, svg, g)
import Svg.Attributes
    exposing
        ( class
        , height
        , width
        , viewBox
        )
import Music.Duration exposing (quarter)


type alias Measure =
    { notes : List Note
    }


empty : Measure
empty =
    Measure []


measure : List Note -> Measure
measure =
    Measure


type Action
    = InsertNote Note Beat Measure


update : Action -> Measure -> Measure
update action measure =
    case action of
        InsertNote note beat measure ->
            let
                time =
                    Time.common

                newSequence =
                    addInSequence
                        ( beat, note )
                        (sequence time measure)
            in
                { measure
                    | notes = List.map (\( b, n ) -> n) newSequence
                }


sequence : Time -> Measure -> List ( Beat, Note )
sequence time measure =
    let
        beats =
            List.map (Note.beats time) measure.notes

        startsAt =
            List.scanl (+) 0 beats
    in
        List.map2 (,) startsAt measure.notes


addInSequence : ( Beat, Note ) -> List ( Beat, Note ) -> List ( Beat, Note )
addInSequence ( beat, note ) sequence =
    let
        ( before, after ) =
            List.partition (\( b, n ) -> b < beat) sequence
    in
        List.concat [ before, [ ( beat, note ) ], after ]


totalBeats : Time -> Measure -> Beat
totalBeats time measure =
    let
        beats =
            List.map (Note.beats time) measure.notes
    in
        List.sum beats



-- TODO: PR to add mouseOffset to elm-lang/mouse


mouseOffset : Decoder Mouse.Position
mouseOffset =
    Decode.map2 Mouse.Position
        (field "offsetX" int)
        (field "offsetY" int)


insertOffset : Layout -> Measure -> Mouse.Position -> Action
insertOffset layout measure offset =
    let
        beat =
            Layout.unscaleBeat layout (toFloat offset.x)

        pitch =
            Layout.unscalePitch layout (toFloat offset.y)
    in
        InsertNote (pitch |> heldFor quarter) beat measure



-- compute a new time signature that notes will fit in


fitTime : Time -> Measure -> Time
fitTime time measure =
    let
        beats =
            totalBeats time measure
    in
        Time.longer time beats


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

        insertAt =
            insertOffset layout measure

        onMousedownInsert =
            on "mousedown" <|
                Decode.map insertAt mouseOffset
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
                , onMousedownInsert
                ]
                [ Staff.draw layout
                , g [ class "measure-notes" ]
                    (List.map drawNote noteSequence)
                ]
            ]
