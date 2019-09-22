module TouchTunes.Controls exposing
    ( Tracking
    , inactive
    , updateDurationDial
    , viewDurationDial
    )

import Array as Array
import Html exposing (Html)
import Music.Duration
    exposing
        ( Duration
        , dotted
        , half
        , quarter
        , whole
        )
import Music.Note.View exposing (StemOrientation(..), isWhole, viewNote)
import Svg exposing (Svg, circle, g, svg, text, text_)
import Svg.Attributes
    exposing
        ( class
        , cx
        , cy
        , height
        , r
        , textAnchor
        , transform
        , width
        )
import TouchTunes.Action exposing (Msg(..))
import TouchTunes.Dial as Dial


type alias Tracking =
    { durationDial : Dial.Tracking
    }


inactive : Tracking
inactive =
    Tracking
        Nothing


durationDial : Dial.Config Duration msg
durationDial =
    { options =
        Array.fromList
            [ quarter
            , dotted quarter
            , half
            , dotted half
            , whole
            , dotted whole
            ]
    , segments = 18
    , viewValue = viewDuration
    }


viewDurationDial =
    Dial.view durationDial DurationControl


updateDurationDial =
    Dial.update durationDial ChangeDuration


viewDuration : Duration -> Svg msg
viewDuration d =
    let
        valign =
            if isWhole d then
                0

            else
                20
    in
    g
        [ transform <|
            "translate(0,"
                ++ String.fromInt valign
                ++ ")"
        ]
        [ viewNote d StemUp ]
