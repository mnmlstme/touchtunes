module Music.Models.Key exposing
    ( Key
    , KeyName(..)
    , Mode(..)
    , flats
    , keyOf
    , sharps
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

        shift =
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

        normalized =
            -- bring back to [-5, 6]
            modBy 12 (fifths + shift + 17) - 5
    in
    Key normalized mode


equal : Key -> Key -> Bool
equal akey bkey =
    akey.fifths
        == bkey.fifths
        && akey.mode
        == bkey.mode
