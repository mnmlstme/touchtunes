module Music.Views.HarmonyStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./Music/Views/css/harmony.css"
            { root = "root"
            , chromatic = "chromatic"
            , harmony = "harmony"
            , degree = "degree"
            , kind = "kind"
            , altList = "alt-list"
            , alt = "alt"
            }
