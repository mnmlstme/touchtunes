module Vectrol.Views.DialStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./Vectrol/Views/css/dial.css"
            { dial = "dial"
            , face = "face"
            , value = "value"
            , option = "option"
            , viewValue = "viewValue"
            , collar = "collar"
            , active = "active"
            , inner = "inner"
            , ring = "ring"
            , outer = "outer"
            , sector = "sector"
            }
