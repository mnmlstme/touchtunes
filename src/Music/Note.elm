module Music.Note
    exposing
        ( Note
        , heldFor
        , beats
        , draw
        )

import Music.Time as Time exposing (Time, Beat)
import Music.Duration as Duration exposing (Duration)
import Music.Pitch as Pitch exposing (Pitch)
import Music.Layout
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
        , viewBox
        , x
        , x1
        , x2
        , y
        , y1
        , y2
        , xlinkHref
        , transform
        )


type alias Note =
    { pitch : Pitch
    , duration : Duration
    }


type StemOrientation
    = StemUp
    | StemDown


heldFor : Duration -> Pitch -> Note
heldFor d p =
    Note p d


beats : Time -> Note -> Beat
beats time note =
    Duration.beats time note.duration


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


draw : Layout -> Beat -> Note -> Svg msg
draw layout beat note =
    let
        noteSymbol =
            notehead layout.time note

        p =
            note.pitch

        altSymbol =
            if p.alter > 0 then
                "#tt-sharp"
            else if p.alter < 0 then
                "#tt-flat"
            else
                ""

        noteHeight =
            spacing layout

        noteWidth =
            1.5 * noteHeight

        ypos =
            (scalePitch layout) note.pitch

        xpos =
            (scaleBeat layout) beat - noteWidth / 2.0

        position =
            String.join ","
                (List.map toString [ xpos, ypos ])

        isWhole =
            Duration.isWhole layout.time note.duration

        stemLength =
            3.0 * noteHeight

        stemDir =
            stemOrientation layout p

        xstem =
            case stemDir of
                StemUp ->
                    noteWidth

                StemDown ->
                    0

        y1stem =
            case stemDir of
                StemUp ->
                    0.25 * noteHeight

                StemDown ->
                    0.75 * noteHeight

        y2stem =
            case stemDir of
                StemUp ->
                    y1stem - stemLength

                StemDown ->
                    y1stem + stemLength
    in
        g
            [ class "note"
            , transform ("translate(" ++ position ++ ")")
            ]
            [ use
                [ xlinkHref noteSymbol
                , x "0"
                , y "0"
                , height <| toString noteHeight
                , width <| toString noteWidth
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
                    , x (toString -noteWidth)
                    , y "0"
                    , height <| toString noteHeight
                    , width <| toString noteWidth
                    ]
                    []
            ]
