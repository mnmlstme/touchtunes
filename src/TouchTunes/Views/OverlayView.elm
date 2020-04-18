module TouchTunes.Views.OverlayView exposing
    ( pointerCoordinates
    , view
    )

import Json.Decode as Json
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
import Svg.Styled
    exposing
        ( Svg
        , circle
        , g
        , rect
        , svg
        , text
        )
import Svg.Styled.Attributes
    exposing
        ( css
        , height
        , transform
        , width
        , x
        , y
        )
import Svg.Styled.Events as Events
import TouchTunes.Actions.Top as Action exposing (Msg(..))
import TouchTunes.Models.Overlay exposing (Overlay)
import TouchTunes.Views.EditorStyles as Styles
import Tuple exposing (pair)


pointerCoordinates : (( Float, Float ) -> msg) -> Json.Decoder msg
pointerCoordinates toMsg =
    Json.map2
        (\x y -> toMsg ( x, y ))
        (Json.field "offsetX" Json.float)
        (Json.field "offsetY" Json.float)


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

        m =
            Layout.margins layout

        sp =
            Layout.spacing layout

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
            Events.on "mousedown" <|
                pointerCoordinates
                    (adjustCoordinates >> Tuple.mapBoth floor floor >> Action.NoteEdit)

        upHandler =
            Events.onMouseUp Action.CommitEdit

        outHandler =
            Events.onMouseOut Action.CancelEdit

        moveHandler =
            Events.on "mousemove" <|
                pointerCoordinates
                    (adjustCoordinates >> Tuple.mapBoth floor floor >> Action.DragEdit)

        activeHandlers =
            case overlay.selection of
                Just selection ->
                    if selection.dragging then
                        [ moveHandler
                        , upHandler
                        , outHandler
                        ]

                    else
                        []

                Nothing ->
                    []
    in
    svg
        [ css [ Styles.overlay ]
        , height <| fromPixels <| Layout.height layout
        , width <| fromPixels <| Layout.width layout
        ]
        (List.append
            [ rect
                (List.append
                    [ css [ Styles.area ]
                    , x <| fromPixels <| m.left
                    , y "0"
                    , height <| fromPixels <| Layout.height layout
                    , width <| fromPixels <| durationSpacing layout <| Measure.length measure
                    , downHandler
                    ]
                    activeHandlers
                )
                []
            ]
            (case overlay.selection of
                Just selection ->
                    List.append
                        [ rect
                            [ css [ Styles.selection ]
                            , x <| fromPixels <| scaleBeat overlay.layout selection.location.beat
                            , y "0"
                            , height <| fromPixels <| Layout.height layout
                            , width <| fromPixels <| durationSpacing layout duration
                            ]
                            []
                        ]
                        (case selection.note.do of
                            Play pitch ->
                                if selection.dragging then
                                    [ rect
                                        [ css [ Styles.pitchLevel ]
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

                Nothing ->
                    []
            )
        )
