module Music.Models.Part exposing
    ( Part
    , empty
    , length
    , measure
    , propagateAttributes
    , setMeasure
    )

import Array exposing (Array)
import Debug exposing (log)
import List.Extra exposing (scanl)
import Music.Models.Key as Key exposing (KeyName(..), Mode(..), keyOf)
import Music.Models.Measure as Measure exposing (Attributes, Measure)
import Music.Models.Staff as Staff
import Music.Models.Time as Time


type alias Part =
    { name : String
    , abbrev : String
    , measures : Array Measure
    }


empty : Part
empty =
    Part
        "Piano"
        "Pno."
    <|
        Array.fromList
            [ Measure.initial Staff.treble Time.common (keyOf C Major)
            , Measure.new
            , Measure.new
            , Measure.new
            ]


length : Part -> Int
length p =
    Array.length p.measures


measure : Int -> Part -> Maybe Measure
measure n p =
    Array.get n p.measures


setMeasure : Int -> Measure -> Part -> Part
setMeasure n m p =
    { p
        | measures = Array.set n m p.measures
    }



-- TODO: import Maybe.Extra instead


maybeOr : Maybe val -> Maybe val -> Maybe val
maybeOr a b =
    case b of
        Just v ->
            Just v

        Nothing ->
            a


propagateAttributes : Array Measure -> Array Attributes
propagateAttributes measures =
    let
        fn a b =
            { staff = maybeOr b.staff a.staff
            , time = maybeOr b.time a.time
            , key = maybeOr b.key a.key
            }
    in
    Array.fromList <|
        scanl fn Measure.noAttributes <|
            List.map (\m -> m.attributes) <|
                Array.toList measures
