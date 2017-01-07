module Music.Pitch
    exposing
        ( Pitch
        , a
        , b
        , c
        , d
          -- Basics.e is Euler's constant :(
        , e_
        , f
        , g
        , alter
        , flat
        , sharp
        , doubleFlat
        , doubleSharp
        , stepNumber
        , fromStepNumber
        , toString
        )

import Array


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
        case Array.get (n % 7) steps of
            Just step ->
                step

            Nothing ->
                C


fromStepNumber : StepNumber -> Pitch
fromStepNumber number =
    let
        octave =
            number // 7

        step =
            stepFromNumber number
    in
        Pitch step 0 octave



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


toString : Pitch -> String
toString p =
    let
        step =
            Basics.toString p.step

        alteration =
            -- TODO: use Unicode for flat/sharp
            if p.alter > 0 then
                "#"
            else if p.alter < 0 then
                "b"
            else
                ""

        times =
            abs p.alter

        octave =
            Basics.toString p.octave
    in
        step
            ++ String.repeat times alteration
            ++ octave
