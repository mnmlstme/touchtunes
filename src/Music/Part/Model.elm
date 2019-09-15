module Music.Part.Model exposing
    ( Part
    , empty
    , length
    , measure
    , setMeasure
    )

import Array exposing (Array)
import Music.Measure.Model as Measure exposing (Measure)


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
        (Array.repeat 4 Measure.new)


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
