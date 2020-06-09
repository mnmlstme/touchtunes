module Music.Json.Encode exposing
    ( alteration
    , attributes
    , duration
    , harmony
    , key
    , kind
    , log
    , measure
    , mode
    , note
    , part
    , pitch
    , root
    , score
    , staff
    , step
    , time
    )

import Array exposing (Array)
import Debug as Debug
import Json.Encode as Json
import List.Nonempty as Nonempty exposing (Nonempty)
import Music.Models.Duration exposing (Duration)
import Music.Models.Harmony
    exposing
        ( Alteration(..)
        , Chord(..)
        , Harmony
        , Kind(..)
        )
import Music.Models.Key as Key exposing (Degree, Key, Mode)
import Music.Models.Measure exposing (Attributes, Measure)
import Music.Models.Note exposing (Note, What(..))
import Music.Models.Part exposing (Part)
import Music.Models.Pitch as Pitch exposing (Pitch, Root, Step)
import Music.Models.Score exposing (Score)
import Music.Models.Staff as Staff exposing (Staff)
import Music.Models.Time as Time exposing (Time)


log : String -> (a -> Json.Value) -> a -> a
log s encode v =
    let
        json =
            Json.encode 0 <| encode v

        pair =
            ( v
            , Debug.log (s ++ ":\n" ++ json ++ "\n") []
            )
    in
    Tuple.first pair


empty : Json.Value
empty =
    Json.object []


message : String -> List ( String, Json.Value ) -> Json.Value
message s fields =
    Json.object [ ( s, Json.object fields ) ]


filterMessage : String -> List ( String, Maybe Json.Value ) -> Json.Value
filterMessage s maybeFields =
    let
        fn ( k, maybeValue ) =
            case maybeValue of
                Just v ->
                    Just ( k, v )

                Nothing ->
                    Nothing
    in
    message s <| List.filterMap fn maybeFields


nonZeroInt : Int -> Maybe Json.Value
nonZeroInt i =
    case i of
        0 ->
            Nothing

        n ->
            Just <| Json.int n


step : Step -> Json.Value
step s =
    message "Step"
        [ ( Pitch.stepToString s, empty ) ]


pitch : Pitch -> Json.Value
pitch p =
    filterMessage "Pitch"
        [ ( "step", Just <| step p.step )
        , ( "alter", nonZeroInt p.alter )
        , ( "octave", Just <| Json.int p.octave )
        ]


duration : Duration -> Json.Value
duration d =
    message "Duration"
        [ ( "count", Json.int d.count )
        , ( "divisor", Json.int d.divisor )
        ]


root : Root -> Json.Value
root r =
    filterMessage "Root"
        [ ( "step", Just <| step r.step )
        , ( "alter", nonZeroInt r.alter )
        ]


degree : Chord -> Maybe Json.Value
degree ch =
    case ch of
        Triad ->
            Nothing

        Sixth ->
            Just <| Json.int 6

        Seventh ->
            Just <| Json.int 7

        Ninth ->
            Just <| Json.int 9

        Eleventh ->
            Just <| Json.int 11

        Thirteenth ->
            Just <| Json.int 13


chord : String -> Chord -> Json.Value
chord s ch =
    filterMessage s
        [ ( "degree", degree ch ) ]


kind : Kind -> Json.Value
kind k =
    case k of
        Major ch ->
            chord "Major" ch

        Minor ch ->
            chord "Minor" ch

        Diminished ch ->
            chord "Diminished" ch

        Augmented ch ->
            chord "Augmented" ch

        Dominant ch ->
            chord "Dominant" ch

        HalfDiminished ->
            chord "HalfDiminished" Seventh

        MajorMinor ->
            chord "MajorMinor" Seventh

        Power ->
            chord "Power" Triad


altObject : String -> Degree -> Json.Value
altObject s d =
    message s [ ( "degree", Json.int d ) ]


alteration : Alteration -> Json.Value
alteration a =
    case a of
        Sus d ->
            altObject "Sus" d

        Add d ->
            altObject "Add" d

        No d ->
            altObject "No" d

        Raised d ->
            altObject "Raised" d

        Lowered d ->
            altObject "Lowered" d

        Altered s d ->
            message "Altered"
                [ ( "type", Json.string s )
                , ( "degree", Json.int d )
                ]


harmony : Harmony -> Json.Value
harmony h =
    let
        maybeAlterations =
            if List.isEmpty h.alter then
                Nothing

            else
                Just <| Json.list alteration h.alter
    in
    filterMessage "Harmony"
        [ ( "root", Just <| root h.root )
        , ( "kind", Just <| kind h.kind )
        , ( "alter", maybeAlterations )
        , ( "bass", Maybe.map root h.bass )
        ]


note : Note -> Json.Value
note n =
    let
        mtype =
            case n.do of
                Play p ->
                    "Note"

                Rest ->
                    "Rest"
    in
    filterMessage mtype
        [ ( "harmony", Maybe.map harmony n.harmony )
        , ( "pitch"
          , case n.do of
                Play p ->
                    Just <| pitch p

                Rest ->
                    Nothing
          )
        , ( "duration", Just <| duration n.duration )
        ]


mode : Mode -> Json.Value
mode m =
    let
        maybeString =
            Key.modeToString m
    in
    message "Mode" <|
        case maybeString of
            Just s ->
                [ ( s, empty ) ]

            Nothing ->
                []


key : Key -> Json.Value
key k =
    message "Key"
        [ ( "fifths", Json.int k.fifths )
        , ( "mode", mode k.mode )
        ]


time : Time -> Json.Value
time t =
    message "Time"
        [ ( "beats", Json.int t.beats )
        , ( "beatType"
          , Json.int <|
                Time.divisor t
          )
        ]


staff : Staff -> Json.Value
staff s =
    message "Staff"
        [ ( Staff.toString s, empty ) ]


attributes : Attributes -> Maybe Json.Value
attributes a =
    let
        maybeFields =
            [ ( "staff", Maybe.map staff a.staff )
            , ( "key", Maybe.map key a.key )
            , ( "time", Maybe.map time a.time )
            ]
    in
    if List.isEmpty maybeFields then
        Nothing

    else
        Just <|
            filterMessage "Attributes" maybeFields


measure : Measure -> Json.Value
measure m =
    filterMessage "Measure"
        [ ( "attributes", attributes m.attributes )
        , ( "notes"
          , Just <|
                Json.list note <|
                    Nonempty.toList m.notes
          )
        ]


part : Part -> Json.Value
part p =
    message "ScorePart"
        [ ( "id", Json.string p.id )
        , ( "name", Json.string p.name )
        , ( "abbrev", Json.string p.abbrev )
        ]


score : Score -> Json.Value
score s =
    message "Score"
        [ ( "title", Json.string s.title )
        , ( "part-list", Json.list part s.parts )
        , ( "measure-list", Json.array measure s.measures  )
        ]
