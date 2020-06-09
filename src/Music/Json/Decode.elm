module Music.Json.Decode exposing (score)

import Json.Decode as Json exposing (Decoder, field, maybe, oneOf, succeed)
import List.Nonempty as Nonempty exposing (Nonempty)
import Music.Models.Duration exposing (Duration)
import Music.Models.Harmony as Harmony
    exposing
        ( Alteration(..)
        , Chord(..)
        , Harmony
        , Kind(..)
        )
import Music.Models.Key as Key exposing (Degree, Key, Mode)
import Music.Models.Measure as Measure exposing (Attributes, Measure)
import Music.Models.Note as Note exposing (Note, What(..))
import Music.Models.Part as Part exposing (Part)
import Music.Models.Pitch as Pitch exposing (Pitch, Root, Step)
import Music.Models.Score as Score exposing (Score)
import Music.Models.Staff as Staff exposing (Staff)
import Music.Models.Time as Time exposing (Time)


score : Decoder Score
score =
    let
        body : Decoder Score
        body =
            Json.map3
                (\s pl ml -> Score.score s pl ml)
                (field "title" Json.string)
                (field "part-list" <| Json.list part)
                (field "measure-list" <| Json.list measure)
    in
    field "Score" body


part : Decoder Part
part =
    let
        body : Decoder Part
        body =
            Json.map3
                (\id n a -> { id = id, name = n, abbrev = a })
                (field "id" Json.string)
                (field "name" Json.string)
                (field "abbrev" Json.string)
    in
    field "ScorePart" body


measure : Decoder Measure
measure =
    let
        body : Decoder Measure
        body =
            Json.map2
                (\ma nl ->
                    Measure.fromNotes
                        (Maybe.withDefault Measure.noAttributes ma)
                        nl
                )
                (maybe <| field "attributes" attributes)
                (field "notes" <| Json.list note)
    in
    field "Measure" body


attributes : Decoder Attributes
attributes =
    let
        body : Decoder Attributes
        body =
            Json.map3
                (\s k t -> { staff = s, time = t, key = k })
                (maybe <| field "staff" staff)
                (maybe <| field "key" key)
                (maybe <| field "time" time)
    in
    field "Attributes" body


staff : Decoder Staff
staff =
    let
        body : Decoder Staff
        body =
            field "Treble" <| succeed Staff.Treble
    in
    field "Staff" body


key : Decoder Key
key =
    let
        body : Decoder Key
        body =
            Json.map2
                (\f m -> { fifths = f, mode = m })
                (field "fifths" Json.int)
                (field "mode" mode)
    in
    field "Key" body


mode : Decoder Mode
mode =
    let
        body : Decoder Mode
        body =
            oneOf
                [ field "Major" <| succeed Key.Major
                , field "Minor" <| succeed Key.Minor
                ]
    in
    Json.map
        (\mm -> Maybe.withDefault Key.None mm)
        (field "Mode" <| maybe body)


time : Decoder Time
time =
    let
        body : Decoder Time
        body =
            Json.map2
                (\b bt ->
                    { beats = b
                    , beatType =
                        case bt of
                            2 ->
                                Time.Two

                            4 ->
                                Time.Four

                            8 ->
                                Time.Eight

                            _ ->
                                -- TODO: fail
                                Time.Four
                    }
                )
                (field "beats" Json.int)
                (field "beatType" Json.int)
    in
    field "Time" body


note : Decoder Note
note =
    let
        harmonize mh n =
            { n | harmony = mh }

        play : Decoder Note
        play =
            Json.map3
                (\mh p dur -> harmonize mh <| Note.playFor dur p)
                (maybe <| field "harmony" harmony)
                (field "pitch" pitch)
                (field "duration" duration)

        rest : Decoder Note
        rest =
            Json.map2
                (\mh dur -> harmonize mh <| Note.restFor dur)
                (maybe <| field "harmony" harmony)
                (field "duration" duration)
    in
    oneOf
        [ field "Note" play
        , field "Rest" rest
        ]


duration : Decoder Duration
duration =
    let
        body : Decoder Duration
        body =
            Json.map2
                (\cnt div -> { count = cnt, divisor = div })
                (field "count" Json.int)
                (field "divisor" Json.int)
    in
    field "Duration" body


pitch : Decoder Pitch
pitch =
    let
        body : Decoder Pitch
        body =
            Json.map3
                (\stp malt oct ->
                    { step = stp
                    , alter = Maybe.withDefault 0 malt
                    , octave = oct
                    }
                )
                (field "step" step)
                (maybe <| field "alter" Json.int)
                (field "octave" Json.int)
    in
    field "Pitch" body


step : Decoder Step
step =
    let
        body : Decoder Step
        body =
            oneOf
                [ field "A" <| succeed Pitch.A
                , field "B" <| succeed Pitch.B
                , field "C" <| succeed Pitch.C
                , field "D" <| succeed Pitch.D
                , field "E" <| succeed Pitch.E
                , field "F" <| succeed Pitch.F
                , field "G" <| succeed Pitch.G
                ]
    in
    field "Step" body



-- field "Harmony" <|
--     succeed <|
--         Harmony.chord (Harmony.Major Harmony.Triad) <|
--             Pitch.root Pitch.C Pitch.Natural


harmony : Decoder Harmony
harmony =
    let
        body : Decoder Harmony
        body =
            Json.map4
                (\r k ma mb ->
                    { root = r
                    , kind = k
                    , alter = Maybe.withDefault [] ma
                    , bass = mb
                    }
                )
                (field "root" root)
                (field "kind" kind)
                (maybe <| field "alter" <| Json.list alteration)
                (maybe <| field "bass" <| root)
    in
    field "Harmony" body


root : Decoder Root
root =
    let
        body : Decoder Root
        body =
            Json.map2
                (\s ma ->
                    { step = s
                    , alter = Maybe.withDefault 0 ma
                    }
                )
                (field "step" step)
                (maybe <| field "alter" Json.int)
    in
    field "Root" body


kind : Decoder Kind
kind =
    oneOf
        [ field "Major" <| chordDegree Major
        , field "Minor" <| chordDegree Minor
        , field "Diminished" <| chordDegree Diminished
        , field "Augmented" <| chordDegree Augmented
        , field "Dominant" <| chordDegree Dominant
        , field "HalfDiminished" <| chord HalfDiminished
        , field "MajorMinor" <| chord MajorMinor
        , field "Power" <| chord Power
        ]


chord : Kind -> Decoder Kind
chord k =
    Json.map
        (Maybe.withDefault k)
        (maybe <| field "degree" <| succeed k)


chordDegree : (Chord -> Kind) -> Decoder Kind
chordDegree ch =
    let
        degree : Int -> Chord
        degree n =
            case n of
                6 ->
                    Sixth

                7 ->
                    Seventh

                9 ->
                    Ninth

                11 ->
                    Eleventh

                13 ->
                    Thirteenth

                _ ->
                    Triad
    in
    Json.map
        (\md ->
            ch <|
                Maybe.withDefault Triad <|
                    Maybe.map degree md
        )
        (maybe <| field "degree" Json.int)


alteration : Decoder Alteration
alteration =
    oneOf
        [ field "Sus" <| altDegree Sus
        , field "Add" <| altDegree Add
        , field "No" <| altDegree No
        , field "Raised" <| altDegree Raised
        , field "Lowered" <| altDegree Lowered
        , field "Altered" <|
            Json.map2
                Altered
                (field "type" Json.string)
                (field "degree" Json.int)
        ]


altDegree : (Int -> Alteration) -> Decoder Alteration
altDegree alt =
    Json.map
        alt
        (field "degree" Json.int)
