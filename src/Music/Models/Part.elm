module Music.Models.Part exposing
    ( Id
    , Part
    , default
    , part
    )


type alias Id =
    String


type alias Part =
    { id : Id
    , name : String
    , abbrev : String
    }


default : Part
default =
    part
        "Piano"
        "Pno."


part : String -> String -> Part
part name abbrev =
    let
        id =
            String.toLower name
    in
    Part id name abbrev
