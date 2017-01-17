module Music.Measure
    exposing
        ( Measure
        , empty
        , measure
        , Action
        , update
        , view
        )

import Debug exposing (log)
import Music.Duration as Duration
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
    | StretchNote Beat Measure


update : Action -> Measure -> Measure
update action measure =
    let
        -- TODO: get the current time signature for measure
        time =
            Time.common

        oldSequence =
            sequence time measure

        justNotes seq =
            List.map (\( b, n ) -> n) seq
    in
        case action of
            InsertNote note beat measure ->
                let
                    newSequence =
                        addInSequence ( beat, note ) oldSequence
                in
                    { measure | notes = justNotes newSequence }

            StretchNote beat measure ->
                case (previousInSequence beat oldSequence) of
                    Nothing ->
                        measure

                    Just ( b, note ) ->
                        let
                            newDuration =
                                Duration.setBeats time (beat - b) note.duration

                            newNote =
                                Note note.pitch (log "newDuration" newDuration)

                            newSequence =
                                replaceInSequence ( b, newNote ) oldSequence
                        in
                            { measure | notes = justNotes newSequence }


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


replaceInSequence : ( Beat, Note ) -> List ( Beat, Note ) -> List ( Beat, Note )
replaceInSequence ( beat, note ) sequence =
    let
        ( before, after ) =
            List.partition (\( b, n ) -> b < beat) sequence

        rest =
            case (List.tail after) of
                Nothing ->
                    []

                Just list ->
                    list
    in
        List.concat [ before, [ ( beat, note ) ], rest ]


previousInSequence : Beat -> List ( Beat, Note ) -> Maybe ( Beat, Note )
previousInSequence beat sequence =
    let
        before =
            List.filter (\( b, n ) -> b < beat) sequence
    in
        List.head (List.reverse before)


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


insertAction : Layout -> Measure -> Mouse.Position -> Action
insertAction layout measure offset =
    let
        beat =
            Layout.unscaleBeat layout (toFloat offset.x)

        pitch =
            Layout.unscalePitch layout (toFloat offset.y)
    in
        InsertNote (pitch |> heldFor quarter) beat measure


stretchAction : Layout -> Measure -> Mouse.Position -> Action
stretchAction layout measure offset =
    let
        beat =
            Layout.unscaleBeat layout (toFloat offset.x)
    in
        StretchNote beat measure



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

        onMousedownInsert =
            on "mousedown" <|
                Decode.map (insertAction layout measure) mouseOffset

        onMousemoveStretch =
            on "mousemove" <|
                Decode.map (stretchAction layout measure) mouseOffset
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
                , onMousemoveStretch
                ]
                [ Staff.draw layout
                , g [ class "measure-notes" ]
                    (List.map drawNote noteSequence)
                ]
            ]
