module TouchTunes.Views.OverlayView exposing
    ( pointerCoordinates
    , view
    )

import Html.Events.Extra.Pointer as Pointer
import List.Extra exposing (find)
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration, quarter)
import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Location
        , Pixels
        , beatSpacing
        , durationSpacing
        , forMeasure
        , scaleBeat
        , scalePitch
        )
import Music.Models.Measure as Measure exposing (Measure, toSequence)
import Music.Models.Note as Note exposing (Note, What(..))
import Music.Views.MeasureView as MeasureView
import String exposing (fromFloat)
import Svg
    exposing
        ( Svg
        , circle
        , g
        , rect
        , svg
        , text
        )
import Svg.Attributes
    exposing
        ( class
        , height
        , transform
        , width
        , x
        , y
        )
import TouchTunes.Actions.Top as Action exposing (Msg(..))
import TouchTunes.Models.Controls exposing (Controls)
import TouchTunes.Models.Overlay exposing (Overlay, Selection(..))
import TouchTunes.Views.DialView as DialView
import TouchTunes.Views.EditorStyles exposing (css)
import Tuple exposing (pair)


pointerCoordinates : Pointer.Event -> ( Float, Float )
pointerCoordinates event =
    event.pointer.offsetPos


fromPixels : Pixels -> String
fromPixels p =
    fromFloat p.px


view : Measure -> Overlay -> Svg Msg
view measure overlay =
    let
        layout =
            overlay.layout

        t =
            Layout.time layout

        h =
            Layout.height layout |> .px

        hh =
            Layout.harmonyHeight layout |> .px

        m =
            Layout.margins layout

        sp =
            Layout.spacing layout

        seq =
            List.map (\( d, n ) -> ( Beat.fromDuration t d, n )) <|
                toSequence measure

        sameBeat ( b, _ ) =
            case overlay.selection of
                NoteSelection _ location _ ->
                    Beat.equal location.beat b

                HarmonySelection _ _ beat ->
                    Beat.equal beat b

                NoSelection ->
                    False

        duration =
            case find sameBeat seq of
                Just ( _, n ) ->
                    n.duration

                Nothing ->
                    quarter

        adjustCoordinates ( x, y ) =
            ( x + m.left.px, y + hh )

        downNoteHandler =
            Pointer.onWithOptions "pointerdown"
                { stopPropagation = True, preventDefault = True }
            <|
                pointerCoordinates
                    >> adjustCoordinates
                    >> Tuple.mapBoth floor floor
                    >> Action.NoteEdit

        downHarmonyHandler =
            Pointer.onDown <|
                pointerCoordinates
                    >> adjustCoordinates
                    >> Tuple.mapBoth floor floor
                    >> Action.HarmonyEdit

        upNoteHandler =
            Pointer.onUp (\_ -> Action.FinishEdit)

        moveNoteHandler =
            Pointer.onMove <|
                pointerCoordinates
                    >> adjustCoordinates
                    >> Tuple.mapBoth floor floor
                    >> Action.DragEdit

        activeNoteHandlers =
            case overlay.selection of
                NoteSelection _ _ dragging ->
                    if dragging then
                        [ moveNoteHandler
                        , upNoteHandler
                        ]

                    else
                        [ downNoteHandler ]

                HarmonySelection _ _ _ ->
                    [ downNoteHandler ]

                NoSelection ->
                    [ downNoteHandler ]

        activeHarmonyHandlers =
            case overlay.selection of
                NoteSelection _ _ active ->
                    [ downHarmonyHandler ]

                HarmonySelection _ _ _ ->
                    [ downHarmonyHandler ]

                NoSelection ->
                    [ downHarmonyHandler ]
    in
    svg
        [ class (css .overlay)
        , height <| fromFloat h
        , width <| fromPixels <| Layout.width layout
        ]
        (List.append
            [ rect
                (List.append
                    [ class (css .notearea)
                    , x <| fromPixels m.left
                    , y <| fromFloat hh
                    , height <| fromFloat (h - hh)
                    , width <| fromPixels <| durationSpacing layout <| Measure.length measure
                    ]
                    activeNoteHandlers
                )
                []
            , rect
                (List.append
                    [ class (css .harmonyarea)
                    , x <| fromPixels m.left
                    , y "0"
                    , height <| fromFloat hh
                    , width <| fromPixels <| durationSpacing layout <| Measure.length measure
                    ]
                    activeHarmonyHandlers
                )
                []
            ]
            (case overlay.selection of
                HarmonySelection _ _ beat ->
                    [ rect
                        [ class (css .selection)
                        , x <| fromPixels <| scaleBeat overlay.layout beat
                        , y "0"
                        , height <| fromFloat hh
                        , width <| fromPixels <| durationSpacing layout duration
                        ]
                        []
                    ]

                NoteSelection note location dragging ->
                    List.append
                        [ rect
                            [ class (css .selection)
                            , x <| fromPixels <| scaleBeat overlay.layout location.beat
                            , y <| fromFloat hh
                            , height <| fromFloat (h - hh)
                            , width <| fromPixels <| durationSpacing layout duration
                            ]
                            []
                        ]
                        (case note.do of
                            Play pitch ->
                                if dragging then
                                    [ rect
                                        [ class (css .pitchLevel)
                                        , x "0"
                                        , y <|
                                            fromFloat <|
                                                (scalePitch overlay.layout pitch).px
                                                    - 0.5
                                                    * sp.px
                                        , height <| fromPixels <| sp
                                        , width <| fromPixels <| Layout.width layout
                                        ]
                                        []
                                    ]

                                else
                                    []

                            _ ->
                                []
                        )

                NoSelection ->
                    []
            )
        )
