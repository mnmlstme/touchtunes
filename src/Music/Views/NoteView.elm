module Music.Views.NoteView exposing
    ( StemOrientation(..)
    , accidental
    , alteration
    , isWhole
    , view
    , viewNote
    )

import Debug exposing (log)
import Dict exposing (Dict)
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Key as Key exposing (Key)
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
import Music.Models.Note exposing (..)
import Music.Models.Pitch as Pitch exposing (Pitch, Semitones, stepAlteredIn)
import Music.Models.Time as Time exposing (Time)
import Music.Views.NoteStyles exposing (css)
import Music.Views.Symbols as Symbols
    exposing
        ( Symbol
        , eighthRest
        , flat
        , halfRest
        , ledgerLine
        , noteheadClosed
        , noteheadOpen
        , quarterRest
        , sharp
        , singleDot
        , stemDown
        , stemDown1Flag
        , stemUp
        , stemUp1Flag
        , wholeRest
        )
import String exposing (fromFloat)
import Svg
    exposing
        ( Svg
        , g
        , line
        , svg
        , text_
        , use
        )
import Svg.Attributes
    exposing
        ( class
        , height
        , transform
        , width
        , x
        , x1
        , x2
        , xlinkHref
        , y
        , y1
        , y2
        )


type StemOrientation
    = StemUp
    | StemDown


isWhole : Duration -> Bool
isWhole d =
    d.count // d.divisor == 1


noteHead : Duration -> Symbol
noteHead d =
    if toFloat d.divisor / toFloat d.count > 2.0 then
        noteheadClosed

    else
        noteheadOpen


noteStem : Layout -> Duration -> Pitch -> Maybe Symbol
noteStem layout d p =
    let
        down =
            positionOnStaff layout p > -3
    in
    if isWhole d then
        Nothing

    else if toFloat d.divisor / toFloat d.count > 4.0 then
        Just
            (if down then
                stemDown1Flag

             else
                stemUp1Flag
            )

    else
        Just
            (if down then
                stemDown

             else
                stemUp
            )


restSymbol : Duration -> Symbol
restSymbol d =
    let
        div =
            toFloat d.divisor / toFloat d.count
    in
    if div <= 1.0 then
        wholeRest

    else if div <= 2.0 then
        halfRest

    else if div <= 4.0 then
        quarterRest

    else
        eighthRest


dotted : Duration -> Maybe Symbol
dotted d =
    let
        b =
            d.count
    in
    if b == 3 then
        Just singleDot

    else
        Nothing


alterationSymbols : Dict Int Symbol
alterationSymbols =
    Dict.fromList
        [ ( -2, Symbols.doubleFlat )
        , ( -1, Symbols.flat )
        , ( 0, Symbols.natural )
        , ( 1, Symbols.sharp )
        , ( 2, Symbols.doubleSharp )
        ]


alteration : Semitones -> Maybe Symbol
alteration alt =
    Dict.get alt alterationSymbols


accidental : Key -> Pitch -> Maybe Symbol
accidental key p =
    if stepAlteredIn key p.step == p.alter then
        Nothing

    else
        alteration p.alter


ledgerLines : Layout -> Pitch -> List Pixels
ledgerLines layout p =
    let
        sp =
            spacing layout

        n =
            positionOnStaff layout p

        isAbove =
            n > 2

        isBelow =
            n < -8

        lineOffset =
            if isAbove then
                2 - modBy 2 n

            else
                modBy 2 n

        isEven num =
            modBy 2 num == 0

        steps =
            if n > 2 then
                List.range 0 (n - 3)

            else if n < -8 then
                List.range (n + 9) 0

            else
                []

        spaces =
            List.filter isEven steps

        spaceToPixels i =
            Pixels (toFloat (i + lineOffset - 1) * sp.px / 2)
    in
    List.map spaceToPixels spaces


notePlacement : Time -> Duration -> Beat -> Beat
notePlacement time dur beat =
    -- place the note in the center of its duration
    let
        half =
            if dur.divisor > Time.divisor time then
                Duration.divideBy 2 dur

            else
                Beat.toDuration time (Beat.halfBeat 1)
    in
    Beat.add time half beat


view : Layout -> Beat -> Note -> Svg msg
view layout beat note =
    let
        d =
            note.duration

        xpos =
            scaleBeat layout <|
                notePlacement (Layout.time layout) d beat
    in
    g
        [ class (css .note)
        , transform ("translate(" ++ fromFloat xpos.px ++ ",0)")
        ]
        [ case note.do of
            Play p ->
                viewNote layout d p

            Rest ->
                viewRest layout d
        ]


viewRest : Layout -> Duration -> Svg msg
viewRest layout d =
    let
        sp =
            spacing layout

        m =
            margins layout

        rest =
            restSymbol d
    in
    g
        [ transform
            ("translate(0,"
                ++ fromFloat (m.top.px + 2.0 * sp.px)
                ++ ")"
            )
        ]
        [ Symbols.view rest
        , viewDot d
        ]


viewNote : Layout -> Duration -> Pitch -> Svg msg
viewNote layout d p =
    let
        sp =
            spacing layout

        w =
            1.5 * sp.px

        ypos =
            scalePitch layout p

        position =
            String.join ","
                (List.map String.fromFloat
                    [ 0
                    , ypos.px
                    ]
                )

        note =
            noteHead d

        stem =
            noteStem layout d p

        ledgers =
            ledgerLines layout p

        alt =
            accidental (Layout.key layout) p

        viewLedger y =
            g [ transform ("translate(0," ++ fromFloat y.px ++ ")") ]
                [ Symbols.view ledgerLine ]
    in
    g
        [ transform ("translate(0," ++ fromFloat ypos.px ++ ")")
        ]
        [ Symbols.view note
        , viewDot d
        , case stem of
            Just theStem ->
                Symbols.view theStem

            Nothing ->
                text_ [] []
        , g []
            (List.map viewLedger ledgers)
        , case alt of
            Just theAlt ->
                Symbols.view <|
                    Symbols.rightAlign 0 theAlt

            Nothing ->
                text_ [] []
        ]


viewDot : Duration -> Svg msg
viewDot d =
    let
        sp =
            20.0

        xOffset =
            0.75 * sp

        dot =
            dotted d
    in
    case dot of
        Just theDot ->
            Symbols.view <|
                Symbols.leftAlign xOffset theDot

        Nothing ->
            text_ [] []
