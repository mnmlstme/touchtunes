module Music.Models.Pitch exposing
    ( Pitch
    , Semitones
    , StepNumber
    , a
    , alter
    , b
    , c
    , d
    , doubleFlat
    ,  doubleSharp
       -- Basics.e is Euler's constant :(

    , e_
    , f
    , flat
    , fromStepNumber
    , g
    , natural
    , setAlter
    , sharp
    , stepAlteredIn
    , stepNumber
    , toString
    )

import Array
import Music.Models.Key as Key exposing (Key)
import String


type alias Pitch =
    { step : Step
    , alter : Semitones
    , octave : Octave
    }


type Step
    = A
    | B
    | C
    | D
    | E
    | F
    | G



-- StepNumber
-- assigns an integer to each (Octave, Step),
-- disregarding alterations.  Relates to position on staff.
-- NOT the same as MIDI Note number, which considers semitones


type alias StepNumber =
    Int


stepNumber : Pitch -> StepNumber
stepNumber p =
    let
        offset =
            case p.step of
                C ->
                    0

                D ->
                    1

                E ->
                    2

                F ->
                    3

                G ->
                    4

                A ->
                    5

                B ->
                    6
    in
    7 * p.octave + offset


stepFromNumber : Int -> Step
stepFromNumber n =
    let
        steps =
            Array.fromList [ C, D, E, F, G, A, B ]
    in
    case Array.get (modBy 7 n) steps of
        Just step ->
            step

        Nothing ->
            C


sharpSteps : List Step
sharpSteps =
    [ F, C, G, D, A, E ]


flatSteps : List Step
flatSteps =
    [ B, E, A, D, G, C ]


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


fromStepNumber : Key -> StepNumber -> Pitch
fromStepNumber key number =
    let
        octave =
            number // 7

        step =
            stepFromNumber number

        alt =
            stepAlteredIn key step
    in
    Pitch step alt octave



-- Semitones of alteration
-- typically from -2 (double-flat) to +2 (double-sharp)


type alias Semitones =
    Int


unaltered : Semitones
unaltered =
    0



-- Octaves
-- TODO: constrain to [0..9]


type alias Octave =
    Int


a : Octave -> Pitch
a =
    Pitch A unaltered


b : Octave -> Pitch
b =
    Pitch B unaltered


c : Octave -> Pitch
c =
    Pitch C unaltered


d : Octave -> Pitch
d =
    Pitch D unaltered


e_ : Octave -> Pitch
e_ =
    Pitch E unaltered


f : Octave -> Pitch
f =
    Pitch F unaltered


g : Octave -> Pitch
g =
    Pitch G unaltered


alter : Semitones -> (Octave -> Pitch) -> (Octave -> Pitch)
alter semi base =
    let
        alteration p =
            { p | alter = p.alter + semi }
    in
    \oct -> base oct |> alteration


natural : (Octave -> Pitch) -> (Octave -> Pitch)
natural =
    alter 0


sharp : (Octave -> Pitch) -> (Octave -> Pitch)
sharp =
    alter 1


flat : (Octave -> Pitch) -> (Octave -> Pitch)
flat =
    alter -1


doubleSharp : (Octave -> Pitch) -> (Octave -> Pitch)
doubleSharp =
    alter 2


doubleFlat : (Octave -> Pitch) -> (Octave -> Pitch)
doubleFlat =
    alter -2


setAlter : Semitones -> Pitch -> Pitch
setAlter semitones pitch =
    { pitch | alter = semitones }


toString : Pitch -> String
toString p =
    let
        step =
            case p.step of
                C ->
                    "C"

                D ->
                    "D"

                E ->
                    "E"

                F ->
                    "F"

                G ->
                    "G"

                A ->
                    "A"

                B ->
                    "B"

        alteration =
            if p.alter > 0 then
                "♯"

            else if p.alter < 0 then
                "♭"

            else
                ""

        times =
            abs p.alter

        octave =
            String.fromInt p.octave
    in
    step
        ++ String.repeat times alteration
        ++ octave
