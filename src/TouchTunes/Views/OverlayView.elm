module TouchTunes.Views.OverlayView exposing
    ( pointerCoordinates
    , underlay
    , view
    )

import CssModules as CssModules
import Html exposing (text)
import Html.Events.Extra.Pointer as Pointer
import List.Extra exposing (find)
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration, quarter)
import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Location
        , beatSpacing
        , durationSpacing
        , forMeasure
        , inPx
        , scaleBeat
        )
import Music.Models.Measure as Measure exposing (Measure, toSequence)
import Music.Views.MeasureView as MeasureView
import TouchTunes.Actions.Top as Action exposing (Msg(..))
import TouchTunes.Models.Overlay exposing (Overlay)
import Tuple exposing (pair)
import TypedSvg
    exposing
        ( circle
        , g
        , rect
        , svg
        )
import TypedSvg.Attributes
    exposing
        ( class
        , height
        , transform
        , width
        , x
        , y
        )
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Transform(..), px)


pointerCoordinates : Pointer.Event -> ( Float, Float )
pointerCoordinates event =
    event.pointer.offsetPos


css =
    .toString <|
        CssModules.css "./TouchTunes/Views/css/editor.css"
            { overlay = "overlay"
            , underlay = "underlay"
            , selection = "selection"
            , area = "area"
            }


view : Measure -> Overlay -> Svg Msg
view measure overlay =
    let
        layout =
            overlay.layout

        t =
            Layout.time layout

        m =
            Layout.margins layout

        seq =
            List.map (\( d, n ) -> ( Beat.fromDuration t d, n )) <|
                toSequence measure

        sameBeat ( b, _ ) =
            case overlay.selection of
                Just selection ->
                    Beat.equal selection.location.beat b

                Nothing ->
                    False

        duration =
            case find sameBeat seq of
                Just ( _, n ) ->
                    n.duration

                Nothing ->
                    quarter

        adjustCoordinates ( x, y ) =
            ( x + m.left.px, y )

        downHandler =
            Pointer.onWithOptions "pointerdown"
                { stopPropagation = True, preventDefault = True }
            <|
                pointerCoordinates
                    >> adjustCoordinates
                    >> Tuple.mapBoth floor floor
                    >> Action.NoteEdit

        upHandler =
            Pointer.onUp (\_ -> Action.CommitEdit)

        cancelHandler =
            Pointer.onCancel (\_ -> Action.CancelEdit)

        leaveHandler =
            Pointer.onLeave (\_ -> Action.CancelEdit)

        outHandler =
            Pointer.onOut (\_ -> Action.CancelEdit)

        moveHandler =
            Pointer.onMove <|
                pointerCoordinates
                    >> adjustCoordinates
                    >> Tuple.mapBoth floor floor
                    >> Action.DragEdit

        activeHandlers =
            case overlay.selection of
                Just selection ->
                    if selection.dragging then
                        [ moveHandler
                        , upHandler
                        , cancelHandler
                        , leaveHandler
                        , outHandler
                        ]

                    else
                        []

                Nothing ->
                    []
    in
    svg
        [ class [ css .overlay ]
        , height <| inPx <| Layout.height layout
        , width <| inPx <| Layout.width layout
        ]
        [ rect
            (List.append
                [ class [ css .area ]
                , x <| inPx <| m.left
                , y <| px 0
                , height <| inPx <| Layout.height layout
                , width <| inPx <| durationSpacing layout <| Measure.length measure
                , downHandler
                ]
                activeHandlers
            )
            []
        , case overlay.selection of
            Just selection ->
                rect
                    [ class [ css .selection ]
                    , x <| inPx <| scaleBeat overlay.layout selection.location.beat
                    , y <| px 0
                    , height <| inPx <| Layout.height layout
                    , width <| inPx <| durationSpacing layout duration
                    ]
                    []

            Nothing ->
                text ""
        ]


underlay : Layout -> Svg msg
underlay layout =
    svg
        [ class [ css .underlay ]
        , height <| inPx <| Layout.height layout
        , width <| inPx <| Layout.width layout
        ]
        []
