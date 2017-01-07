module Music.Measure
    exposing
        ( Measure
        , empty
        , measure
        , Action
        , update
        , view
        )

import Debug
import Music.Time as Time exposing (Time, Beat)
import Music.Pitch as Pitch
import Music.Note as Note exposing (Note, heldFor)
import Music.Staff as Staff
import Music.Layout as Layout exposing (Layout)
import Html exposing (Html, div)
import Html.Attributes
import Html.Events exposing (on)
import Json.Decode as Decode
import Mouse
import Svg exposing (Svg, svg, g)
import Svg.Attributes
    exposing
        ( class
        , height
        , width
        , viewBox
        )
import Music.Pitch exposing (f)
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
            -- TODO: use beat to find insertion point
            { measure | notes = List.append measure.notes [ note ] }


sequence : Time -> Measure -> List ( Beat, Note )
sequence time measure =
    let
        beats =
            List.map (Note.beats time) measure.notes

        startsAt =
            List.scanl (+) 0 beats
    in
        List.map2 (,) startsAt measure.notes


insertNote : Layout -> Measure -> Mouse.Position -> Action
insertNote layout measure pt =
    let
        beat =
            (Debug.log "x" pt.x) % 4

        stepn =
            (Debug.log "y" pt.y) % 7 + 28

        pitch =
            Pitch.fromStepNumber stepn
    in
        InsertNote (pitch |> heldFor quarter) beat measure


view : Measure -> Html Action
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

        onClick =
            on "click" <|
                Decode.map (insertNote layout measure) <|
                    Mouse.position
    in
        div [ Html.Attributes.class "measure" ]
            [ svg
                [ class "measure-staff"
                , height (toString layout.h)
                , width (toString layout.w)
                , viewBox (String.join " " (List.map toString vb))
                  -- , on "click" (handleClick layout measure)
                , onClick
                ]
                [ Staff.draw layout
                , g [ class "measure-notes" ]
                    (List.map drawNote noteSequence)
                ]
            ]
