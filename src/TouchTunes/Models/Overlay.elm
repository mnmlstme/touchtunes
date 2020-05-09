module TouchTunes.Models.Overlay exposing
    ( Overlay
    , Selection
    , deselect
    , drag
    , finish
    , fromLayout
    , start
    , subdivide
    )

import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Location
        , positionToLocation
        )
import Music.Models.Note exposing (Note, What(..))
import Music.Models.Pitch as Pitch
import Music.Models.Time as Time


type alias Selection =
    { note : Note
    , location : Location
    , dragging : Bool
    }


type alias Overlay =
    { layout : Layout
    , selection : Maybe Selection
    }


fromLayout : Layout -> Overlay
fromLayout layout =
    Overlay layout Nothing


subdivide : Duration -> Overlay -> Overlay
subdivide duration overlay =
    let
        time =
            Layout.time overlay.layout

        l =
            Layout.subdivide
                (duration.divisor // Time.divisor time)
                overlay.layout
    in
    { overlay | layout = l }


deselect : Overlay -> Overlay
deselect overlay =
    { overlay | selection = Nothing }


start : Duration -> ( Int, Int ) -> Overlay -> Overlay
start duration pos overlay =
    let
        time =
            Layout.time overlay.layout

        key =
            Layout.key overlay.layout

        loc =
            Layout.positionToLocation
                (Layout.subdivide
                    (duration.divisor // Time.divisor time)
                    overlay.layout
                )
                pos

        pitch =
            Pitch.fromStepNumber key loc.step

        note =
            Note (Play pitch) duration []
    in
    { overlay
        | selection =
            Just
                { note = note
                , location = loc
                , dragging = True
                }
    }


drag : Duration -> ( Int, Int ) -> Overlay -> Overlay
drag duration pos overlay =
    case overlay.selection of
        Just selection ->
            if selection.dragging then
                let
                    layout =
                        overlay.layout

                    time =
                        Layout.time layout

                    key =
                        Layout.key layout

                    loc =
                        positionToLocation
                            (Layout.subdivide
                                (duration.divisor // Time.divisor time)
                                layout
                            )
                            pos

                    nextLoc =
                        Layout.locationAfter layout loc

                    beat =
                        selection.location.beat

                    modifier note =
                        let
                            dur =
                                Beat.durationFrom (Layout.time layout) beat nextLoc.beat
                        in
                        if Beat.equal beat loc.beat then
                            { note
                                | do = Play <| Pitch.fromStepNumber key loc.step
                                , duration = dur
                            }

                        else
                            { note | duration = dur }

                    sel =
                        { selection | note = modifier selection.note }
                in
                { overlay | selection = Just sel }

            else
                overlay

        Nothing ->
            overlay


finish : Overlay -> Overlay
finish overlay =
    { overlay
        | selection =
            Maybe.map
                (\sel -> { sel | dragging = False })
                overlay.selection
    }
