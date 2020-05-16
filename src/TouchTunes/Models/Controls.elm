module TouchTunes.Models.Controls exposing
    ( ControlSelector
    , Controls
    , forSelection
    , init
    )

import Array as Array
import Music.Models.Duration
    exposing
        ( Duration
        , eighth
        , half
        , quarter
        )
import Music.Models.Key as Key exposing (KeyName(..), Mode(..), keyOf)
import Music.Models.Layout as Layout exposing (Layout)
import Music.Models.Measure as Measure exposing (Measure)
import Music.Models.Note as Note exposing (Note)
import Music.Models.Pitch as Pitch exposing (Chromatic(..), Semitones, alter, chromatic)
import Music.Models.Staff as Staff
import Music.Models.Time as Time exposing (BeatType(..), Time)
import Music.Views.HarmonyView as HarmonyView
import Music.Views.MeasureView as MeasureView
import Music.Views.NoteView as NoteView
    exposing
        ( StemOrientation(..)
        , alteration
        , isWhole
        , viewNote
        )
import Music.Views.Symbols as Symbols
import String exposing (fromFloat)
import Svg exposing (Svg, g, text, text_)
import Svg.Attributes
    exposing
        ( fontSize
        , fontWeight
        , textAnchor
        , transform
        , x
        , y
        )
import TouchTunes.Actions.Top exposing (Msg(..))
import TouchTunes.Models.Dial as Dial exposing (Dial)
import TouchTunes.Models.Overlay as Overlay exposing (Selection)


type alias Controls msg =
    { subdivisionDial : Dial Duration msg
    , alterationDial : Dial Chromatic msg
    , timeDial : Dial Time msg
    , keyDial : Dial KeyName msg
    }


type alias ControlSelector a val msg =
    a -> Dial val msg


init : Maybe Layout -> Controls msg
init layout =
    case layout of
        Just l ->
            { keyDial =
                initKeyDial <|
                    Maybe.map Key.keyName <|
                        Just <|
                            Layout.key l
            , alterationDial = initAlterationDial Natural
            , timeDial = initTimeDial <| Just <| Layout.time l
            , subdivisionDial = initSubdivisionDial
            }

        Nothing ->
            { subdivisionDial = initSubdivisionDial
            , alterationDial = initAlterationDial Natural
            , timeDial = initTimeDial Nothing
            , keyDial = initKeyDial Nothing
            }


forSelection : Selection -> Controls msg -> Controls msg
forSelection selection controls =
    Maybe.withDefault controls <|
        Maybe.map
            (\chr -> { controls | alterationDial = initAlterationDial chr })
        <|
            case Note.pitch selection.note of
                Just p ->
                    chromatic p.alter

                Nothing ->
                    Nothing


initSubdivisionDial : Dial Duration msg
initSubdivisionDial =
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


initAlterationDial : Chromatic -> Dial Chromatic msg
initAlterationDial chr =
    -- alterationDial: sets alteration (sharp/flat/natural)
    -- TODO: initial depends on selected note
    Dial.init
        chr
        { options =
            Array.fromList [ DoubleFlat, Flat, Natural, Sharp, DoubleSharp ]
        , segments = 6
        , viewValue = viewAlteration
        }


initTimeDial : Maybe Time -> Dial Time msg
initTimeDial t =
    -- timeDial: sets Time signature
    -- TODO: initial depends on current mesaure
    Dial.init
        (Maybe.withDefault Time.common t)
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


initKeyDial : Maybe KeyName -> Dial KeyName msg
initKeyDial k =
    -- keyDial: sets Key signature
    Dial.init
        (Maybe.withDefault C k)
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


fakeLayout : Layout
fakeLayout =
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
            Layout.height fakeLayout
    in
    g
        [ transform ("translate(0," ++ fromFloat (-0.5 * staffHeight.px) ++ ")") ]
        [ viewNote fakeLayout d pitch ]


viewAlteration : Chromatic -> Svg msg
viewAlteration chr =
    let
        symbol =
            alteration chr
    in
    g [ transform "scale(2,2) translate(0,0)" ] [ Symbols.view symbol ]


viewTime : Time -> Svg msg
viewTime time =
    let
        staffHeight =
            Layout.height fakeLayout

        m =
            Layout.margins fakeLayout

        sp =
            Layout.spacing fakeLayout
    in
    g
        [ transform
            ("translate("
                ++ fromFloat (-1.0 * sp.px)
                ++ ","
                ++ fromFloat (m.top.px - 0.5 * staffHeight.px)
                ++ ")"
            )
        ]
        [ MeasureView.viewTime fakeLayout <| Just time ]


viewKey : KeyName -> Svg msg
viewKey kn =
    let
        sp =
            Layout.spacing fakeLayout

        key =
            -- TODO: handle other modes
            keyOf kn Major
    in
    g []
        [ text_
            [ textAnchor "middle"
            , fontSize <| fromFloat (5.0 * sp.px)
            , fontWeight "800"
            , x <| "0"
            , y <| fromFloat (2.0 * sp.px)
            ]
            [ text <| Key.displayName key ]
        ]
