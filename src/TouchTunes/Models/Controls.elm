module TouchTunes.Models.Controls exposing
    ( ControlSelector
    , Controls
    , forSelection
    , init
    )

import Array as Array
import Debug exposing (log)
import Music.Models.Duration exposing (quarter)
import Music.Models.Harmony as Harmony
    exposing
        ( Alteration(..)
        , Chord(..)
        , Function(..)
        , Harmony
        , Kind(..)
        , function
        )
import Music.Models.Key as Key
    exposing
        ( Key
        , KeyName(..)
        , keyOf
        )
import Music.Models.Layout as Layout exposing (Layout)
import Music.Models.Measure as Measure
import Music.Models.Note as Note exposing (Note)
import Music.Models.Pitch as Pitch
    exposing
        ( Chromatic(..)
        , Root
        , chromatic
        , root
        )
import Music.Models.Time as Time exposing (BeatType(..), Time)
import Music.Views.HarmonyView as HarmonyView
import Music.Views.MeasureView as MeasureView
import Music.Views.NoteView exposing (alteration)
import Music.Views.Symbols as Symbols
import Svg exposing (Svg, g, text, text_)
import Svg.Attributes exposing (transform)
import TouchTunes.Actions.Top exposing (Msg(..))
import TouchTunes.Models.Overlay exposing (Selection(..))
import TouchTunes.Views.Symbols
    exposing
        ( subdivideFour
        , subdivideOne
        , subdivideTwo
        )
import Vectrol.Models.Dial as Dial exposing (Dial)


type alias Controls msg =
    { subdivisionDial : Dial Int msg

    -- for Note:
    , alterationDial : Dial Chromatic msg

    -- for Measure:
    , timeDial : Dial Time msg
    , keyDial : Dial KeyName msg

    -- for Harmony:
    , harmonyDial : Dial (Maybe Harmony) msg
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
                initHarmonyDial (Layout.key l) Nothing
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
            , harmonyDial = initHarmonyDial (keyOf C Key.Major) Nothing
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

        HarmonySelection mHarmony key _ ->
            { controls
                | harmonyDial =
                    initHarmonyDial key <|
                        log "harmony for selection " mHarmony
                , kindDial =
                    initKindDial <| Maybe.map .kind mHarmony
                , chordDial =
                    initChordDial <| Maybe.map Harmony.chordDegree mHarmony
                , altHarmonyDial =
                    initAltHarmonyDial <| Maybe.map .alter mHarmony
                , bassDial =
                    initBassDial key <|
                        Maybe.map
                            (\harmony ->
                                Maybe.withDefault harmony.root harmony.bass
                            )
                            mHarmony
            }

        NoteSelection note _ _ ->
            case Note.pitch note of
                Just p ->
                    Maybe.withDefault controls <|
                        Maybe.map
                            (\chr ->
                                { controls
                                    | alterationDial = initAlterationDial chr
                                }
                            )
                            (chromatic p.alter)

                Nothing ->
                    controls


forHarmony : Harmony -> Key -> Controls msg -> Controls msg
forHarmony harmony key controls =
    { controls
        | harmonyDial = initHarmonyDial key <| Just harmony
        , kindDial = initKindDial <| Just harmony.kind
        , chordDial = initChordDial <| Just <| Harmony.chordDegree harmony
        , altHarmonyDial = initAltHarmonyDial <| Just harmony.alter
        , bassDial = initBassDial key <| Just <| Maybe.withDefault harmony.root harmony.bass
    }


initSubdivisionDial : Dial Int msg
initSubdivisionDial =
    -- sets subdivision of current measure(quarter/eighth...)
    -- TODO: options depend on time signature
    -- TODO: initial depends on notes in measure
    Dial.init
        8
        viewSubdivision
        [ 4, 2, 1 ]
        1


initAlterationDial : Chromatic -> Dial Chromatic msg
initAlterationDial chr =
    -- alterationDial: sets alteration (sharp/flat/natural)
    -- TODO: initial depends on selected note
    Dial.init
        12
        viewAlteration
        [ DoubleFlat, Flat, Natural, Sharp, DoubleSharp ]
        chr


initTimeDial : Maybe Time -> Dial Time msg
initTimeDial t =
    -- timeDial: sets Time signature
    -- TODO: initial depends on current mesaure
    Dial.init
        10
        drawTime
        [ Time.cut
        , Time 2 Four
        , Time 3 Four
        , Time.common
        , Time 5 Four
        , Time 6 Eight
        , Time 7 Eight
        , Time 9 Eight
        ]
    <|
        Maybe.withDefault Time.common t


initKeyDial : Maybe KeyName -> Dial KeyName msg
initKeyDial k =
    -- keyDial: sets Key signature
    Dial.init
        15
        drawKey
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
    <|
        Maybe.withDefault C k


initHarmonyDial : Key -> Maybe Harmony -> Dial (Maybe Harmony) msg
initHarmonyDial k h =
    -- harmonyDial: chose chord based on function in Key
    Dial.init
        12
        (\mh ->
            case mh of
                Just harmony ->
                    HarmonyView.draw harmony

                Nothing ->
                    text "N.C."
        )
        (List.append [ Nothing ] <|
            List.map2
                (\f degree -> Just <| function k degree f)
                [ I, II, III, IV, V, VI, VII ]
                [ Triad, Triad, Triad, Triad, Seventh, Triad, Seventh ]
        )
    <|
        Just <|
            Maybe.withDefault (Harmony.function k Triad I) h


initBassDial : Key -> Maybe Root -> Dial Root msg
initBassDial k r =
    -- bassDial: sets Bass note if not Root of Chord
    Dial.init
        24
        (HarmonyView.drawBass << Just)
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
    <|
        Maybe.withDefault (root Pitch.C Natural) r


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
        18
        (kindString >> HarmonyView.drawKindString)
        [ Major chord
        , Minor chord
        , Diminished chord
        , Augmented chord
        , Dominant chord
        , HalfDiminished
        , MajorMinor
        , Power
        ]
        initial


kindString : Kind -> String
kindString kind =
    case kind of
        Major _ ->
            "Maj"

        Minor _ ->
            "m"

        Diminished _ ->
            "o"

        Augmented _ ->
            "+"

        Dominant _ ->
            "Dom"

        HalfDiminished ->
            "ø"

        MajorMinor ->
            "M/m"

        Power ->
            "Pow"


initChordDial : Maybe Chord -> Dial Chord msg
initChordDial ch =
    Dial.init
        15
        (HarmonyView.degreeNumber
            >> Maybe.withDefault "Triad"
            >> HarmonyView.drawDegree
        )
        [ Triad
        , Sixth
        , Seventh
        , Ninth
        , Eleventh
        , Thirteenth
        ]
    <|
        Maybe.withDefault Triad ch


initAltHarmonyDial : Maybe (List Alteration) -> Dial (List Alteration) msg
initAltHarmonyDial ls =
    Dial.init
        18
        (\alts ->
            if List.isEmpty alts then
                text_ [] [ text "( )" ]

            else
                HarmonyView.drawAlterationList alts
        )
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
    <|
        Maybe.withDefault [] ls


fakeLayout : Layout
fakeLayout =
    Layout.forMeasure Measure.noAttributes Measure.new


viewSubdivision : Int -> Svg msg
viewSubdivision sub =
    let
        symbol =
            if sub == 4 then
                subdivideFour

            else if sub == 2 then
                subdivideTwo

            else
                subdivideOne
    in
    Symbols.glyph symbol


viewAlteration : Chromatic -> Svg msg
viewAlteration chr =
    let
        symbol =
            alteration chr
    in
    Symbols.glyph symbol


drawTime : Time -> Svg msg
drawTime time =
    g [ transform "scale(0.5)" ]
        [ MeasureView.drawTime fakeLayout <| Just time ]


drawKey : KeyName -> Svg msg
drawKey kn =
    let
        key =
            -- TODO: handle other modes
            keyOf kn Key.Major
    in
    HarmonyView.drawRoot (Key.tonic key)
