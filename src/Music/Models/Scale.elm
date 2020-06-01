module Music.Models.Scale exposing (Scale, chromatic, major, note)

import Array exposing (Array)
import Music.Models.Key as Key exposing (Key)
import Music.Models.Pitch as Pitch exposing (Chromatic(..), Root, Semitones, Step(..), root)


type alias Scale =
    Array Root


chromatic : Root -> Scale
chromatic =
    fromList [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ]


major : Root -> Scale
major =
    fromList [ 0, 2, 4, 5, 7, 9, 11 ]


note : Int -> Scale -> Maybe Root
note i =
    Array.get (i - 1)


fromList : List Int -> Root -> Scale
fromList list tonic =
    Array.fromList <|
        List.map
            (step tonic)
            list


step : Root -> Semitones -> Root
step r t =
    let
        semis =
            modBy 12 <| rootSemis r + t
    in
    case Array.get semis chromaticScale of
        Just theRoot ->
            theRoot

        Nothing ->
            root Pitch.C Natural


chromaticScale =
    Array.fromList
        [ root Pitch.C Natural
        , root Pitch.C Sharp
        , root Pitch.D Natural
        , root Pitch.E Flat
        , root Pitch.E Natural
        , root Pitch.F Natural
        , root Pitch.F Sharp
        , root Pitch.G Natural
        , root Pitch.A Flat
        , root Pitch.A Natural
        , root Pitch.B Flat
        , root Pitch.B Natural
        ]


rootSemis : Root -> Semitones
rootSemis r =
    let
        stepsemis =
            case r.step of
                C ->
                    0

                D ->
                    2

                E ->
                    4

                F ->
                    5

                G ->
                    7

                A ->
                    9

                B ->
                    11
    in
    modBy 12 <| stepsemis + r.alter
