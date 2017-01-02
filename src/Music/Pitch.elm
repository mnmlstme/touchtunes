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
        , flat
        , sharp
        , toString
        )


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


a : Int -> Pitch
a =
    Pitch A unaltered


b : Int -> Pitch
b =
    Pitch B unaltered


c : Int -> Pitch
c =
    Pitch C unaltered


d : Int -> Pitch
d =
    Pitch D unaltered


e_ : Int -> Pitch
e_ =
    Pitch E unaltered


f : Int -> Pitch
f =
    Pitch F unaltered


g : Int -> Pitch
g =
    Pitch G unaltered


sharp : Pitch -> Pitch
sharp p =
    { p | alter = p.alter + 1 }


flat : Pitch -> Pitch
flat p =
    { p | alter = p.alter - 1 }


toString : Pitch -> String
toString p =
    let
        step =
            Basics.toString p.step

        alteration =
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
