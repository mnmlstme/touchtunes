module Vectrol.Views.ButtonStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./Vectrol/Views/css/button.css"
            { button = "button"
            , ring = "ring"
            }
