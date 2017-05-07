module TouchTunes.HeadUpDisplay
    exposing
        ( HeadUpDisplay
        , hud
        , update
        , view
        )

import TouchTunes.Gesture as Gesture exposing (Gesture)
import Music.Measure.Model as Measure exposing (Measure)
import Music.Measure.View exposing (layoutFor)
import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , Tenths
        , Location
        , heightPx
        , widthPx
        , cxPx
        , cyPx
        , rPx
        , spacing
        , halfSpacing
        , positionToLocation
        , scaleStep
        , scaleBeat
        )
import Json.Decode as Decode exposing (Decoder, field, int)
import Mouse
import Svg exposing (Svg, svg, g, circle)
import Svg.Attributes exposing (class, transform)
import Html.Events
    exposing
        ( on
        , onMouseUp
        , onMouseOut
        )


type alias HeadUpDisplay =
    { measure : Measure
    , gesture : Gesture
    }


hud : Measure -> HeadUpDisplay
hud measure =
    HeadUpDisplay measure Gesture.Idle


mouseOffset : Decoder Mouse.Position
mouseOffset =
    -- TODO: submit PR to elm-lang/mouse to add mouseOffset
    Decode.map2 Mouse.Position
        (field "offsetX" int)
        (field "offsetY" int)


update : Gesture.Action -> HeadUpDisplay -> HeadUpDisplay
update action hud =
    { hud | gesture = Gesture.update action hud.gesture }


view : HeadUpDisplay -> Svg Gesture.Action
view hud =
    let
        layout =
            layoutFor hud.measure

        toLocation =
            positionToLocation layout

        down =
            on "mousedown" <|
                Decode.map Gesture.StartGesture <|
                    Decode.map toLocation mouseOffset

        move =
            on "mousemove" <|
                Decode.map Gesture.ContinueGesture <|
                    Decode.map toLocation mouseOffset

        up =
            onMouseUp Gesture.FinishGesture

        out =
            onMouseOut Gesture.FinishGesture

        actions =
            case hud.gesture of
                Gesture.Idle ->
                    [ down ]

                Gesture.Touch _ ->
                    [ move, up ]

                Gesture.Drag _ _ ->
                    [ move, up, out ]

                Gesture.Reversal _ _ _ ->
                    [ move, up, out ]
    in
        svg
            (List.append
                [ class "measure-hud"
                , heightPx <| Layout.height layout
                , widthPx <| Layout.width layout
                ]
                actions
            )
            [ viewNoteDurations hud
            , viewPitches hud
            ]


viewNoteDurations : HeadUpDisplay -> Svg msg
viewNoteDurations hud =
    case Gesture.start hud.gesture of
        Nothing ->
            g [] [ g [] [] ]

        Just loc ->
            let
                layout =
                    layoutFor hud.measure

                t =
                    layout.time

                b =
                    loc.beat

                beats =
                    List.range (b + 1) (t.beats - 1)

                position =
                    String.join "," <|
                        List.map toString
                            [ 0
                            , .px <| scaleStep layout loc.step
                            ]

                hotspot beat =
                    circle
                        [ rPx <| spacing layout
                        , cxPx <| scaleBeat layout beat
                        , cyPx <| Pixels <| 0
                        ]
                        []
            in
                g
                    [ class "measure-hud-note-durations"
                    , transform
                        ("translate(" ++ position ++ ")")
                    ]
                <|
                    List.map hotspot beats


viewRestDurations : HeadUpDisplay -> Svg msg
viewRestDurations hud =
    g [] []


viewPitches : HeadUpDisplay -> Svg msg
viewPitches hud =
    case Gesture.start hud.gesture of
        Nothing ->
            g [] []

        Just loc ->
            case Gesture.current hud.gesture of
                Nothing ->
                    g [] []

                Just cloc ->
                    if cloc.beat /= loc.beat then
                        g [] []
                    else
                        let
                            layout =
                                layoutFor hud.measure

                            deltas =
                                List.filter ((/=) 0) <|
                                    List.map ((-) loc.step) <|
                                        List.range
                                            (Layout.bottomStep layout)
                                            (Layout.topStep layout)

                            position =
                                String.join "," <|
                                    List.map toString
                                        [ .px <| scaleBeat layout loc.beat
                                        , .px <| scaleStep layout loc.step
                                        ]

                            hotspot delta =
                                circle
                                    [ rPx <| Pixels <| 3
                                    , cxPx <| Pixels <| 0
                                    , cyPx <|
                                        Pixels <|
                                            (*) delta <|
                                                .px <|
                                                    halfSpacing layout
                                    ]
                                    []
                        in
                            g
                                [ class "measure-hud-pitches"
                                , transform
                                    ("translate(" ++ position ++ ")")
                                ]
                            <|
                                List.map hotspot <|
                                    List.map toFloat deltas
