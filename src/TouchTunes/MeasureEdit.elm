module TouchTunes.MeasureEdit
    exposing
        ( MeasureEdit
        , open
        , view
        , Action
        , update
        )

import TouchTunes.Ruler as Ruler
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


type Gesture
    = Idle
    | Touch Location
    | Drag Location Location


type Action
    = StartGesture Location
    | ContinueGesture Location
    | FinishGesture


open : Measure -> MeasureEdit
open measure =
    MeasureEdit Idle measure


update : Action -> MeasureEdit -> MeasureEdit
update action ed =
    case action of
        StartGesture from ->
            { ed
                | gesture = Touch from
                , measure =
                    let
                        pitch =
                            Pitch.fromStepNumber from.step

                        modify note =
                            shiftX from.shiftx <|
                                { note
                                    | do =
                                        case note.do of
                                            Note.Play _ ->
                                                Note.Play pitch

                                            _ ->
                                                note.do
                                }
                    in
                        modifyNote modify from.beat ed.measure
            }

        ContinueGesture to ->
            { ed
                | gesture =
                    case ed.gesture of
                        Idle ->
                            ed.gesture

                        Touch from ->
                            Drag from to

                        Drag from _ ->
                            Drag from to
                , measure =
                    let
                        from =
                            case ed.gesture of
                                Idle ->
                                    to

                                Touch from ->
                                    from

                                Drag from _ ->
                                    from

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
                                    if Duration.longerThan dur note.duration then
                                        { newNote | duration = dur }
                                    else
                                        newNote
                            else
                                let
                                    pitch =
                                        Pitch.fromStepNumber to.step
                                in
                                    { note | do = Note.Play pitch }
                    in
                        case ed.gesture of
                            Idle ->
                                ed.measure

                            Touch from ->
                                modifyNote modify from.beat ed.measure

                            Drag from _ ->
                                modifyNote modify from.beat ed.measure
            }

        FinishGesture ->
            { ed
                | gesture = Idle
                , measure =
                    let
                        modify =
                            Note.unshiftX
                    in
                        case ed.gesture of
                            Idle ->
                                ed.measure

                            Touch from ->
                                modifyNote modify from.beat ed.measure

                            Drag from _ ->
                                modifyNote modify from.beat ed.measure
            }


mouseOffset : Decoder Mouse.Position
mouseOffset =
    -- TODO: submit PR to elm-lang/mouse to add mouseOffset
    Decode.map2 Mouse.Position
        (field "offsetX" int)
        (field "offsetY" int)


view : MeasureEdit -> Html Action
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
                Decode.map StartGesture <|
                    Decode.map toLocation mouseOffset

        move from =
            on "mousemove" <|
                Decode.map ContinueGesture <|
                    Decode.map toLocation mouseOffset

        up from =
            onMouseUp FinishGesture

        out from =
            onMouseOut FinishGesture

        actions =
            case gesture of
                Idle ->
                    [ down ]

                Touch from ->
                    [ move from
                    , up from
                    ]

                Drag from to ->
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
