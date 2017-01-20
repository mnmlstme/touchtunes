module Music.Note.View exposing (view)

import Music.Note.Model exposing (..)
import Music.Time as Time exposing (Time, Beat)
import Music.Duration as Duration
import Music.Measure.Layout
    exposing
        ( Layout
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
        , height
        , width
        , x
        , x1
        , x2
        , y
        , y1
        , y2
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
            1.5 * sp

        ypos =
            (scalePitch layout) p

        xpos =
            (scaleBeat layout) beat - w / 2.0

        position =
            String.join ","
                (List.map toString [ xpos, ypos ])

        isWhole =
            Duration.isWhole layout.time d

        stemLength =
            3.0 * sp

        stemDir =
            stemOrientation layout p

        xstem =
            case stemDir of
                StemUp ->
                    w

                StemDown ->
                    0

        y1stem =
            case stemDir of
                StemUp ->
                    0.25 * sp

                StemDown ->
                    0.75 * sp

        y2stem =
            case stemDir of
                StemUp ->
                    y1stem - stemLength

                StemDown ->
                    y1stem + stemLength

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
                , x "0"
                , y "0"
                , height <| toString sp
                , width <| toString w
                ]
                []
            , if isWhole then
                text ""
              else
                line
                    [ class "note-stem"
                    , x1 <| toString xstem
                    , y1 <| toString y1stem
                    , x2 <| toString xstem
                    , y2 <| toString y2stem
                    ]
                    []
            , if altSymbol == "" then
                text ""
              else
                use
                    [ xlinkHref altSymbol
                    , x <| toString -w
                    , y "0"
                    , height <| toString sp
                    , width <| toString w
                    ]
                    []
            , if dotSymbol == "" then
                text ""
              else
                use
                    [ xlinkHref dotSymbol
                    , x <| toString w
                    , y "0"
                    , height <| toString sp
                    , width <| toString sp
                    ]
                    []
            ]
