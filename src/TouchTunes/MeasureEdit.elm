module TouchTunes.MeasureEdit
    exposing
        ( MeasureEdit
        , open
        , view
        , Action
        , update
        )

-- import Debug exposing (log)

import TouchTunes.Ruler as Ruler
import Music.Duration as Duration exposing (quarter)
import Music.Time as Time exposing (Beat)
import Music.Note.Model as Note exposing (Note, heldFor, shiftX)
import Music.Measure.Model as Measure exposing (Measure)
import Music.Measure.Layout as Layout exposing (Layout, Pixels, heightPx, widthPx)
import Music.Measure.View as MeasureView
import Html exposing (Html, div, text)
import Html.Events exposing (on, onMouseUp, onMouseLeave)
import Json.Decode as Decode exposing (Decoder, field, int)
import Mouse
import Svg exposing (Svg, svg, g)
import Svg.Attributes exposing (class)


type alias MeasureEdit =
    { cursor : Maybe Cursor
    , measure : Measure
    }


type alias Cursor =
    { beat : Beat
    }


type Action
    = InsertNote Mouse.Position
    | StretchNote Beat Mouse.Position
    | FinishNote Beat


open : Measure -> MeasureEdit
open measure =
    MeasureEdit Nothing measure


update : Action -> MeasureEdit -> MeasureEdit
update action editor =
    let
        measure =
            editor.measure

        layout =
            MeasureView.layoutFor measure

        time =
            Measure.time measure

        sequence =
            Measure.toSequence measure
    in
        case action of
            InsertNote offset ->
                let
                    x =
                        Pixels <| toFloat offset.x

                    y =
                        Pixels <| toFloat offset.y

                    clickBeat =
                        Layout.unscaleBeat layout x

                    beat =
                        Measure.nextBeat clickBeat measure

                    xb =
                        Layout.scaleBeat layout beat

                    dx =
                        Pixels <| x.px - xb.px

                    pitch =
                        Layout.unscalePitch layout y

                    note =
                        pitch
                            |> heldFor quarter
                            |> shiftX (Layout.toTenths layout dx)

                    newSequence =
                        Measure.addInSequence ( beat, note ) sequence
                in
                    { editor
                        | cursor = Just (Cursor beat)
                        , measure = Measure.fromSequence newSequence
                    }

            StretchNote fromBeat offset ->
                case (Measure.findInSequence fromBeat sequence) of
                    Nothing ->
                        editor

                    Just ( b, note ) ->
                        let
                            toBeat =
                                Layout.unscaleBeat layout (toFloat offset.x |> Pixels)

                            beats =
                                max (toBeat - b) 1

                            newDuration =
                                Duration.setBeats time beats note.duration

                            newNote =
                                { note | duration = newDuration }

                            newSequence =
                                Measure.replaceInSequence ( b, newNote ) sequence
                        in
                            { editor
                                | measure = Measure.fromSequence newSequence
                            }

            FinishNote beat ->
                case (Measure.findInSequence beat sequence) of
                    Nothing ->
                        editor

                    Just ( b, note ) ->
                        let
                            newNote =
                                Note.unshiftX note

                            newSequence =
                                Measure.replaceInSequence ( b, newNote ) sequence
                        in
                            { editor
                                | measure = Measure.fromSequence newSequence
                                , cursor = Nothing
                            }



-- TODO: PR to add mouseOffset to elm-lang/mouse


mouseOffset : Decoder Mouse.Position
mouseOffset =
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

        cursor =
            editor.cursor

        w =
            Layout.width lo

        h =
            Layout.height lo

        actions =
            case cursor of
                Nothing ->
                    [ on "mousedown" <|
                        Decode.map
                            InsertNote
                            mouseOffset
                    ]

                Just cur ->
                    [ on "mousemove" <|
                        Decode.map
                            (StretchNote cur.beat)
                            mouseOffset
                    , onMouseUp
                        (FinishNote cur.beat)
                    , onMouseLeave
                        (FinishNote cur.beat)
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
