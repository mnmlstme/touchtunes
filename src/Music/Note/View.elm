module Music.Note.View exposing (view)

import Music.Note.Model exposing (..)
import Music.Time as Time exposing (Time, Beat)
import Music.Duration as Duration
import Music.Measure.Layout
    exposing
        ( Layout
        , Pixels
        , xPx
        , x1Px
        , x2Px
        , yPx
        , y1Px
        , y2Px
        , heightPx
        , widthPx
        , spacing
        , scalePitch
        , scaleBeat
        , positionOnStaff
        )
import Svg
    exposing
        ( Svg
        , svg
        , g
        , line
        , use
        , text
        )
import Svg.Attributes
    exposing
        ( class
        , xlinkHref
        , transform
        )
import Music.Pitch as Pitch exposing (Pitch)


type StemOrientation
    = StemUp
    | StemDown


notehead : Time -> Note -> String
notehead time note =
    let
        b =
            beats time note
    in
        if b < 2 then
            "#tt-notehead-closed"
        else
            "#tt-notehead-open"


dotted : Time -> Note -> String
dotted time note =
    let
        b =
            beats time note
    in
        if b == 3 then
            "#tt-dot"
        else
            ""


alteration : Pitch -> String
alteration p =
    if p.alter > 0 then
        "#tt-sharp"
    else if p.alter < 0 then
        "#tt-flat"
    else
        ""


stemOrientation : Layout -> Pitch -> StemOrientation
stemOrientation layout p =
    let
        n =
            positionOnStaff layout p
    in
        if n > 3 then
            StemDown
        else
            StemUp


view : Layout -> Beat -> Note -> Svg msg
view layout beat note =
    let
        p =
            note.pitch

        d =
            note.duration

        sp =
            spacing layout

        w =
            1.5 * sp.px |> Pixels

        ypos =
            scalePitch layout p

        xpos =
            scaleBeat layout beat

        position =
            String.join ","
                (List.map toString [ xpos.px - w.px / 2.0, ypos.px ])

        isWhole =
            Duration.isWhole layout.time d

        stemLength =
            3.0 * sp.px |> Pixels

        stemDir =
            stemOrientation layout p

        xstem =
            case stemDir of
                StemUp ->
                    w

                StemDown ->
                    Pixels 0

        y1stem =
            case stemDir of
                StemUp ->
                    Pixels <| 0.25 * sp.px

                StemDown ->
                    Pixels <| 0.75 * sp.px

        y2stem =
            case stemDir of
                StemUp ->
                    Pixels <| y1stem.px - stemLength.px

                StemDown ->
                    Pixels <| y1stem.px + stemLength.px

        noteSymbol =
            notehead layout.time note

        dotSymbol =
            dotted layout.time note

        altSymbol =
            alteration p
    in
        g
            [ class "note"
            , transform ("translate(" ++ position ++ ")")
            ]
            [ use
                [ xlinkHref noteSymbol
                , xPx <| Pixels 0
                , yPx <| Pixels 0
                , heightPx sp
                , widthPx w
                ]
                []
            , if isWhole then
                text ""
              else
                line
                    [ class "note-stem"
                    , x1Px xstem
                    , y1Px y1stem
                    , x2Px xstem
                    , y2Px y2stem
                    ]
                    []
            , if altSymbol == "" then
                text ""
              else
                use
                    [ xlinkHref altSymbol
                    , xPx <| Pixels -w.px
                    , yPx <| Pixels 0
                    , heightPx sp
                    , widthPx w
                    ]
                    []
            , if dotSymbol == "" then
                text ""
              else
                use
                    [ xlinkHref dotSymbol
                    , xPx w
                    , yPx <| Pixels 0
                    , heightPx sp
                    , widthPx sp
                    ]
                    []
            ]
