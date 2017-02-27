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
import Music.Note.Model as Note
    exposing
        ( Note
        , rest
        , heldFor
        , shiftX
        )
import Music.Measure.Model as Measure
    exposing
        ( Measure
        , Sequence
        )
import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Pixels
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


-- import Debug exposing (log)


type alias MeasureEdit =
    { cursor : Maybe Cursor
    , measure : Measure
    }


type alias Cursor =
    { beat : Beat
    , dx : Pixels
    }


type Action
    = StartNote Mouse.Position
    | StretchNote Cursor Mouse.Position
    | FinishNote Cursor


open : Measure -> MeasureEdit
open measure =
    MeasureEdit Nothing measure


insertNote : Note -> Beat -> MeasureEdit -> MeasureEdit
insertNote note beat editor =
    let
        measure =
            editor.measure

        sequence =
            Measure.toSequence measure

        newSequence =
            addInSequence ( beat, note ) sequence
    in
        { editor
            | measure = Measure.fromSequence newSequence
        }


replaceNote : Note -> Beat -> MeasureEdit -> MeasureEdit
replaceNote note beat editor =
    let
        measure =
            editor.measure

        sequence =
            Measure.toSequence measure

        newSequence =
            replaceInSequence ( beat, note ) sequence
    in
        { editor
            | measure = Measure.fromSequence newSequence
        }


splitSequence : Beat -> Sequence -> ( Sequence, Sequence )
splitSequence beat =
    let
        precedes beat ( b, _ ) =
            b < beat
    in
        List.partition <| precedes beat


addInSequence : ( Beat, Note ) -> Sequence -> Sequence
addInSequence ( beat, note ) sequence =
    let
        ( before, after ) =
            splitSequence beat sequence
    in
        List.concat [ before, [ ( beat, note ) ], after ]


replaceInSequence : ( Beat, Note ) -> Sequence -> Sequence
replaceInSequence ( beat, note ) sequence =
    let
        ( before, after ) =
            splitSequence beat sequence

        rest =
            case (List.tail after) of
                Nothing ->
                    []

                Just list ->
                    list
    in
        List.concat [ before, [ ( beat, note ) ], rest ]


findInSequence : Beat -> Sequence -> Maybe ( Beat, Note )
findInSequence beat sequence =
    let
        ( before, after ) =
            splitSequence beat sequence
    in
        List.head after


capture : Beat -> Pixels -> MeasureEdit -> MeasureEdit
capture beat tenths editor =
    { editor | cursor = Just (Cursor beat tenths) }


release : MeasureEdit -> MeasureEdit
release editor =
    { editor | cursor = Nothing }


update : Action -> MeasureEdit -> MeasureEdit
update action editor =
    let
        sequence =
            Measure.toSequence editor.measure
    in
        case action of
            StartNote offset ->
                startNote offset editor

            StretchNote cursor offset ->
                let
                    beat =
                        cursor.beat
                in
                    case findInSequence beat sequence of
                        Nothing ->
                            editor

                        Just ( b, note ) ->
                            stretchNote b note cursor offset editor

            FinishNote cursor ->
                let
                    beat =
                        cursor.beat
                in
                    case findInSequence beat sequence of
                        Nothing ->
                            editor

                        Just ( b, note ) ->
                            finishNote b note editor


startNote : Mouse.Position -> MeasureEdit -> MeasureEdit
startNote offset editor =
    let
        measure =
            editor.measure

        layout =
            MeasureView.layoutFor measure

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
            Pixels <|
                x.px
                    - xb.px

        pitch =
            Layout.unscalePitch layout y

        note =
            pitch
                |> heldFor quarter
                |> shiftX (Layout.toTenths layout dx)
    in
        (capture beat dx
            << insertNote note beat
        )
            editor


stretchNote : Beat -> Note -> Cursor -> Mouse.Position -> MeasureEdit -> MeasureEdit
stretchNote b note cursor offset editor =
    let
        measure =
            editor.measure

        layout =
            MeasureView.layoutFor measure

        time =
            Measure.time measure

        toBeat =
            Layout.unscaleBeat layout <|
                Pixels <|
                    toFloat offset.x
                        - cursor.dx.px

        beats =
            toBeat - b

        dur =
            Duration.setBeats time (abs beats) note.duration
    in
        if beats > 0 then
            let
                newNote =
                    { note | duration = dur }
            in
                replaceNote newNote b editor
        else if beats < 0 then
            let
                rest =
                    Note.rest dur
                        |> shiftX (Layout.toTenths layout cursor.dx)
            in
                replaceNote rest b editor
        else
            editor


finishNote : Beat -> Note -> MeasureEdit -> MeasureEdit
finishNote b note editor =
    let
        newNote =
            Note.unshiftX note
    in
        (release << replaceNote newNote b) editor



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
                            StartNote
                            mouseOffset
                    ]

                Just cur ->
                    [ on "mousemove" <|
                        Decode.map
                            (StretchNote cur)
                            mouseOffset
                    , onMouseUp
                        (FinishNote cur)
                    , onMouseOut
                        (FinishNote cur)
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
