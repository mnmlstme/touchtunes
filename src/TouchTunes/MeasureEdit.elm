module TouchTunes.MeasureEdit
    exposing
        ( MeasureEdit
        , open
        , view
        , update
        )

import TouchTunes.Ruler as Ruler
import TouchTunes.Gesture as Gesture exposing (Gesture)
import TouchTunes.HeadUpDisplay as HeadUpDisplay exposing (HeadUpDisplay, hud)
import Music.Duration as Duration exposing (quarter)
import Music.Pitch as Pitch
import Music.Note.Model as Note
    exposing
        ( Note
        , playFor
        )
import Music.Measure.Model as Measure
    exposing
        ( Measure
        , modifyNote
        , aggregateRests
        )
import Music.Measure.View as MeasureView exposing (layoutFor)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Debug exposing (log)


type alias MeasureEdit =
    { hud : HeadUpDisplay
    , measure : Measure
    }


open : Measure -> MeasureEdit
open measure =
    MeasureEdit (hud measure) measure


update : Gesture.Action -> MeasureEdit -> MeasureEdit
update action ed =
    let
        hud =
            HeadUpDisplay.update action ed.hud

        oldGesture =
            ed.hud.gesture

        touchNote at note =
            let
                pitch =
                    Pitch.fromStepNumber at.step

                dur =
                    case note.do of
                        Note.Rest ->
                            Duration.quarter

                        _ ->
                            note.duration
            in
                { note
                    | do = Note.Play pitch
                    , duration = dur
                }

        dragNote to from note =
            let
                time =
                    Measure.time ed.measure

                dbeats =
                    to.beat - from.beat

                dx =
                    if dbeats == 0 then
                        to.shiftx.ths - from.shiftx.ths
                    else
                        0

                threshold =
                    5
            in
                if dbeats > 0 || dx > threshold then
                    let
                        dur =
                            Duration.fromTimeBeats time (1 + dbeats)
                    in
                        { note | duration = dur }
                else if dbeats < 0 || dx < -threshold then
                    let
                        dur =
                            Duration.fromTimeBeats time (1 - dbeats)
                    in
                        { note
                            | do = Note.Rest
                            , duration = dur
                        }
                else if to.step /= from.step then
                    let
                        pitch =
                            Pitch.fromStepNumber to.step
                    in
                        { note | do = Note.Play pitch }
                else
                    note

        measure =
            case hud.gesture of
                Gesture.Touch at ->
                    let
                        modify =
                            touchNote at
                    in
                        modifyNote modify at.beat ed.measure

                Gesture.Drag from to ->
                    let
                        earliestBeat =
                            min from.beat to.beat

                        modify =
                            dragNote to from
                    in
                        modifyNote modify earliestBeat ed.measure

                Gesture.Reversal from to back ->
                    let
                        modify =
                            dragNote back from
                    in
                        modifyNote modify from.beat ed.measure

                Gesture.Idle ->
                    aggregateRests ed.measure
    in
        { hud = { hud | measure = measure }
        , measure = measure
        }


view : MeasureEdit -> Html Gesture.Action
view editor =
    div
        [ class "measure-editor" ]
        [ MeasureView.view editor.measure
        , Ruler.view editor.measure
        , HeadUpDisplay.view editor.hud
        ]
