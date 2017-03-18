module Music.Part
    exposing
        ( Part
        , empty
        , length
        , set
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


set : Int -> Measure -> Part -> Part
set n measure p =
    { p
        | measures = Array.set n measure p.measures
    }
