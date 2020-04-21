module TouchTunes.Views.EditorStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./TouchTunes/Views/css/editor.css"
            { editor = "editor"
            , frame = "frame"
            , ruler = "ruler"
            , overlay = "overlay"
            , underlay = "underlay"
            , selection = "selection"
            , pitchLevel = "pitchLevel"
            , area = "area"
            , margins = "margins"
            , overflow = "overflow"
            , controls = "controls"
            }
