module Music.Models.Score exposing
    ( Score
    , attributes
    , changeTitle
    , countParts
    , empty
    , insertMeasure
    , length
    , measure
    , measureWithContext
    , score
    , setMeasure
    )

import Array as Array exposing (Array)
import Debug exposing (log)
import List.Extra exposing (scanl)
import Maybe.Extra
import Music.Models.Key as Key exposing (KeyName(..), Mode(..), keyOf)
import Music.Models.Measure as Measure exposing (Attributes, Measure)
import Music.Models.Part as Part exposing (Part)
import Music.Models.Staff as Staff
import Music.Models.Time as Time


type alias Score =
    -- in MusicXML parlance, this is a score-timewise
    -- each measure will contain notes for all parts that are loaded
    { title : String
    , parts : List Part
    , measures : Array Measure
    }


empty : Score
empty =
    score "New Score"
        [ Part.default ]
        [ Measure.initial Staff.Treble Time.common (keyOf C Major)
        , Measure.new
        , Measure.new
        , Measure.new
        ]


score : String -> List Part -> List Measure -> Score
score t pList mList =
    Score t pList (Array.fromList mList)


changeTitle : String -> Score -> Score
changeTitle s scr =
    { scr | title = s }


length : Score -> Int
length s =
    Array.length s.measures


countParts : Score -> Int
countParts s =
    List.length s.parts


measure : Int -> Score -> Maybe Measure
measure i s =
    Array.get i s.measures


measureWithContext : Int -> Score -> Maybe ( Measure, Attributes )
measureWithContext i s =
    let
        a =
            Maybe.withDefault Measure.noAttributes <|
                Array.get i <|
                    attributes s
    in
    Maybe.map (\m -> ( m, a )) <| measure i s


setMeasure : Int -> Measure -> Score -> Score
setMeasure i m s =
    { s | measures = Array.set i m s.measures }

insertMeasure : Int -> Score -> Score
insertMeasure i s =
    let
        ms = s.measures

        before = Array.slice 0 i ms

        after = Array.slice i (Array.length ms) ms
    in
    { s | measures = Array.append (Array.push Measure.new before) after}

attributes : Score -> Array Attributes
attributes s =
    let
        measures =
            s.measures

        fn a b =
            { staff = Maybe.Extra.or a.staff b.staff
            , time = Maybe.Extra.or a.time b.time
            , key = Maybe.Extra.or a.key b.key
            }
    in
    Array.fromList <|
        scanl fn Measure.noAttributes <|
            List.map (\m -> m.attributes) <|
                Array.toList measures
