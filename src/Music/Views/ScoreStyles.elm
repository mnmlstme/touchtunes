module Music.Views.ScoreStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./Music/Views/css/score.css"
            { title = "title"
            , parts = "parts"
            , attribution = "attribution"
            , measures = "measures"
            }
