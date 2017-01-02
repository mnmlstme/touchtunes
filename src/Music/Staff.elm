module Music.Staff
    exposing
        ( Staff
        , Tenths
        , treble
        , bass
        , view
        )

import Music.Pitch exposing (Pitch, f, a)
import Html exposing (Html)
import Svg
    exposing
        ( svg
        , g
        , line
        )
import Svg.Attributes
    exposing
        ( class
        , height
        , width
        , viewBox
        , x1
        , x2
        , y1
        , y2
        )


type alias Staff =
    { -- basePitch is the pitch of the lowest space on staff
      basePitch : Pitch
    , scale : Float
    , width : Tenths
    }



-- Tenths
-- All dimensions are in tenths of the interline staff spacing


type alias Tenths =
    Float


treble : Tenths -> Staff
treble =
    Staff (f 4) 2.0


bass : Tenths -> Staff
bass =
    Staff (a 2) 2.0


view : Staff -> Html msg
view staff =
    let
        fromTenths tenths =
            tenths * staff.scale

        vmargin =
            fromTenths 20.0

        x0 =
            0.0

        y0 =
            vmargin

        spacing =
            fromTenths 10.0

        h =
            2 * vmargin + 4 * spacing

        w =
            fromTenths staff.width

        vb =
            [ 0.0, 0.0, w, h ]

        staffLine n =
            let
                y =
                    y0 + toFloat n * spacing
            in
                line
                    [ x1 (toString x0)
                    , x2 (toString (x0 + w))
                    , y1 (toString y)
                    , y2 (toString y)
                    ]
                    []
    in
        svg
            [ class "staff"
            , height (toString h)
            , width (toString w)
            , viewBox (String.join " " (List.map toString vb))
            ]
            [ g [ class "staff-lines" ]
                (List.map
                    staffLine
                    (List.range 0 4)
                )
            ]
