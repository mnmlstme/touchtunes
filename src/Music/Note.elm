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


heldFor : Duration -> Pitch -> Note
heldFor d p =
    Note p d


beats : Time -> Note -> Beat
beats time note =
    Duration.beats time note.duration


symbol : Time -> Note -> String
symbol time note =
    let
        b =
            beats time note
    in
        if b == 1 then
            "#quarter-note-stem-up"
        else if b == 2 then
            "#half-note-stem-up"
        else if b == 4 then
            "#whole-note"
        else
            "#unknown-note"


draw : Layout -> Beat -> Note -> Svg msg
draw layout beat note =
    let
        noteSymbol =
            symbol layout.time note

        p =
            note.pitch

        altSymbol =
            if p.alter > 0 then
                "#sharp"
            else if p.alter < 0 then
                "#flat"
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
    in
        g [ transform ("translate(" ++ position ++ ")") ]
            [ use
                [ xlinkHref noteSymbol
                , x "0"
                , y "0"
                , height <| toString noteHeight
                , width <| toString noteWidth
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
