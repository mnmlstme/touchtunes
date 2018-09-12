module TouchTunes.MeasureEdit.HeadUpDisplay
    exposing
        ( HeadUpDisplay
        , view
        )

import Html.Events exposing (onMouseEnter, onMouseUp)
import Music.Duration exposing (fromTimeBeats)
import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Location
        , Pixels
        , Tenths
        , beatSpacing
        , cxPx
        , cyPx
        , halfSpacing
        , heightPx
        , rPx
        , scaleBeat
        , scaleEndBeat
        , scaleStartBeat
        , scaleStep
        , spacing
        , widthPx
        , xPx
        , yPx
        )
import Music.Measure.Model as Measure exposing (Measure)
import Music.Measure.View exposing (layoutFor)
import Music.Note.Model exposing (playFor, restFor)
import Music.Pitch exposing (Pitch, fromStepNumber, stepNumber)
import Music.Time exposing (Beat)
import Svg exposing (Svg, circle, g, rect, svg)
import Svg.Attributes exposing (class, transform)
import String
import TouchTunes.MeasureEdit.Action as Action exposing (Action)


type alias HeadUpDisplay =
    { measure : Measure
    , beat : Beat
    , pitch : Pitch
    }


view : HeadUpDisplay -> Svg Action
view hud =
    let
        layout =
            layoutFor hud.measure

        up =
            onMouseUp Action.Finish
    in
        svg
            [ class "measure-hud"
            , heightPx <| Layout.height layout
            , widthPx <| Layout.width layout
            , up
            ]
            [ viewNoteDurations hud
            , viewRestDurations hud
            , viewPitches hud
            , viewAlterations hud
            ]


viewNoteDurations : HeadUpDisplay -> Svg Action
viewNoteDurations hud =
    let
        layout =
            layoutFor hud.measure

        t =
            layout.time

        s =
            spacing layout

        beats =
            List.range hud.beat (t.beats - 1)

        position =
            String.join "," <|
                List.map String.fromFloat
                    [ 0
                    , .px <| scaleStep layout <| stepNumber hud.pitch
                    ]

        pitch =
            hud.pitch

        hotspot beat =
            let
                dur =
                    fromTimeBeats t (beat - hud.beat + 1)

                note =
                    playFor dur pitch

                action =
                    onMouseEnter <| Action.ReplaceNote note hud.beat
            in
                rect
                    [ class "measure-hotspot"
                    , heightPx <| Pixels (2 * s.px)
                    , widthPx <| beatSpacing layout
                    , xPx <| scaleStartBeat layout (beat + 1)
                    , yPx <| Pixels (-1 * s.px)
                    , action
                    ]
                    []
    in
        g
            [ class "measure-hud-note-hotspots"
            , transform
                ("translate(" ++ position ++ ")")
            ]
        <|
            List.map hotspot beats


viewRestDurations : HeadUpDisplay -> Svg Action
viewRestDurations hud =
    let
        layout =
            layoutFor hud.measure

        t =
            layout.time

        s =
            spacing layout

        beats =
            List.range 0 hud.beat

        position =
            String.join "," <|
                List.map String.fromFloat
                    [ 0
                    , .px <| scaleStep layout <| stepNumber hud.pitch
                    ]

        hotspot beat =
            let
                dur =
                    fromTimeBeats t (hud.beat - beat + 1)

                rest =
                    restFor dur

                action =
                    onMouseEnter <|
                        Action.ReplaceNote rest beat
            in
                rect
                    [ class "measure-hotspot"
                    , heightPx <| Pixels (4 * s.px)
                    , widthPx <| Pixels 3
                    , xPx <| scaleStartBeat layout beat
                    , yPx <| Pixels (-2 * s.px)
                    , action
                    ]
                    []
    in
        g
            [ class "measure-hud-rest-hotspots"
            , transform
                ("translate(" ++ position ++ ")")
            ]
        <|
            List.map hotspot beats


viewPitches : HeadUpDisplay -> Svg Action
viewPitches hud =
    let
        layout =
            layoutFor hud.measure

        deltas =
            List.map ((-) <| stepNumber hud.pitch) <|
                List.range
                    (Layout.bottomStep layout)
                    (Layout.topStep layout)

        position =
            String.join "," <|
                List.map String.fromFloat
                    [ .px <| scaleBeat layout hud.beat
                    , .px <| scaleStep layout <| stepNumber hud.pitch
                    ]

        hotspot : Int -> Svg Action
        hotspot delta =
            let
                pitch =
                    fromStepNumber <| stepNumber hud.pitch + delta

                action =
                    onMouseEnter <|
                        Action.RepitchNote pitch hud.beat

                sp2 =
                    .px <| halfSpacing layout

                h =
                    2

                w =
                    20
            in
                rect
                    [ class "measure-hotspot"
                    , heightPx <| Pixels <| h
                    , widthPx <| Pixels <| w
                    , xPx <| Pixels <| -w / 2
                    , yPx <|
                        Pixels <|
                            (-) (-h / 2) <|
                                (*) (toFloat delta) <|
                                    .px <|
                                        halfSpacing layout
                    , action
                    ]
                    []
    in
        g
            [ class "measure-hud-pitch-hotspots"
            , transform
                ("translate(" ++ position ++ ")")
            ]
        <|
            List.map hotspot deltas


viewAlterations : HeadUpDisplay -> Svg Action
viewAlterations hud =
    let
        layout =
            layoutFor hud.measure

        s =
            spacing layout

        half =
            halfSpacing layout

        pitch =
            hud.pitch

        position =
            String.join "," <|
                List.map String.fromFloat
                    [ .px <| scaleBeat layout hud.beat
                    , .px <| scaleStep layout <| stepNumber pitch
                    ]

        flatAction =
            let
                altered =
                    { pitch | alter = -1 }
            in
                onMouseEnter <|
                    Action.RepitchNote altered hud.beat

        sharpAction =
            let
                altered =
                    { pitch | alter = 1 }
            in
                onMouseEnter <|
                    Action.RepitchNote altered hud.beat
    in
        g
            [ class "measure-hud-alter-hotspots"
            , transform
                ("translate(" ++ position ++ ")")
            ]
            [ circle
                [ class "measure-hotspot"
                , rPx half
                , cxPx s
                , cyPx <| Pixels (1.5 * s.px)
                , flatAction
                ]
                []
            , circle
                [ class "measure-hotspot"
                , rPx half
                , cxPx s
                , cyPx <| Pixels (-1.5 * s.px)
                , sharpAction
                ]
                []
            ]
