module Music.Views.PartStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./Music/Views/css/part.css"
            { part = "part"
            , header = "header"
            , abbrev = "abbrev"
            , staff = "staff"
            }
