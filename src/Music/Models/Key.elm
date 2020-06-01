module Music.Models.Key exposing
    ( Degree
    , Key
    , KeyName(..)
    , Mode(..)
    , displayName
    , equal
    , flats
    , keyName
    , keyOf
    , sharps
    , stepAlteredIn
    , stepNumberToPitch
    , tonic
    )

import Array as Array
import Music.Models.Pitch as Pitch
    exposing
        ( Chromatic(..)
        , Pitch
        , Root
        , Semitones
        , Step
        , StepNumber
        , root
        )


type alias Key =
    { fifths : Int
    , mode : Mode
    }


type Mode
    = Major
    | Minor
    | Ionian
    | Dorian
    | Phrygian
    | Lydian
    | Mixolydian
    | Aeolian
    | Locrian
    | None


type alias Degree =
    Int


sharps : Int -> Key
sharps n =
    Key n None


flats : Int -> Key
flats n =
    Key (0 - n) None


type KeyName
    = C
    | G
    | D
    | A
    | E
    | B
    | Fsharp
    | Gflat
    | Dflat
    | Aflat
    | Eflat
    | Bflat
    | F


flatTonics : Array.Array Root
flatTonics =
    Array.fromList
        [ root Pitch.C Natural
        , root Pitch.F Natural
        , root Pitch.B Flat
        , root Pitch.E Flat
        , root Pitch.A Flat
        , root Pitch.D Flat
        , root Pitch.G Flat
        ]


sharpTonics : Array.Array Root
sharpTonics =
    Array.fromList
        [ root Pitch.C Natural
        , root Pitch.G Natural
        , root Pitch.D Natural
        , root Pitch.A Natural
        , root Pitch.E Natural
        , root Pitch.B Natural
        , root Pitch.F Sharp
        ]


tonic : Key -> Root
tonic key =
    -- TODO: handle modes other than Major
    if key.fifths > 0 then
        Maybe.withDefault (root Pitch.C Natural) <|
            Array.get key.fifths sharpTonics

    else
        Maybe.withDefault (root Pitch.C Natural) <|
            Array.get (abs key.fifths) flatTonics


modeShift : Mode -> Int
modeShift mode =
    case mode of
        Major ->
            0

        Minor ->
            -3

        Ionian ->
            0

        Dorian ->
            -2

        Phrygian ->
            -4

        Lydian ->
            1

        Mixolydian ->
            -1

        Aeolian ->
            -3

        Locrian ->
            -5

        None ->
            0


keyOf : KeyName -> Mode -> Key
keyOf name mode =
    let
        fifths =
            case name of
                C ->
                    0

                G ->
                    1

                D ->
                    2

                A ->
                    3

                E ->
                    4

                B ->
                    5

                Fsharp ->
                    6

                Gflat ->
                    -6

                Dflat ->
                    -5

                Aflat ->
                    -4

                Eflat ->
                    -3

                Bflat ->
                    -2

                F ->
                    -1

        normalize n =
            -- bring back to [-5, 6]
            modBy 12 (n + 17) - 5
    in
    Key (normalize (fifths + modeShift mode)) mode


flatKeyNames : Array.Array KeyName
flatKeyNames =
    Array.fromList [ C, F, Bflat, Eflat, Aflat, Dflat, Gflat ]


sharpKeyNames : Array.Array KeyName
sharpKeyNames =
    Array.fromList [ C, G, D, A, E, B, Fsharp ]


keyName : Key -> KeyName
keyName key =
    -- TODO: handle modes other than Major
    if key.fifths > 0 then
        Maybe.withDefault C <|
            Array.get key.fifths sharpKeyNames

    else
        Maybe.withDefault C <|
            Array.get (abs key.fifths) flatKeyNames


flatKeys : Array.Array String
flatKeys =
    Array.fromList [ "C", "F", "B♭", "E♭", "A♭", "D♭", "G♭" ]


sharpKeys : Array.Array String
sharpKeys =
    Array.fromList [ "C", "G", "D", "A", "E", "B", "F♯" ]


displayName : Key -> String
displayName key =
    -- TODO: handle modes other than Major
    if key.fifths > 0 then
        Maybe.withDefault "C" <|
            Array.get key.fifths sharpKeys

    else
        Maybe.withDefault "C" <|
            Array.get (abs key.fifths) flatKeys


equal : Key -> Key -> Bool
equal akey bkey =
    akey.fifths
        == bkey.fifths
        && akey.mode
        == bkey.mode


sharpSteps : List Step
sharpSteps =
    [ Pitch.F, Pitch.C, Pitch.G, Pitch.D, Pitch.A, Pitch.E ]


flatSteps : List Step
flatSteps =
    [ Pitch.B, Pitch.E, Pitch.A, Pitch.D, Pitch.G, Pitch.C ]


stepAlteredIn : Key -> Step -> Semitones
stepAlteredIn key step =
    if key.fifths > 0 then
        if
            List.member step <|
                List.take key.fifths sharpSteps
        then
            1

        else
            0

    else if
        List.member step <|
            List.take (0 - key.fifths) flatSteps
    then
        -1

    else
        0


stepNumberToPitch : Key -> StepNumber -> Pitch
stepNumberToPitch key number =
    let
        octave =
            number // 7

        step =
            Pitch.stepFromNumber number

        alt =
            stepAlteredIn key step
    in
    Pitch step alt octave
