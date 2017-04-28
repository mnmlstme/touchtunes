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
        )
import Music.Measure.View as MeasureView exposing (layoutFor)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)


type alias MeasureEdit =
    { hud : HeadUpDisplay
    , measure : Measure
    }


open : Measure -> MeasureEdit
open measure =
    let
        layout =
            layoutFor measure
    in
        MeasureEdit
            (hud layout)
            measure


update : Gesture.Action -> MeasureEdit -> MeasureEdit
update action ed =
    let
        hud =
            HeadUpDisplay.update action ed.hud

        oldGesture =
            ed.hud.gesture

        measure =
            case hud.gesture of
                Gesture.Touch from ->
                    let
                        pitch =
                            Pitch.fromStepNumber from.step

                        modify note =
                            let
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
                    in
                        modifyNote modify from.beat ed.measure

                Gesture.Drag from to ->
                    let
                        modify note =
                            if to.beat /= from.beat then
                                let
                                    time =
                                        Measure.time ed.measure

                                    beats =
                                        to.beat - from.beat

                                    dur =
                                        Duration.fromTimeBeats time <|
                                            abs (beats + 1)

                                    newNote =
                                        if beats < 0 then
                                            { note | do = Note.Rest }
                                        else
                                            note
                                in
                                    if Duration.longerThan dur note.duration then
                                        { newNote | duration = dur }
                                    else
                                        note
                            else
                                let
                                    pitch =
                                        Pitch.fromStepNumber to.step
                                in
                                    { note | do = Note.Play pitch }
                    in
                        modifyNote modify from.beat ed.measure

                Gesture.Reversal from to back ->
                    let
                        modify note =
                            if back.beat /= to.beat then
                                let
                                    time =
                                        Measure.time ed.measure

                                    beats =
                                        back.beat - from.beat

                                    dur =
                                        Duration.fromTimeBeats time <|
                                            abs (beats + 1)

                                    newNote =
                                        if beats < 0 then
                                            { note | do = Note.Rest }
                                        else
                                            note
                                in
                                    { newNote | duration = dur }
                            else
                                note
                    in
                        modifyNote modify from.beat ed.measure

                Gesture.Idle ->
                    let
                        modify =
                            identity
                    in
                        case oldGesture of
                            Gesture.Idle ->
                                ed.measure

                            Gesture.Touch from ->
                                modifyNote modify from.beat ed.measure

                            Gesture.Drag from _ ->
                                modifyNote modify from.beat ed.measure

                            Gesture.Reversal from _ _ ->
                                modifyNote modify from.beat ed.measure
    in
        { hud = hud
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
