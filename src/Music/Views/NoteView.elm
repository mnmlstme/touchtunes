module Music.Views.NoteView exposing
    ( StemOrientation(..)
    , accidental
    , alteration
    , isWhole
    , draw
    , drawNote
    , drawRest
    )

import Html.Attributes as HtmlAttr exposing (style)
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration)
import Music.Models.Key exposing (Key, stepAlteredIn)
import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , margins
        , positionOnStaff
        , scaleBeat
        , scalePitch
        , spacing
        )
import Music.Models.Note exposing (..)
import Music.Models.Pitch
    exposing
        ( Chromatic(..)
        , Pitch
        , chromatic
        )
import Music.Models.Time as Time exposing (Time)
import Music.Views.HarmonyView as HarmonyView
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
        , text
        , text_
        , use
        )
import Svg.Attributes
    exposing
        ( class
        , height
        , transform
        , viewBox
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


alteration : Chromatic -> Symbol
alteration chr =
    case chr of
        DoubleFlat ->
            Symbols.doubleFlat

        Flat ->
            Symbols.flat

        Natural ->
            Symbols.natural

        Sharp ->
            Symbols.sharp

        DoubleSharp ->
            Symbols.doubleSharp


accidental : Key -> Pitch -> Maybe Symbol
accidental key p =
    if stepAlteredIn key p.step == p.alter then
        Nothing

    else
        Maybe.map alteration <| chromatic p.alter


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


draw : Layout -> Beat -> Note -> Svg msg
draw layout beat note =
    let
        h =
            Layout.height layout

        d =
            note.duration

        m =
            margins layout

        xpos =
            scaleBeat layout <|
                notePlacement (Layout.time layout) d beat

        x0 =
            scaleBeat layout beat
    in
    g
        [ class (css .note)
        , transform <| "translate(" ++ fromFloat x0.px ++ ",0)"
        ]
        [ g
          [ transform <|
                "translate("
                    ++ fromFloat (xpos.px - x0.px)
                    ++ ",0)"
          ]
          [ case note.do of
                Play p ->
                    drawNote layout d p

                Rest ->
                    drawRest layout d
          ]
        , g [transform <| "translate(0," ++ fromFloat (0.5 * m.top.px) ++ ")"]
            [ Maybe.withDefault (text "") <|
                Maybe.map HarmonyView.draw note.harmony
            ]
        ]


drawRest : Layout -> Duration -> Svg msg
drawRest layout d =
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
        , drawDot d
        ]


drawNote : Layout -> Duration -> Pitch -> Svg msg
drawNote layout d p =
    let
        ypos =
            scalePitch layout p

        note =
            noteHead d

        stem =
            noteStem layout d p

        ledgers =
            ledgerLines layout p

        alt =
            accidental (Layout.key layout) p

        drawLedger y =
            g [ transform ("translate(0," ++ fromFloat y.px ++ ")") ]
                [ Symbols.view ledgerLine ]
    in
    g
        [ transform ("translate(0," ++ fromFloat ypos.px ++ ")")
        ]
        [ Symbols.view note
        , drawDot d
        , case stem of
            Just theStem ->
                Symbols.view theStem

            Nothing ->
                text_ [] []
        , g []
            (List.map drawLedger ledgers)
        , case alt of
            Just theAlt ->
                Symbols.view <|
                    Symbols.rightAlign 0 theAlt

            Nothing ->
                text_ [] []
        ]


drawDot : Duration -> Svg msg
drawDot d =
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
