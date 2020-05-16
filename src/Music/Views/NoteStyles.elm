module Music.Views.NoteStyles exposing (..)

import CssModules


css :
    ({ blank : String
     , harmony : String
     , ledger : String
     , note : String
     , rest : String
     , stem : String
     }
     -> String
    )
    -> String
css =
    .toString <|
        CssModules.css "./Music/Views/css/note.css"
            { note = "note"
            , rest = "rest"
            , stem = "stem"
            , ledger = "ledger"
            , blank = "blank"
            , harmony = "harmony"
            }
