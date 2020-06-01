module Music.Models.Harmony exposing
    ( Alteration(..)
    , Chord(..)
    , Function(..)
    , Harmony
    , Kind(..)
    , add
    , augmented
    , chord
    , chordDegree
    , diminished
    , dominant
    , function
    , halfDiminished
    , lowered
    , major
    , majorMinor
    , minor
    , no
    , over
    , power
    , raised
    , sus
    )

import Music.Models.Key as Key exposing (Degree, Key)
import Music.Models.Pitch exposing (Root, Semitones, Step)
import Music.Models.Scale as Scale


type alias Harmony =
    { root : Root
    , kind : Kind
    , alter : List Alteration
    , bass : Maybe Root
    }


type Chord
    = Triad
    | Sixth
    | Seventh
    | Ninth
    | Eleventh
    | Thirteenth


type Kind
    = Major Chord
    | Minor Chord
    | Diminished Chord
    | Augmented Chord
    | Dominant Chord -- 7 and above
    | HalfDiminished -- implies 7
    | MajorMinor -- implies 7
    | Power -- no 3, no 7


type Alteration
    = Sus Degree -- sus2, sus4
    | Add Degree -- add 9
    | No Degree -- no3, no5
    | Raised Degree -- sharp 9
    | Lowered Degree -- flat 11
    | Altered String Degree -- Maj 7


type Function
    = I
    | II
    | III
    | IV
    | V
    | VI
    | VII


chordDegree : Harmony -> Chord
chordDegree harmony =
    case harmony.kind of
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


chord : Kind -> Root -> Harmony
chord kind root =
    { root = root
    , kind = kind
    , alter = []
    , bass = Nothing
    }


function : Key -> Chord -> Function -> Harmony
function k degree f =
    let
        tonic =
            Key.tonic k

        scale =
            Scale.major tonic

        ( step, kind ) =
            case f of
                I ->
                    ( 1, Major degree )

                II ->
                    ( 2, Minor degree )

                III ->
                    ( 3, Minor degree )

                IV ->
                    ( 4, Major degree )

                V ->
                    ( 5, Dominant degree )

                VI ->
                    ( 6, Minor degree )

                VII ->
                    ( 7, HalfDiminished )
    in
    chord kind <|
        Maybe.withDefault tonic <|
            Scale.note step <|
                Scale.major tonic


major : Chord -> Root -> Harmony
major c =
    chord (Major c)


minor : Chord -> Root -> Harmony
minor c =
    chord (Minor c)


dominant : Chord -> Root -> Harmony
dominant c =
    chord (Dominant c)


diminished : Chord -> Root -> Harmony
diminished c =
    chord (Diminished c)


augmented : Chord -> Root -> Harmony
augmented c =
    chord (Augmented c)


halfDiminished : Root -> Harmony
halfDiminished =
    chord HalfDiminished


majorMinor : Root -> Harmony
majorMinor =
    chord MajorMinor


power : Root -> Harmony
power =
    chord Power


sus : Degree -> Harmony -> Harmony
sus int harmony =
    withAlteration (Sus int) harmony


add : Degree -> Harmony -> Harmony
add int harmony =
    withAlteration (Add int) harmony


no : Degree -> Harmony -> Harmony
no int harmony =
    withAlteration (No int) harmony


raised : Int -> Harmony -> Harmony
raised int harmony =
    withAlteration (Raised int) harmony


lowered : Int -> Harmony -> Harmony
lowered int harmony =
    withAlteration (Lowered int) harmony


withAlteration : Alteration -> Harmony -> Harmony
withAlteration alt harmony =
    { harmony | alter = List.append harmony.alter [ alt ] }


over : Root -> Harmony -> Harmony
over bass harmony =
    { harmony | bass = Just bass }
