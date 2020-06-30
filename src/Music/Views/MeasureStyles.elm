module Music.Views.MeasureStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./Music/Views/css/measure.css"
            { measure = "measure"
            , staff = "staff"
            , time = "time"
            , key = "key"
            , clef = "clef"
            }
