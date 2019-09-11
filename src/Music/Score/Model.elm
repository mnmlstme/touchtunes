module Music.Score.Model
    exposing
        ( Score
        , countParts
        , empty
        , length
        , score
        , set
        )

import Array as Array exposing (Array)
import Music.Part.Model as Part exposing (Part)


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


set : Int -> Part -> Score -> Score
set n p s =
    { s | parts = Array.set n p s.parts }
