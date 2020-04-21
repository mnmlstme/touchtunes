module Music.Views.NoteStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./Music/Views/css/note.css"
            { note = "note"
            , rest = "rest"
            , stem = "stem"
            , ledger = "ledger"
            , blank = "blank"
            }
