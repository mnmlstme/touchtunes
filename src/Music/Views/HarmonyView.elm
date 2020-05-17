module Music.Views.HarmonyView exposing (chromaticSymbol, view)

import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class, style)
import Music.Models.Harmony as Harmony exposing (Alteration(..), Chord(..), Harmony, Kind(..))
import Music.Models.Key exposing (stepAlteredIn)
import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , halfSpacing
        , margins
        , positionOnStaff
        , scaleBeat
        , scalePitch
        , spacing
        , toPixels
        )
import Music.Models.Pitch as Pitch
    exposing
        ( Chromatic(..)
        , Pitch
        , Semitones
        , chromatic
        )
import Music.Views.HarmonyStyles exposing (css)
import Music.Views.Symbols as Symbols exposing (Symbol, glyph)
import String exposing (fromInt)


chromaticSymbol : Semitones -> Maybe Symbol
chromaticSymbol alt =
    case chromatic alt of
        Just chr ->
            case chr of
                DoubleFlat ->
                    Just Symbols.doubleFlat

                Flat ->
                    Just Symbols.flat

                Natural ->
                    Nothing

                Sharp ->
                    Just Symbols.sharp

                DoubleSharp ->
                    Just Symbols.doubleSharp

        Nothing ->
            Nothing


degreeNumber : Chord -> Maybe String
degreeNumber chord =
    case chord of
        Triad ->
            Nothing

        Sixth ->
            Just "6"

        Seventh ->
            Just "7"

        Ninth ->
            Just "9"

        Eleventh ->
            Just "11"

        Thirteenth ->
            Just "13"


viewKind : Kind -> Html msg
viewKind kind =
    let
        ( k, d ) =
            case kind of
                Major c ->
                    ( if c == Triad then
                        Nothing

                      else
                        Just "Maj"
                    , degreeNumber c
                    )

                Minor c ->
                    ( Just "m", degreeNumber c )

                Diminished c ->
                    ( Just "dim", degreeNumber c )

                Augmented c ->
                    ( Just "aug", degreeNumber c )

                Dominant c ->
                    ( Nothing, degreeNumber c )

                HalfDiminished ->
                    -- flat 5 added later
                    ( Just "m", degreeNumber Seventh )

                MajorMinor ->
                    -- maj 7 added later
                    ( Just "m", Nothing )

                Power ->
                    ( Nothing, Just "5" )
    in
    span []
        [ Maybe.withDefault (text "") <|
            Maybe.map (\s -> span [ class (css .kind) ] [ text s ]) k
        , Maybe.withDefault (text "") <|
            Maybe.map (\s -> span [ class (css .degree) ] [ text s ]) d
        ]


viewAlteration : Alteration -> Html msg
viewAlteration alteration =
    case alteration of
        Sus n ->
            span [ class (css .alt) ] [ text <| "Sus" ++ fromInt n ]

        Add n ->
            span [ class (css .alt) ] [ text <| "Add" ++ fromInt n ]

        No n ->
            span [ class (css .alt) ] [ text <| "No" ++ fromInt n ]

        Raised n ->
            span [ class (css .alt) ]
                [ text "("
                , glyph Symbols.sharp
                , text <| fromInt n
                , text ")"
                ]

        Lowered n ->
            span [ class (css .alt) ]
                [ text "("
                , glyph Symbols.flat
                , text <| fromInt n
                , text ")"
                ]

        Altered s n ->
            span [ class (css .alt) ] [ text <| "(" ++ s ++ fromInt n ++ ")" ]


view : Layout -> Harmony -> Html msg
view layout harmony =
    let
        root =
            harmony.root

        chsym =
            chromaticSymbol root.alter

        alterations =
            harmony.alter
    in
    div
        [ class (css .harmony)
        ]
        [ span [ class (css .root) ]
            [ text <| Pitch.stepToString root.step ]
        , Maybe.withDefault (text "") <|
            Maybe.map (\s -> span [ class (css .chromatic) ] [ glyph s ]) chsym
        , viewKind harmony.kind
        , if List.isEmpty alterations then
            text ""

          else
            span [ class (css .altList) ] <|
                List.map
                    viewAlteration
                    alterations
        ]
