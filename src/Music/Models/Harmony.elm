module Music.Models.Harmony exposing
    ( Alteration(..)
    , Chord(..)
    , Degree
    , Harmony
    , Kind(..)
    , add
    , augmented
    , chord
    , diminished
    , dominant
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

import Music.Models.Pitch exposing (Root, Semitones, Step)


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


type alias Degree =
    Int


type Alteration
    = Sus Degree -- sus2, sus4
    | Add Degree -- add 9
    | No Degree -- no3, no5
    | Raised Degree -- sharp 9
    | Lowered Degree -- flat 11
    | Altered String Degree -- Maj 7


chord : Kind -> Root -> Harmony
chord kind root =
    { root = root
    , kind = kind
    , alter = []
    , bass = Nothing
    }


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
