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
        , playFor
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
        , Tenths
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
    { cursor : Maybe Cursor
    , measure : Measure
    }


type alias Cursor =
    { beat : Beat
    , dx : Pixels
    , x : Pixels
    , y : Pixels
    }


type Action
    = StartNote Mouse.Position
    | DragNote Cursor Mouse.Position
    | FinishNote Cursor


open : Measure -> MeasureEdit
open measure =
    MeasureEdit Nothing measure


splitSequence : Beat -> Sequence -> ( Sequence, Sequence )
splitSequence beat =
    let
        precedes beat ( b, _ ) =
            b < beat
    in
        List.partition <| precedes beat


insertNote : Note -> Beat -> MeasureEdit -> MeasureEdit
insertNote note beat editor =
    let
        measure =
            editor.measure

        sequence =
            Measure.toSequence measure

        ( before, after ) =
            splitSequence beat sequence

        newSequence =
            List.concat [ before, [ ( beat, note ) ], after ]
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

        ( before, after ) =
            splitSequence beat sequence

        rest =
            case List.tail after of
                Nothing ->
                    [ ( beat, note ) ]

                Just rest ->
                    ( beat, note ) :: rest

        newSequence =
            List.concat [ before, rest ]
    in
        { editor
            | measure = Measure.fromSequence newSequence
        }


findInSequence : Beat -> Sequence -> Maybe ( Beat, Note )
findInSequence beat sequence =
    let
        ( before, after ) =
            splitSequence beat sequence
    in
        List.head after


capture : Beat -> Pixels -> Mouse.Position -> MeasureEdit -> MeasureEdit
capture beat dx position editor =
    let
        posx =
            Pixels (toFloat position.x)

        posy =
            Pixels (toFloat position.y)
    in
        { editor
            | cursor = Just (Cursor beat dx posx posy)
        }


release : MeasureEdit -> MeasureEdit
release editor =
    { editor | cursor = Nothing }


update : Action -> MeasureEdit -> MeasureEdit
update action editor =
    case action of
        StartNote offset ->
            startNote offset editor

        DragNote cursor offset ->
            let
                dx =
                    toFloat (offset.x) - cursor.x.px

                dy =
                    toFloat (offset.y) - cursor.y.px
            in
                if (abs dx) > (abs dy) then
                    stretchNote cursor offset editor
                else
                    bendNote cursor offset editor

        FinishNote cursor ->
            finishNote cursor editor


startNote : Mouse.Position -> MeasureEdit -> MeasureEdit
startNote offset editor =
    let
        measure =
            editor.measure

        sequence =
            Measure.toSequence measure

        layout =
            MeasureView.layoutFor measure

        x =
            Pixels <| toFloat offset.x

        y =
            Pixels <| toFloat offset.y

        clickBeat =
            Layout.unscaleBeat layout x

        ( before, after ) =
            splitSequence clickBeat sequence

        beat =
            case List.head after of
                Nothing ->
                    Measure.notesLength measure

                Just ( b, _ ) ->
                    b

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
                |> playFor quarter
                |> shiftX (Layout.toTenths layout dx)
    in
        (capture beat dx offset
            << insertNote note beat
        )
            editor


bendNote : Cursor -> Mouse.Position -> MeasureEdit -> MeasureEdit
bendNote cursor offset editor =
    let
        measure =
            editor.measure

        sequence =
            Measure.toSequence measure

        layout =
            MeasureView.layoutFor measure

        beat =
            cursor.beat

        p =
            Layout.unscalePitch layout <|
                Pixels <|
                    toFloat offset.y
    in
        case findInSequence beat sequence of
            Nothing ->
                editor

            Just ( b, note ) ->
                let
                    newNote =
                        { note | do = Note.Play p }
                in
                    replaceNote newNote b editor


stretchNote : Cursor -> Mouse.Position -> MeasureEdit -> MeasureEdit
stretchNote cursor offset editor =
    let
        measure =
            editor.measure

        sequence =
            Measure.toSequence measure

        layout =
            MeasureView.layoutFor measure

        time =
            Measure.time measure

        beat =
            cursor.beat

        toBeat =
            Layout.unscaleBeat layout <|
                Pixels <|
                    toFloat offset.x
                        - cursor.dx.px

        beats =
            toBeat - beat

        dur =
            Duration.fromTimeBeats time (abs beats)
    in
        case findInSequence beat sequence of
            Nothing ->
                editor

            Just ( b, note ) ->
                if beats > 0 then
                    let
                        newNote =
                            { note | duration = dur }
                    in
                        replaceNote newNote b editor
                else if beats < 0 then
                    let
                        rest =
                            { note | do = Note.Rest }
                    in
                        replaceNote rest b editor
                else
                    editor


finishNote : Cursor -> MeasureEdit -> MeasureEdit
finishNote cursor editor =
    let
        beat =
            cursor.beat

        sequence =
            Measure.toSequence editor.measure
    in
        case findInSequence beat sequence of
            Nothing ->
                editor

            Just ( b, note ) ->
                let
                    newNote =
                        Note.unshiftX note
                in
                    (release << replaceNote newNote b) editor


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
                            (DragNote cur)
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
