module TouchTunes.Models.Controls exposing
    ( ControlSelector
    , Controls
    , forSelection
    , init
    )

import Array as Array
import Debug exposing (log)
import Html as Html exposing (Html, span)
import Maybe.Extra
import Music.Models.Duration
    exposing
        ( Duration
        , eighth
        , half
        , quarter
        )
import Music.Models.Harmony as Harmony
    exposing
        ( Alteration(..)
        , Chord(..)
        , Function(..)
        , Harmony
        , Kind(..)
        , chord
        , function
        )
import Music.Models.Key as Key
    exposing
        ( Degree
        , Key
        , KeyName(..)
        , keyOf
        )
import Music.Models.Layout as Layout exposing (Layout)
import Music.Models.Measure as Measure exposing (Measure)
import Music.Models.Note as Note exposing (Note)
import Music.Models.Pitch as Pitch
    exposing
        ( Chromatic(..)
        , Root
        , Semitones
        , alter
        , chromatic
        , root
        )
import Music.Models.Staff as Staff
import Music.Models.Time as Time exposing (BeatType(..), Time)
import Music.Views.HarmonyView as HarmonyView
import Music.Views.MeasureView as MeasureView
import Music.Views.NoteView as NoteView
    exposing
        ( StemOrientation(..)
        , alteration
        , isWhole
        , viewNote
        )
import Music.Views.Symbols as Symbols
import String exposing (fromFloat, fromInt)
import Svg exposing (Svg, g, text, text_)
import Svg.Attributes
    exposing
        ( fontSize
        , fontWeight
        , textAnchor
        , transform
        , x
        , y
        )
import TouchTunes.Actions.Top exposing (Msg(..))
import TouchTunes.Models.Dial as Dial exposing (Dial)
import TouchTunes.Models.Overlay as Overlay exposing (Selection(..))


type alias Controls msg =
    { subdivisionDial : Dial Duration msg

    -- for Note:
    , alterationDial : Dial Chromatic msg

    -- for Measure:
    , timeDial : Dial Time msg
    , keyDial : Dial KeyName msg

    -- for Harmony:
    , harmonyDial : Dial Harmony msg
    , kindDial : Dial Kind msg
    , chordDial : Dial Chord msg
    , altHarmonyDial : Dial (List Alteration) msg
    , bassDial : Dial Root msg
    }


type alias ControlSelector a val msg =
    a -> Dial val msg


init : Maybe Layout -> Controls msg
init layout =
    case layout of
        Just l ->
            { keyDial =
                initKeyDial <|
                    Maybe.map Key.keyName <|
                        Just <|
                            Layout.key l
            , alterationDial = initAlterationDial Natural
            , timeDial = initTimeDial <| Just <| Layout.time l
            , subdivisionDial = initSubdivisionDial
            , harmonyDial =
                initHarmonyDial (Layout.key l) Seventh <|
                    Maybe.map (Harmony.chord (Major Seventh) << Key.tonic) <|
                        Just <|
                            Layout.key l
            , bassDial =
                initBassDial (Layout.key l) <|
                    Maybe.map Key.tonic <|
                        Just <|
                            Layout.key l
            , kindDial = initKindDial <| Just (Major Triad)
            , chordDial = initChordDial <| Just Seventh
            , altHarmonyDial = initAltHarmonyDial <| Just []
            }

        Nothing ->
            { subdivisionDial = initSubdivisionDial
            , alterationDial = initAlterationDial Natural
            , timeDial = initTimeDial Nothing
            , keyDial = initKeyDial Nothing
            , harmonyDial = initHarmonyDial (keyOf C Key.Major) Seventh Nothing
            , bassDial = initBassDial (keyOf C Key.Major) Nothing
            , kindDial = initKindDial Nothing
            , chordDial = initChordDial Nothing
            , altHarmonyDial = initAltHarmonyDial Nothing
            }


forSelection : Selection -> Controls msg -> Controls msg
forSelection selection controls =
    case selection of
        NoSelection ->
            controls

        HarmonySelection harmony key _ ->
            let
                deg =
                    Harmony.chordDegree harmony

                hd =
                    initHarmonyDial key deg <| Just <| log "harmony for selection " harmony

                h =
                    hd.value
            in
            { controls
                | harmonyDial = hd
                , kindDial =
                    initKindDial <| Just h.kind
                , chordDial =
                    initChordDial <| Just <| Harmony.chordDegree h
                , altHarmonyDial =
                    initAltHarmonyDial <| Just h.alter
                , bassDial =
                    initBassDial key <|
                        Just <|
                            Maybe.withDefault h.root h.bass
            }

        NoteSelection note _ _ ->
            case Note.pitch note of
                Just p ->
                    Maybe.withDefault controls <|
                        Maybe.map
                            (\chr -> { controls | alterationDial = initAlterationDial chr })
                            (chromatic p.alter)

                Nothing ->
                    controls


initSubdivisionDial : Dial Duration msg
initSubdivisionDial =
    -- sets subdivision of current measure(quarter/eighth...)
    -- TODO: options depend on time signature
    -- TODO: initial depends on notes in measure
    Dial.init
        quarter
        { options =
            Array.fromList
                [ eighth
                , quarter
                , half
                ]
        , segments = 10
        , viewValue = viewSubdivision
        }


initAlterationDial : Chromatic -> Dial Chromatic msg
initAlterationDial chr =
    -- alterationDial: sets alteration (sharp/flat/natural)
    -- TODO: initial depends on selected note
    Dial.init
        chr
        { options =
            Array.fromList [ DoubleFlat, Flat, Natural, Sharp, DoubleSharp ]
        , segments = 6
        , viewValue = viewAlteration
        }


initTimeDial : Maybe Time -> Dial Time msg
initTimeDial t =
    -- timeDial: sets Time signature
    -- TODO: initial depends on current mesaure
    Dial.init
        (Maybe.withDefault Time.common t)
        { options =
            Array.fromList
                [ Time.cut
                , Time 2 Four
                , Time 3 Four
                , Time.common
                , Time 5 Four
                , Time 6 Eight
                , Time 7 Eight
                , Time 9 Eight
                ]
        , segments = 10
        , viewValue = viewTime
        }


initKeyDial : Maybe KeyName -> Dial KeyName msg
initKeyDial k =
    -- keyDial: sets Key signature
    Dial.init
        (Maybe.withDefault C k)
        { options =
            Array.fromList
                [ Dflat
                , Aflat
                , Eflat
                , Bflat
                , F
                , C
                , G
                , D
                , A
                , E
                , B
                , Fsharp
                ]
        , segments = 15
        , viewValue = viewKey
        }


initHarmonyDial : Key -> Chord -> Maybe Harmony -> Dial Harmony msg
initHarmonyDial k degree h =
    -- harmonyDial: chose chord based on function in Key
    Dial.init
        (Maybe.withDefault
            (chord (Major Seventh) <| Key.tonic k)
            h
        )
        { options =
            Array.fromList <|
                List.map
                    (function k degree)
                    [ I, II, III, IV, V, VI, VII ]
        , segments = 12
        , viewValue = HarmonyView.view
        }


initBassDial : Key -> Maybe Root -> Dial Root msg
initBassDial k r =
    -- bassDial: sets Bass note if not Root of Chord
    Dial.init
        (Maybe.withDefault (root Pitch.C Natural) r)
        { options =
            -- TODO: should depend on Key, center on Tonic
            Array.fromList
                [ root Pitch.G Flat
                , root Pitch.D Flat
                , root Pitch.A Flat
                , root Pitch.E Flat
                , root Pitch.B Flat
                , root Pitch.F Natural
                , root Pitch.C Natural
                , root Pitch.G Natural
                , root Pitch.D Natural
                , root Pitch.A Natural
                , root Pitch.E Natural
                , root Pitch.B Natural
                , root Pitch.F Sharp
                ]
        , segments = 15
        , viewValue = HarmonyView.viewBass << Just
        }


initKindDial : Maybe Kind -> Dial Kind msg
initKindDial k =
    -- kindDial sets the Kind of chord (e.g., Major, Minor)
    let
        initial =
            Maybe.withDefault (Major Triad) k

        chord =
            case initial of
                Major ch ->
                    ch

                Minor ch ->
                    ch

                Diminished ch ->
                    ch

                Augmented ch ->
                    ch

                Dominant ch ->
                    ch

                HalfDiminished ->
                    Seventh

                MajorMinor ->
                    Seventh

                Power ->
                    Triad
    in
    Dial.init
        initial
        { options =
            Array.fromList
                [ Major chord
                , Minor chord
                , Diminished chord
                , Augmented chord
                , Dominant chord
                , HalfDiminished
                , MajorMinor
                , Power
                ]
        , segments = 12
        , viewValue =
            HarmonyView.kindString
                >> Maybe.withDefault "Maj"
                >> HarmonyView.viewKindString
        }


initChordDial : Maybe Chord -> Dial Chord msg
initChordDial ch =
    Dial.init
        (Maybe.withDefault Triad ch)
        { options =
            Array.fromList
                [ Triad
                , Sixth
                , Seventh
                , Ninth
                , Eleventh
                , Thirteenth
                ]
        , segments = 9
        , viewValue =
            HarmonyView.degreeNumber
                >> Maybe.withDefault "Triad"
                >> HarmonyView.viewDegree
        }


initAltHarmonyDial : Maybe (List Alteration) -> Dial (List Alteration) msg
initAltHarmonyDial ls =
    Dial.init
        (Maybe.withDefault [] ls)
        { options =
            Array.fromList
                [ []
                , [ Sus 2 ]
                , [ Sus 4 ]
                , [ Add 9 ]
                , [ No 3 ]
                , [ Raised 5 ]
                , [ Raised 9 ]
                , [ Raised 11 ]
                , [ Lowered 5 ]
                , [ Lowered 9 ]
                ]
        , segments = 12
        , viewValue = HarmonyView.viewAlterationList
        }


fakeLayout : Layout
fakeLayout =
    Layout.forMeasure Measure.noAttributes Measure.new


viewSubdivision : Duration -> Svg msg
viewSubdivision d =
    let
        -- choose a pitch which centers the note+stem on staff
        pitch =
            if isWhole d then
                Pitch.b 4

            else
                Pitch.e_ 4

        staffHeight =
            Layout.height fakeLayout
    in
    g
        [ transform ("translate(0," ++ fromFloat (-0.5 * staffHeight.px) ++ ")") ]
        [ viewNote fakeLayout d pitch ]


viewAlteration : Chromatic -> Html msg
viewAlteration chr =
    let
        symbol =
            alteration chr
    in
    Symbols.glyph symbol


viewTime : Time -> Html msg
viewTime time =
    let
        staffHeight =
            Layout.height fakeLayout

        m =
            Layout.margins fakeLayout

        sp =
            Layout.spacing fakeLayout
    in
    MeasureView.viewTime fakeLayout <| Just time


viewKey : KeyName -> Html msg
viewKey kn =
    let
        sp =
            Layout.spacing fakeLayout

        key =
            -- TODO: handle other modes
            keyOf kn Key.Major
    in
    if key.fifths == 0 then
        span []
            [ text "0"
            , Symbols.glyph Symbols.sharp
            , text " , 0"
            , Symbols.glyph Symbols.flat
            ]

    else
        MeasureView.viewKey fakeLayout <| Just key
