module TouchTunes.Models.Catalog exposing (Catalog, decode, empty, fromList)

import Array exposing (Array)
import Debug exposing (log)
import Music.Models.Score as Score exposing (Score)
import Music.Json.Encode as MusicJson
import Json.Decode as Json exposing (field)
import TouchTunes.Actions.Top as Actions exposing (Msg(..))

type alias Catalog =
    Array CatalogEntry


type alias CatalogEntry =
    { id : String
    , title : String
    }

empty : Catalog
empty = Array.empty

fromList : List CatalogEntry -> Catalog
fromList = Array.fromList

decode : Json.Decoder (List CatalogEntry)
decode =
    Json.list <|
        Json.map2
            CatalogEntry
            (field "id" Json.string)
            (field "title" Json.string)
