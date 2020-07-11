module TouchTunes.Views.SheetStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./TouchTunes/Views/css/sheet.css"
            { sheet = "sheet"
            , frame = "frame"
            , pane = "pane"
            , body = "body"
            , header = "header"
            , form = "form"
            }
