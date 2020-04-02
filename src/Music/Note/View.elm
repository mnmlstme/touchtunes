module Music.Note.View exposing
    ( StemOrientation(..)
    , isWhole
    , view
    , viewNote
    )

import CssModules as CssModules
import Debug exposing (log)
import Icon.SvgAsset as SvgAsset exposing (SvgAsset, svgAsset)
import Music.Beat as Beat exposing (Beat)
import Music.Duration as Duration exposing (Duration)
import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , halfSpacing
        , inPx
        , margins
        , positionOnStaff
        , scaleBeat
        , scalePitch
        , spacing
        , toPixels
        )
import Music.Note.Model exposing (..)
import Music.Pitch as Pitch exposing (Pitch)
import Music.Time as Time exposing (Time)
import String
import TypedSvg
    exposing
        ( g
        , line
        , svg
        , text_
        , use
        )
import TypedSvg.Attributes
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
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Transform(..), px)


type StemOrientation
    = StemUp
    | StemDown


wholeRest =
    svgAsset "./Music/Note/tt-rest-whole.svg"


halfRest =
    svgAsset "./Music/Note/tt-rest-half.svg"


quarterRest =
    svgAsset "./Music/Note/tt-rest-quarter.svg"


eighthRest =
    svgAsset "./Music/Note/tt-rest-eighth.svg"


noteheadClosed =
    svgAsset "./Music/Note/tt-notehead-closed.svg"


noteheadOpen =
    svgAsset "./Music/Note/tt-notehead-open.svg"


singleDot =
    svgAsset "./Music/Note/tt-dot.svg"


sharp =
    svgAsset "./Music/Note/tt-sharp.svg"


flat =
    svgAsset "./Music/Note/tt-flat.svg"


ledgerLine =
    svgAsset "./Music/Note/tt-ledger-line.svg"


stemUp =
    svgAsset "./Music/Note/tt-stem-up.svg"


stemDown =
    svgAsset "./Music/Note/tt-stem-down.svg"


stemUp1Flag =
    svgAsset "./Music/Note/tt-stem-up-1flag.svg"


stemDown1Flag =
    svgAsset "./Music/Note/tt-stem-down-1flag.svg"


isWhole : Duration -> Bool
isWhole d =
    d.count // d.divisor == 1


noteHead : Duration -> SvgAsset
noteHead d =
    if toFloat d.divisor / toFloat d.count > 2.0 then
        noteheadClosed

    else
        noteheadOpen


noteStem : Layout -> Duration -> Pitch -> Maybe SvgAsset
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


restSymbol : Duration -> SvgAsset
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


dotted : Duration -> Maybe SvgAsset
dotted d =
    let
        b =
            d.count
    in
    if b == 3 then
        Just singleDot

    else
        Nothing


alteration : Pitch -> Maybe SvgAsset
alteration p =
    if p.alter > 0 then
        Just sharp

    else if p.alter < 0 then
        Just flat

    else
        Nothing


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


css =
    .toString <|
        CssModules.css "./Music/Note/note.css"
            { note = "note"
            , rest = "rest"
            , stem = "stem"
            , ledger = "ledger"
            , blank = "blank"
            }


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

        className =
            case note.do of
                Play _ ->
                    css .note

                Rest ->
                    css .rest
    in
    g
        [ class [ className ]
        , transform [ Translate xpos.px 0 ]
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
        [ transform [ Translate 0 (m.top.px + 2.0 * sp.px) ]
        ]
        [ SvgAsset.view rest
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
            alteration p

        viewLedger y =
            g [ transform [ Translate 0 y.px ] ]
                [ SvgAsset.view ledgerLine ]
    in
    g
        [ transform [ Translate 0 ypos.px ]
        ]
        [ SvgAsset.view note
        , viewDot d
        , case stem of
            Just theStem ->
                SvgAsset.view theStem

            Nothing ->
                text_ [] []
        , g [ class [ css .ledger ] ]
            (List.map viewLedger ledgers)
        , case alt of
            Just theAlt ->
                SvgAsset.view <|
                    SvgAsset.rightAlign 0 theAlt

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
            SvgAsset.view <|
                SvgAsset.leftAlign xOffset theDot

        Nothing ->
            text_ [] []
