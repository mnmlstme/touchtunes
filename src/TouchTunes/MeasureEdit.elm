module TouchTunes.MeasureEdit
    exposing
        ( MeasureEdit
        , open
        , view
        , update
        )

import TouchTunes.Ruler as Ruler
import TouchTunes.Gesture as Gesture exposing (Gesture)
import Music.Duration as Duration exposing (quarter)
import Music.Time as Time exposing (Beat)
import Music.Pitch as Pitch
import Music.Note.Model as Note
    exposing
        ( Note
        , playFor
        , shiftX
        )
import Music.Measure.Model as Measure
    exposing
        ( Measure
        , modifyNote
        )
import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , Tenths
        , Location
        , heightPx
        , widthPx
        )
import Music.Measure.View as MeasureView
import Html exposing (Html, div, text)
import Html.Events
    exposing
        ( on
        , onMouseUp
        , onMouseOut
        )
import Json.Decode as Decode exposing (Decoder, field, int)
import Mouse
import Svg exposing (Svg, svg, g)
import Svg.Attributes exposing (class)


type alias MeasureEdit =
    { gesture : Gesture
    , measure : Measure
    }


open : Measure -> MeasureEdit
open measure =
    MeasureEdit Gesture.Idle measure


update : Gesture.Action -> MeasureEdit -> MeasureEdit
update action ed =
    let
        gesture =
            Gesture.update action ed.gesture

        measure =
            case gesture of
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
                                shiftX from.shiftx <|
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
                                    -- TODO: get time from measure
                                    time =
                                        Time.common

                                    beats =
                                        to.beat - from.beat

                                    dur =
                                        Duration.fromTimeBeats time (abs beats)

                                    newNote =
                                        if beats < 0 then
                                            { note | do = Note.Rest }
                                        else
                                            note
                                in
                                    { newNote | duration = dur }
                            else
                                let
                                    pitch =
                                        Pitch.fromStepNumber to.step
                                in
                                    { note | do = Note.Play pitch }
                    in
                        modifyNote modify from.beat ed.measure

                Gesture.Idle ->
                    let
                        modify =
                            Note.unshiftX
                    in
                        case ed.gesture of
                            Gesture.Idle ->
                                ed.measure

                            Gesture.Touch from ->
                                modifyNote modify from.beat ed.measure

                            Gesture.Drag from _ ->
                                modifyNote modify from.beat ed.measure
    in
        { gesture = gesture
        , measure = measure
        }


mouseOffset : Decoder Mouse.Position
mouseOffset =
    -- TODO: submit PR to elm-lang/mouse to add mouseOffset
    Decode.map2 Mouse.Position
        (field "offsetX" int)
        (field "offsetY" int)


view : MeasureEdit -> Html Gesture.Action
view editor =
    let
        measure =
            editor.measure

        lo =
            MeasureView.layoutFor measure

        gesture =
            editor.gesture

        w =
            Layout.width lo

        h =
            Layout.height lo

        toLocation =
            Layout.positionToLocation lo

        down =
            on "mousedown" <|
                Decode.map Gesture.StartGesture <|
                    Decode.map toLocation mouseOffset

        move from =
            on "mousemove" <|
                Decode.map Gesture.ContinueGesture <|
                    Decode.map toLocation mouseOffset

        up from =
            onMouseUp Gesture.FinishGesture

        out from =
            onMouseOut Gesture.FinishGesture

        actions =
            case gesture of
                Gesture.Idle ->
                    [ down ]

                Gesture.Touch from ->
                    [ move from
                    , up from
                    ]

                Gesture.Drag from to ->
                    [ move from
                    , up from
                    , out from
                    ]
    in
        div
            [ class "measure-editor" ]
            [ MeasureView.view editor.measure
            , Ruler.view editor.measure
            , svg
                (List.append
                    [ class "measure-hud"
                    , heightPx h
                    , widthPx w
                    ]
                    actions
                )
                []
            ]
