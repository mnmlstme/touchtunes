module TouchTunes.MeasureEdit.HeadUpDisplay
    exposing
        ( HeadUpDisplay
        , view
        )

import TouchTunes.MeasureEdit.Action as Action exposing (Action)
import Music.Measure.Model as Measure exposing (Measure)
import Music.Measure.Update as MeasureAction
import Music.Measure.View exposing (layoutFor)
import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , Tenths
        , Location
        , heightPx
        , widthPx
        , xPx
        , yPx
        , cxPx
        , cyPx
        , rPx
        , spacing
        , halfSpacing
        , positionToLocation
        , scaleStep
        , scaleBeat
        )
import Music.Note.Model exposing (playFor, restFor)
import Music.Pitch exposing (fromStepNumber)
import Music.Duration exposing (fromTimeBeats)
import Json.Decode as Decode exposing (Decoder, field, int)
import Mouse
import Svg exposing (Svg, svg, g, circle, rect)
import Svg.Attributes exposing (class, transform)
import Html.Events
    exposing
        ( on
        , onMouseUp
        , onMouseOut
        , onMouseEnter
        )


type alias HeadUpDisplay =
    { measure : Measure
    , cursor : Maybe Location
    }


mouseOffset : Decoder Mouse.Position
mouseOffset =
    -- TODO: submit PR to elm-lang/mouse to add mouseOffset
    Decode.map2 Mouse.Position
        (field "offsetX" int)
        (field "offsetY" int)


view : HeadUpDisplay -> Svg Action
view hud =
    let
        layout =
            layoutFor hud.measure

        toLocation =
            positionToLocation layout

        down =
            on "mousedown" <|
                Decode.map Action.StartGesture <|
                    Decode.map toLocation mouseOffset

        up =
            onMouseUp Action.FinishGesture

        out =
            onMouseOut Action.FinishGesture

        actions =
            case hud.cursor of
                Nothing ->
                    [ down ]

                Just _ ->
                    [ up ]
    in
        svg
            (List.append
                [ class "measure-hud"
                , heightPx <| Layout.height layout
                , widthPx <| Layout.width layout
                ]
                actions
            )
            [ Svg.map Action.MeasureAction <| viewNoteDurations hud
            , Svg.map Action.MeasureAction <| viewRestDurations hud
            , Svg.map Action.MeasureAction <| viewPitches hud
            ]


viewNoteDurations : HeadUpDisplay -> Svg MeasureAction.Action
viewNoteDurations hud =
    case hud.cursor of
        Nothing ->
            g [] [ g [] [] ]

        Just loc ->
            let
                layout =
                    layoutFor hud.measure

                t =
                    layout.time

                s =
                    spacing layout

                x0 =
                    Pixels <|
                        (scaleBeat layout loc.beat).px
                            + s.px
                            + 5

                beats =
                    List.range loc.beat (t.beats - 1)

                position =
                    String.join "," <|
                        List.map toString
                            [ 0
                            , .px <| scaleStep layout loc.step
                            ]

                pitch =
                    fromStepNumber loc.step

                hotspot beat =
                    let
                        dur =
                            fromTimeBeats t (beat - loc.beat + 1)

                        note =
                            playFor dur pitch

                        action =
                            onMouseEnter <| MeasureAction.ReplaceNote note loc.beat
                    in
                        circle
                            [ class "measure-hotspot"
                            , rPx s
                            , cxPx <|
                                if beat == loc.beat then
                                    x0
                                else
                                    scaleBeat layout beat
                            , cyPx <| Pixels <| 0
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


viewRestDurations : HeadUpDisplay -> Svg MeasureAction.Action
viewRestDurations hud =
    case hud.cursor of
        Nothing ->
            g [] [ g [] [] ]

        Just loc ->
            let
                layout =
                    layoutFor hud.measure

                t =
                    layout.time

                s =
                    spacing layout

                x0 =
                    Pixels <|
                        (scaleBeat layout loc.beat).px
                            - s.px
                            - 5

                beats =
                    List.range 0 loc.beat

                position =
                    String.join "," <|
                        List.map toString
                            [ 0
                            , .px <| scaleStep layout loc.step
                            ]

                hotspot beat =
                    let
                        dur =
                            fromTimeBeats t (loc.beat - beat + 1)

                        rest =
                            restFor dur

                        action =
                            onMouseEnter <|
                                MeasureAction.ReplaceNote rest beat
                    in
                        circle
                            [ class "measure-hotspot"
                            , rPx s
                            , cxPx <|
                                if beat == loc.beat then
                                    x0
                                else
                                    scaleBeat layout beat
                            , cyPx <| Pixels <| 0
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


viewPitches : HeadUpDisplay -> Svg MeasureAction.Action
viewPitches hud =
    case hud.cursor of
        Nothing ->
            g [] []

        Just loc ->
            let
                layout =
                    layoutFor hud.measure

                deltas =
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

                hotspot : Int -> Svg MeasureAction.Action
                hotspot delta =
                    let
                        pitch =
                            fromStepNumber <| loc.step + delta

                        action =
                            onMouseEnter <|
                                MeasureAction.RepitchNote pitch loc.beat

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
