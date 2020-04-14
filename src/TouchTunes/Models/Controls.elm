module TouchTunes.Models.Controls exposing
    ( ControlSelector
    , Controls
    , init
    )

import Array as Array
import Html exposing (Html, text)
import Music.Models.Duration
    exposing
        ( Duration
        , eighth
        , half
        , quarter
        )
import Music.Models.Key as Key exposing (KeyName(..), Mode(..), keyOf)
import Music.Models.Layout as Layout exposing (Layout)
import Music.Models.Measure as Measure
import Music.Models.Pitch as Pitch exposing (Semitones, alter)
import Music.Models.Staff as Staff
import Music.Models.Time as Time exposing (BeatType(..), Time)
import Music.Views.MeasureView as MeasureView
import Music.Views.NoteView exposing (StemOrientation(..), isWhole, viewNote)
import TouchTunes.Actions.Top exposing (Msg(..))
import TouchTunes.Models.Dial as Dial exposing (Dial)
import TypedSvg exposing (g, text_)
import TypedSvg.Attributes
    exposing
        ( fontSize
        , fontWeight
        , textAnchor
        , transform
        , x
        , y
        )
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types
    exposing
        ( AnchorAlignment(..)
        , FontWeight(..)
        , Transform(..)
        , px
        )


type alias Controls msg =
    { subdivisionDial : Dial Duration msg
    , alterationDial : Dial Semitones msg
    , timeDial : Dial Time msg
    , keyDial : Dial KeyName msg
    }


type alias ControlSelector a val msg =
    a -> Dial val msg


init : Controls msg
init =
    { subdivisionDial =
        -- sets subdivision of current measure(quarter/eighth...)
        -- TODO: options depend on time signature
        -- TODO: initial depends on notes in measure
        Dial.init
            quarter
            { options =
                Array.fromList
                    [ eighth
                    , quarter
                    , half
                    ]
            , segments = 10
            , viewValue = viewSubdivision
            }
    , alterationDial =
        -- alterationDial: sets alteration (sharp/flat/natural)
        -- TODO: initial depends on selected note
        Dial.init
            0
            { options =
                Array.fromList [ -1, 0, 1 ]
            , segments = 10
            , viewValue = viewAlteration
            }
    , timeDial =
        -- timeDial: sets Time signature
        -- TODO: initial depends on current mesaure
        Dial.init
            Time.common
            { options =
                Array.fromList
                    [ Time.cut
                    , Time 2 Four
                    , Time 3 Four
                    , Time.common
                    , Time 5 Four
                    , Time 6 Eight
                    , Time 7 Eight
                    , Time 9 Eight
                    ]
            , segments = 10
            , viewValue = viewTime
            }
    , keyDial =
        -- keyDial: sets Key signature
        Dial.init
            C
            { options =
                Array.fromList
                    [ Gflat
                    , Dflat
                    , Aflat
                    , Eflat
                    , Bflat
                    , F
                    , C
                    , G
                    , D
                    , A
                    , E
                    , B
                    , Fsharp
                    ]
            , segments = 16
            , viewValue = viewKey
            }
    }


layout : Layout
layout =
    Layout.forMeasure Measure.noAttributes Measure.new


viewSubdivision : Duration -> Svg msg
viewSubdivision d =
    let
        -- choose a pitch which centers the note+stem on staff
        pitch =
            if isWhole d then
                Pitch.b 4

            else
                Pitch.e_ 4

        staffHeight =
            Layout.height layout
    in
    g
        [ transform [ Translate 0 (-0.5 * staffHeight.px) ] ]
        [ viewNote layout d pitch ]


viewAlteration : Semitones -> Svg msg
viewAlteration alt =
    let
        -- choose a pitch which centers the alter+note+stem on staff
        pitch =
            alter alt Pitch.f 4

        staffHeight =
            Layout.height layout
    in
    g
        [ transform [ Translate 0 (-0.5 * staffHeight.px) ] ]
        [ viewNote layout quarter pitch ]


viewTime : Time -> Svg msg
viewTime time =
    let
        staffHeight =
            Layout.height layout

        m =
            Layout.margins layout

        sp =
            Layout.spacing layout
    in
    g
        [ transform [ Translate (-1.0 * sp.px) (m.top.px - 0.5 * staffHeight.px) ] ]
        [ MeasureView.viewTime layout <| Just time ]


viewKey : KeyName -> Svg msg
viewKey kn =
    let
        sp =
            Layout.spacing layout

        key =
            -- TODO: handle other modes
            keyOf kn Major
    in
    g []
        [ text_
            [ textAnchor AnchorMiddle
            , fontSize <| px (5.0 * sp.px)
            , fontWeight <| FontWeight 800
            , x <| px 0
            , y <| px (2.0 * sp.px)
            ]
            [ text <| Key.displayName key ]

        -- [ text <| String.fromInt key.fifths ]
        ]
