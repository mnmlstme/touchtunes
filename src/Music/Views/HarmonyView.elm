module Music.Views.HarmonyView exposing
    ( chromaticSymbol
    , degreeNumber
    , kindString
    , view
    , viewAlterationList
    , viewBass
    , viewDegree
    , viewKind
    , viewKindString
    , viewRoot
    )

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
        , Root
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


viewDegree : String -> Html msg
viewDegree s =
    span [ class (css .degree) ] [ text s ]


kindString : Kind -> Maybe String
kindString kind =
    case kind of
        Major c ->
            if c == Triad then
                Nothing

            else
                Just "Maj"

        Minor c ->
            Just "m"

        Diminished c ->
            Just "o"

        Augmented c ->
            Just "+"

        Dominant c ->
            Nothing

        HalfDiminished ->
            Just "ø"

        MajorMinor ->
            -- maj 7 added later
            Just "m"

        Power ->
            Nothing


viewKindString : String -> Html msg
viewKindString s =
    span [] [ text s ]


viewKind : Kind -> Html msg
viewKind kind =
    span [ class (css .kind) ]
        [ Maybe.withDefault (text "") <|
            Maybe.map viewKindString <|
                kindString kind
        , Maybe.withDefault (text "") <|
            Maybe.map viewDegree <|
                case kind of
                    Major c ->
                        degreeNumber c

                    Minor c ->
                        degreeNumber c

                    Diminished c ->
                        degreeNumber c

                    Augmented c ->
                        degreeNumber c

                    Dominant c ->
                        degreeNumber c

                    HalfDiminished ->
                        Just "7"

                    MajorMinor ->
                        -- maj 7 added later
                        Nothing

                    Power ->
                        Just "5"
        ]


viewAlterationList : List Alteration -> Html msg
viewAlterationList alterationList =
    span [ class (css .altList) ] <|
        List.map
            viewAlteration
            alterationList


viewAlteration : Alteration -> Html msg
viewAlteration alteration =
    case alteration of
        Sus n ->
            span [ class (css .alt) ] [ text <| "sus" ++ fromInt n ]

        Add n ->
            span [ class (css .alt) ] [ text <| "add" ++ fromInt n ]

        No n ->
            span [ class (css .alt) ] [ text <| "no" ++ fromInt n ]

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


viewRoot : Root -> Html msg
viewRoot root =
    let
        chsym =
            chromaticSymbol root.alter
    in
    span [ class (css .root) ]
        [ text <| Pitch.stepToString root.step
        , Maybe.withDefault (text "") <|
            Maybe.map (\s -> span [ class (css .chromatic) ] [ glyph s ]) chsym
        ]


viewBass : Maybe Root -> Html msg
viewBass bass =
    case bass of
        Just r ->
            span [ class (css .over) ]
                [ text "/"
                , viewRoot r
                ]

        Nothing ->
            text ""


view : Harmony -> Html msg
view harmony =
    div
        [ class (css .harmony) ]
        [ viewRoot harmony.root
        , viewKind harmony.kind
        , if List.isEmpty harmony.alter then
            text ""

          else
            viewAlterationList harmony.alter
        , viewBass harmony.bass
        ]
