module Music.Models.Key exposing
    ( Key
    , KeyName(..)
    , Mode(..)
    , displayName
    , equal
    , flats
    , keyName
    , keyOf
    , sharps
    )

import Array as Array


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


flatKeyNames =
    Array.fromList [ C, F, Bflat, Eflat, Aflat, Dflat, Gflat ]


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


flatKeys =
    Array.fromList [ "C", "F", "B♭", "E♭", "A♭", "D♭", "G♭" ]


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
