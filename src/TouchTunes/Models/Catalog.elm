module TouchTunes.Models.Catalog exposing (Catalog, CatalogEntry, decode, empty, fromList)

import Array exposing (Array)
import Debug exposing (log)
import Music.Models.Score as Score exposing (Score)
import Music.Models.Time as Time exposing (Time)
import Music.Models.Key as Key exposing (Key)
import Music.Models.Part as Key exposing (Part)
import Music.Json.Decode as MusicJson
import Json.Decode as Json exposing (field)
import TouchTunes.Actions.Top as Actions exposing (Msg(..))

type alias Catalog =
    Array CatalogEntry


type alias CatalogEntry =
    { id : String
    , title : String
    , part : Part
    , key : Key
    , time : Time
    }

empty : Catalog
empty = Array.empty
        
fromList : List CatalogEntry -> Catalog
fromList = Array.fromList

decode : Json.Decoder (List CatalogEntry)
decode =
    Json.list <|
        Json.map5
            CatalogEntry
            (field "id" Json.string)
            (field "title" Json.string)
            (field "part" MusicJson.part)
            (field "key" MusicJson.key)
            (field "time" MusicJson.time)
