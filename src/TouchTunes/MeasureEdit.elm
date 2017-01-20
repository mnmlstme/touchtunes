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
import Music.Note.Model as Note exposing (Note, heldFor)
import Music.Measure.Model as Measure exposing (Measure)
import Music.Measure.Layout as Layout exposing (Layout)
import Music.Measure.View as MeasureView
import Html exposing (Html, div, text)
import Html.Events exposing (on, onMouseUp, onMouseLeave)
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


type alias MeasureEdit =
    { cursor : Maybe Cursor
    , measure : Measure
    }


type alias Cursor =
    { beat : Beat
    }


type Action
    = InsertNote Note Beat
    | StretchNote Beat Beat
    | FinishAction


open : Measure -> MeasureEdit
open measure =
    MeasureEdit Nothing measure


update : Action -> MeasureEdit -> MeasureEdit
update action editor =
    let
        measure =
            editor.measure

        time =
            Measure.time measure

        sequence =
            Measure.toSequence measure
    in
        case action of
            InsertNote note beat ->
                let
                    newSequence =
                        Measure.addInSequence ( beat, note ) sequence
                in
                    { editor
                        | cursor = Just (Cursor beat)
                        , measure = Measure.fromSequence newSequence
                    }

            StretchNote fromBeat toBeat ->
                case (Measure.findInSequence fromBeat sequence) of
                    Nothing ->
                        editor

                    Just ( b, note ) ->
                        let
                            beats =
                                max (toBeat - b) 1

                            newDuration =
                                Duration.setBeats time beats note.duration

                            newNote =
                                Note note.pitch newDuration

                            newSequence =
                                Measure.replaceInSequence ( b, newNote ) sequence
                        in
                            { editor
                                | measure = Measure.fromSequence newSequence
                            }

            FinishAction ->
                { editor | cursor = Nothing }



-- TODO: PR to add mouseOffset to elm-lang/mouse


mouseOffset : Decoder Mouse.Position
mouseOffset =
    Decode.map2 Mouse.Position
        (field "offsetX" int)
        (field "offsetY" int)


insertAction : Layout -> Mouse.Position -> Action
insertAction layout offset =
    let
        beat =
            Layout.unscaleBeat layout (toFloat offset.x)

        pitch =
            Layout.unscalePitch layout (toFloat offset.y)
    in
        InsertNote (pitch |> heldFor quarter) beat


stretchAction : Layout -> Beat -> Mouse.Position -> Action
stretchAction layout fromBeat offset =
    let
        toBeat =
            Layout.unscaleBeat layout (toFloat offset.x)
    in
        StretchNote fromBeat toBeat


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

        vb =
            [ 0.0, 0.0, w, h ]

        actions =
            case cursor of
                Nothing ->
                    [ on "mousedown" <|
                        Decode.map
                            (insertAction lo)
                            mouseOffset
                    ]

                Just cur ->
                    [ on "mousemove" <|
                        Decode.map
                            (stretchAction lo cur.beat)
                            mouseOffset
                    , onMouseUp FinishAction
                    , onMouseLeave FinishAction
                    ]
    in
        div
            [ class "measure-editor" ]
            [ MeasureView.view editor.measure
            , Ruler.view editor.measure
            , svg
                (List.append
                    [ class "measure-hud"
                    , height (toString h)
                    , width (toString w)
                    , viewBox (String.join " " (List.map toString vb))
                    ]
                    actions
                )
                []
            ]
