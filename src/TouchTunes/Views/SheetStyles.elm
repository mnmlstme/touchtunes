module TouchTunes.Views.SheetStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./TouchTunes/Views/css/sheet.css"
            { sheet = "sheet"
            , frame = "frame"
            , pane = "pane"
            , staff = "staff"
            , header = "header"
            , form = "form"
            }
