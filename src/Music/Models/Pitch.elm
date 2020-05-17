module Music.Models.Pitch exposing
    ( Chromatic(..)
    , Pitch
    , Root
    , Semitones
    , Step(..)
    , StepNumber
    , a
    , alter
    , b
    , c
    , chromatic
    , d
    , doubleFlat
    ,  doubleSharp
       -- Basics.e is Euler's constant :(

    , e_
    , f
    , flat
    , g
    , natural
    , pitch
    , root
    , semitones
    , setAlter
    , sharp
    , stepFromNumber
    , stepNumber
    , stepToString
    , toString
    )

import Array
import String


type Step
    = A
    | B
    | C
    | D
    | E
    | F
    | G


type Chromatic
    = DoubleFlat
    | DoubleSharp
    | Flat
    | Natural
    | Sharp


type alias Semitones =
    Int


semitones : Chromatic -> Semitones
semitones chr =
    case chr of
        DoubleFlat ->
            -2

        DoubleSharp ->
            2

        Flat ->
            -1

        Sharp ->
            1

        Natural ->
            0


chromatic : Semitones -> Maybe Chromatic
chromatic semi =
    case abs semi of
        0 ->
            Just Natural

        1 ->
            Just
                (if semi > 0 then
                    Sharp

                 else
                    Flat
                )

        2 ->
            Just
                (if semi > 0 then
                    DoubleSharp

                 else
                    DoubleFlat
                )

        _ ->
            Nothing


type alias Root =
    { step : Step
    , alter : Semitones
    }


root : Step -> Chromatic -> Root
root step chr =
    Root step <| semitones chr


type alias Pitch =
    { step : Step
    , alter : Semitones
    , octave : Octave
    }


pitch : Step -> Chromatic -> Octave -> Pitch
pitch step chr oct =
    Pitch step (semitones chr) oct



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


setAlter : Chromatic -> Pitch -> Pitch
setAlter chr p =
    { p | alter = semitones chr }


stepToString : Step -> String
stepToString s =
    case s of
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


toString : Pitch -> String
toString p =
    let
        step =
            stepToString p.step

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
