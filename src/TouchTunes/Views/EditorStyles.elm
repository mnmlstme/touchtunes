module TouchTunes.Views.EditorStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./TouchTunes/Views/css/editor.css"
            { editor = "editor"
            , frame = "frame"
            , ruler = "ruler"
            , overlay = "overlay"
            , understaff = "understaff"
            , underharmony = "underharmony"
            , selection = "selection"
            , pitchLevel = "pitchLevel"
            , notearea = "notearea"
            , harmonyarea = "harmonyarea"
            , margins = "margins"
            , overflow = "overflow"
            , controls = "controls"
            , navigation = "navigation"
            }
