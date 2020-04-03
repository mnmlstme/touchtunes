module Music.Models.Score exposing
    ( Score
    , countParts
    , empty
    , length
    , measure
    , part
    , score
    , setMeasure
    , setPart
    )

import Array as Array exposing (Array)
import Music.Models.Measure exposing (Measure)
import Music.Models.Part as Part exposing (Part)


type alias Score =
    { title : String
    , parts : Array Part
    }


empty : Score
empty =
    score "New Score" [ Part.empty ]


score : String -> List Part -> Score
score t list =
    Score t (Array.fromList list)


length : Score -> Int
length s =
    Array.map Part.length s.parts
        |> Array.foldl max 0


countParts : Score -> Int
countParts s =
    Array.length s.parts


part : Int -> Score -> Maybe Part
part i s =
    Array.get i s.parts


setPart : Int -> Part -> Score -> Score
setPart i p s =
    { s | parts = Array.set i p s.parts }


measure : Int -> Int -> Score -> Maybe Measure
measure i j s =
    case part i s of
        Just thePart ->
            Part.measure j thePart

        Nothing ->
            Nothing


setMeasure : Int -> Int -> Measure -> Score -> Score
setMeasure i j m s =
    case part i s of
        Just thePart ->
            setPart i (Part.setMeasure j m thePart) s

        Nothing ->
            s
