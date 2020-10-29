module Music.Views.HarmonyView exposing
    ( chromaticSymbol
    , degreeNumber
    , kindString
    , draw
    , drawAlterationList
    , drawBass
    , drawDegree
    , drawKind
    , drawKindString
    , drawRoot
    )

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
import Svg exposing (Svg, g, svg, text, text_)
import Svg.Attributes exposing (class, transform)


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


drawDegree : String -> Svg msg
drawDegree s =
    text_ [ class (css .degree) ] [ text s ]


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


drawKindString : String -> Svg msg
drawKindString s =
    text_ [] [ text s ]


drawKind : Kind -> Svg msg
drawKind kind =
    g [ class (css .kind) ]
        [ Maybe.withDefault (text "") <|
            Maybe.map drawKindString <|
                kindString kind
        , Maybe.withDefault (text "") <|
            Maybe.map drawDegree <|
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


drawAlterationList : List Alteration -> Svg msg
drawAlterationList alterationList =
    g [ class (css .altList) ] <|
        List.map
            drawAlteration
            alterationList


drawAlteration : Alteration -> Svg msg
drawAlteration alteration =
    case alteration of
        Sus n ->
            text_ [ class (css .alt) ] [ text <| "Sus" ++ fromInt n ]

        Add n ->
            text_ [ class (css .alt) ] [ text <| "Add" ++ fromInt n ]

        No n ->
            text_ [ class (css .alt) ] [ text <| "no" ++ fromInt n ]

        Raised n ->
            g [ class (css .alt) ]
                [ text_ [] [text <| "( " ++ fromInt n ++ ")"]
                , Symbols.view Symbols.sharp
                ]

        Lowered n ->
            g [ class (css .alt) ]
                [ text_ [] [text <| "( " ++ fromInt n ++ ")"]
                , Symbols.view Symbols.flat
                ]

        Altered s n ->
            text_ [ class (css .alt) ] [ text <| "(" ++ s ++ fromInt n ++ ")" ]


drawRoot : Root -> Svg msg
drawRoot root =
    let
        chsym =
            chromaticSymbol root.alter
    in
    g [ class (css .root) ]
        [ text_ [] [text <| Pitch.stepToString root.step]
        , Maybe.withDefault (text "") <|
            Maybe.map
                (\s -> g [ class (css .chromatic) ] [ Symbols.view s ])
                chsym
        ]


drawBass : Maybe Root -> Svg msg
drawBass bass =
    case bass of
        Just r ->
            text_ [ class (css .over) ]
                [ text_ [] [text "/"]
                , drawRoot r
                ]

        Nothing ->
            text ""


draw : Harmony -> Svg msg
draw harmony =
    g
        [ class (css .harmony) ]
        [ drawRoot harmony.root
        , drawKind harmony.kind
        , if List.isEmpty harmony.alter then
            text ""

          else
            drawAlterationList harmony.alter
        , drawBass harmony.bass
        ]
