module TouchTunes.Models.Overlay exposing
    ( Overlay
    , Selection(..)
    , changeHarmony
    , deselect
    , drag
    , editHarmony
    , editNote
    , findContinuedNote
    , findNote
    , finish
    , fromLayout
    , positionToLocation
    , startNote
    , subdivide
    )

import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Harmony as Harmony exposing (Chord(..), Harmony, Kind(..), chord)
import Music.Models.Key as Key exposing (Key, tonic)
import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Location
        , positionToLocation
        )
import Music.Models.Measure as Measure exposing (Measure)
import Music.Models.Note exposing (Note, What(..))
import Music.Models.Pitch as Pitch
import Music.Models.Time as Time


type Selection
    = NoteSelection Note Location Bool
    | HarmonySelection (Maybe Harmony) Key Beat
    | NoSelection


type alias Overlay =
    { layout : Layout
    , selection : Selection
    }


type alias Position =
    ( Int, Int )


fromLayout : Layout -> Overlay
fromLayout layout =
    Overlay layout NoSelection


subdivide : Int -> Overlay -> Overlay
subdivide sub overlay =
    let
        l =
            Layout.subdivide  sub overlay.layout
    in
    { overlay | layout = l }


deselect : Overlay -> Overlay
deselect overlay =
    { overlay | selection = NoSelection }


positionToLocation : Position -> Overlay -> Location
positionToLocation pos overlay =
    Layout.positionToLocation overlay.layout pos


findNote : Position -> Measure -> Overlay -> Maybe Note
findNote pos measure overlay =
    let
        time =
            Layout.time overlay.layout

        loc =
            positionToLocation pos overlay

        offset =
            Beat.toDuration time loc.beat
    in
    Measure.findNote offset measure


findContinuedNote : Position -> Measure -> Overlay -> (Measure.Offset, Note)
findContinuedNote pos measure overlay =
    let
        time =
            Layout.time overlay.layout

        loc =
            positionToLocation pos overlay

        offset =
            Beat.toDuration time loc.beat
    in
        Measure.findContinuedNote offset measure



startNote : Position -> Overlay -> Overlay
startNote pos overlay =
    let
        key =
            Layout.key overlay.layout

        loc =
            positionToLocation pos overlay

        pitch =
            Key.stepNumberToPitch key loc.step

        duration =
            Layout.locationDuration overlay.layout loc

        note =
            Note (Play pitch) duration [] Nothing
    in
    editNote pos note overlay


editNote : Position -> Note -> Overlay -> Overlay
editNote pos note overlay =
    let
        loc =
            positionToLocation pos overlay
    in
    { overlay
        | selection =
            NoteSelection note loc True
    }



editHarmony : Measure.Offset -> Maybe Harmony -> Overlay -> Overlay
editHarmony dur harmony overlay =
    let
        time =
            Layout.time overlay.layout

        beat =
            Beat.fromDuration time dur

        key =
            Layout.key overlay.layout
    in
    { overlay
        | selection =
            HarmonySelection harmony key beat
    }


changeHarmony : Maybe Harmony  -> Overlay -> Overlay
changeHarmony mHarmony overlay =
    case overlay.selection of
        HarmonySelection _ key beat ->
            { overlay
                | selection =
                    HarmonySelection mHarmony key beat
            }

        _ ->
            overlay


drag : Position -> Overlay -> Overlay
drag pos overlay =
    case overlay.selection of
        HarmonySelection harm key beat ->
            { overlay
                | selection = HarmonySelection harm key beat
            }

        NoteSelection note location dragging ->
            if dragging then
                let
                    layout =
                        overlay.layout

                    time =
                        Layout.time layout

                    key =
                        Layout.key layout

                    loc =
                        positionToLocation pos overlay

                    nextLoc =
                        Layout.locationAfter layout loc

                    beat =
                        location.beat

                    modifier n =
                        let
                            dur =
                                Beat.durationFrom (Layout.time layout) beat nextLoc.beat
                        in
                        if Beat.equal beat loc.beat then
                            { n
                                | do = Play <| Key.stepNumberToPitch key loc.step
                                , duration = dur
                            }

                        else
                            { n | duration = dur }
                in
                { overlay | selection = NoteSelection (modifier note) location dragging }

            else
                overlay

        NoSelection ->
            overlay


finish : Overlay -> Overlay
finish overlay =
    { overlay
        | selection =
            case overlay.selection of
                NoteSelection note location bool ->
                    NoteSelection note location False

                HarmonySelection harm key beat ->
                    HarmonySelection harm key beat

                NoSelection ->
                    NoSelection
    }
