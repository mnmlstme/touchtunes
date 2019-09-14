module Music.Note.View exposing (view, viewNote, StemOrientation(..))

import Music.Duration as Duration exposing (Duration, isWhole)
import Music.Measure.Layout
    exposing
        ( Layout
        , Pixels
        , halfSpacing
        , heightPx
        , margins
        , positionOnStaff
        , scaleBeat
        , scalePitch
        , spacing
        , toPixels
        , widthPx
        , x1Px
        , x2Px
        , xPx
        , y1Px
        , y2Px
        , yPx
        )
import Music.Note.Model exposing (..)
import Music.Pitch as Pitch exposing (Pitch)
import Music.Time as Time exposing (Beat, Time)
import Icon.SvgAsset as SvgAsset exposing (svgAsset, SvgAsset)
import CssModules exposing (css)
import Svg
    exposing
        ( Svg
        , g
        , line
        , svg
        , text
        , use
        )
import Svg.Attributes
    exposing
        ( class
        , transform
        , xlinkHref
        )
import String


type StemOrientation
    = StemUp
    | StemDown


wholeRest =
    svgAsset "./Music/Note/tt-rest-whole.svg"


halfRest =
    svgAsset "./Music/Note/tt-rest-half.svg"


quarterRest =
    svgAsset "./Music/Note/tt-rest-quarter.svg"


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


notehead : Duration -> SvgAsset
notehead d =
    let
        b =
            d.count
    in
        if b < 2 then
            noteheadClosed
        else
            noteheadOpen


restSymbol : Duration -> SvgAsset
restSymbol d =
    let
        b =
            d.count
    in
        if isWhole d then
            wholeRest
        else if b < 2 then
            quarterRest
        else
            halfRest


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


stemOrientation : Layout -> Pitch -> StemOrientation
stemOrientation layout p =
    let
        n =
            positionOnStaff layout p
    in
        if n > -3 then
            StemDown
        else
            StemUp


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


styles =
    css "./Music/Note/note.css"
        { note = "note"
        , rest = "rest"
        , stem = "stem"
        , ledger = "ledger"
        , blank = "blank"
        }


view : Layout -> Beat -> Note -> Svg msg
view layout beat note =
    let
        d =
            note.duration

        xpos =
            scaleBeat layout beat

        dx =
            case getShiftX note of
                Just tenths ->
                    toPixels layout tenths

                Nothing ->
                    Pixels 0

        position =
            String.join ","
                (List.map String.fromFloat
                    [ xpos.px + dx.px
                    , 0
                    ]
                )

        className =
            case note.do of
                Play _ ->
                    .note

                Rest ->
                    .rest
    in
        g
            [ class <| styles.toString className
            , transform ("translate(" ++ position ++ ")")
            ]
            [ case note.do of
                Play p ->
                    viewPitch layout beat d p

                Rest ->
                    viewRest layout beat d
            ]


viewRest : Layout -> Beat -> Duration -> Svg msg
viewRest layout beat d =
    let
        sp =
            spacing layout

        m =
            margins layout

        w =
            Pixels <| 1.5 * sp.px

        h =
            Pixels <| 4.0 * sp.px

        position =
            String.join ","
                (List.map String.fromFloat
                    [ 0.0
                    , m.top.px + 2.0 * sp.px
                    ]
                )

        rest =
            restSymbol d
    in
        g
            [ transform ("translate(" ++ position ++ ")")
            ]
            [ SvgAsset.view rest
            , viewDot d
            ]


viewPitch : Layout -> Beat -> Duration -> Pitch -> Svg msg
viewPitch layout beat d p =
    let
        sp =
            spacing layout

        w =
            1.5 * sp.px |> Pixels

        ypos =
            scalePitch layout p

        position =
            String.join ","
                (List.map String.fromFloat
                    [ 0
                    , ypos.px
                    ]
                )

        stemDir =
            stemOrientation layout p

        ledgers =
            ledgerLines layout p

        alt =
            alteration p

        viewLedger y =
            line
                [ x1Px <| Pixels <| -0.35 * w.px
                , x2Px <| Pixels <| 1.35 * w.px
                , y1Px <| y
                , y2Px <| y
                ]
                []
    in
        g
            [ transform ("translate(" ++ position ++ ")")
            ]
            [ viewNote d stemDir
            , g [ class <| styles.toString .ledger ]
                (List.map viewLedger ledgers)
            , case alt of
                Just theAlt ->
                    SvgAsset.view <|
                        SvgAsset.rightAlign 0 theAlt

                Nothing ->
                    text ""
            ]


viewNote : Duration -> StemOrientation -> Svg msg
viewNote d stemDir =
    let
        sp =
            20.0

        w =
            1.5 * sp

        stemLength =
            3.0 * sp

        note =
            notehead d

        isWhole =
            Duration.isWhole d

        xstem =
            case stemDir of
                StemUp ->
                    0.5 * w |> Pixels

                StemDown ->
                    -0.5 * w |> Pixels

        y1stem =
            case stemDir of
                StemUp ->
                    Pixels <| -0.25 * sp

                StemDown ->
                    Pixels <| 0.25 * sp

        y2stem =
            case stemDir of
                StemUp ->
                    Pixels <| y1stem.px - stemLength

                StemDown ->
                    Pixels <| y1stem.px + stemLength
    in
        g
            []
            [ SvgAsset.view note
            , if isWhole then
                text ""
              else
                line
                    [ class <| styles.toString .stem
                    , x1Px xstem
                    , y1Px y1stem
                    , x2Px xstem
                    , y2Px y2stem
                    ]
                    []
            , viewDot d
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
                text ""
