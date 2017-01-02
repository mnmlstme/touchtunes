module Music.Staff
    exposing
        ( Staff
        , Tenths
        , treble
        , bass
        , layout
        , view
        )

import Music.Pitch as Pitch exposing (Pitch)
import Music.Note as Note exposing (Note)
import Music.Time as Time exposing (Time, Beat)
import Html exposing (Html)
import Svg
    exposing
        ( Svg
        , svg
        , g
        , line
        , use
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
        )


type alias Staff =
    { -- basePitch is the pitch of the lowest space on staff
      basePitch : Pitch
    , scale : Scale
    }


treble : Scale -> Staff
treble =
    Staff (Pitch.f 4)


bass : Scale -> Staff
bass =
    Staff (Pitch.a 2)



-- Tenths
-- All dimensions are in tenths of the interline staff spacing


type alias Tenths =
    Float



-- Scale
-- Scale is the number of Pixels per Tenth


type alias Scale =
    Float



-- Layout
-- All dimensions required to layout notes on a staff


type alias Margins =
    { top : Float
    , right : Float
    , bottom : Float
    , left : Float
    }


type alias Layout =
    { spacing : Float
    , margins : Margins
    , w : Float
    , h : Float
    , scalePitch : Pitch -> Float
    , scaleBeat : Beat -> Float
    }


layout : Staff -> Time -> Layout
layout staff time =
    let
        beats =
            time.beats

        spacing =
            staff.scale * 10.0

        beatSpacing =
            staff.scale * 40.0

        vmargin =
            2.0 * spacing

        hmargin =
            spacing

        margins =
            Margins vmargin hmargin vmargin hmargin

        w =
            margins.left
                + margins.right
                + (toFloat beats)
                * beatSpacing

        h =
            margins.top + margins.bottom + 4 * spacing

        base =
            Pitch.stepNumber staff.basePitch

        -- scalePitch locates the top of the note on staff
        scalePitch p =
            let
                n =
                    (Pitch.stepNumber p) - base
            in
                margins.top
                    + 3.0
                    * spacing
                    - (toFloat n)
                    / 2.0
                    * spacing

        -- scaleBeat locates the center of the beat on staff
        scaleBeat b =
            margins.left + ((toFloat b) + 0.5) * beatSpacing
    in
        Layout spacing margins w h scalePitch scaleBeat


drawStaffLine : Layout -> Int -> Svg msg
drawStaffLine layout n =
    let
        y =
            layout.margins.top + toFloat n * layout.spacing
    in
        line
            [ x1 "0"
            , x2 <| toString layout.w
            , y1 <| toString y
            , y2 <| toString y
            ]
            []


drawBarLine : Layout -> Svg msg
drawBarLine layout =
    line
        [ x1 <| toString layout.w
        , y1 <| toString layout.margins.top
        , x2 <| toString layout.w
        , y2 <| toString <| layout.h - layout.margins.bottom
        ]
        []


drawNote : Layout -> ( Beat, Note ) -> Svg msg
drawNote layout ( beat, note ) =
    let
        sym =
            "#quarter-note-stem-up"

        noteHeight =
            layout.spacing

        noteWidth =
            1.5 * layout.spacing

        ypos =
            layout.scalePitch note.pitch

        xpos =
            layout.scaleBeat beat - noteWidth / 2.0
    in
        g []
            [ use
                [ xlinkHref sym
                , x <| toString xpos
                , y <| toString ypos
                , height <| toString noteHeight
                , width <| toString noteWidth
                ]
                []
            ]


view : Staff -> Layout -> List ( Beat, Note ) -> Html msg
view staff layout noteSequence =
    let
        vb =
            [ 0.0, 0.0, layout.w, layout.h ]
    in
        svg
            [ class "staff"
            , height (toString layout.h)
            , width (toString layout.w)
            , viewBox (String.join " " (List.map toString vb))
            ]
            [ g [ class "staff-lines" ]
                (List.map
                    (drawStaffLine layout)
                    (List.range 0 4)
                )
            , g [ class "staff-notes" ]
                (List.map
                    (drawNote layout)
                    noteSequence
                )
            , g [ class "staff-barline" ]
                [ drawBarLine layout ]
            ]
