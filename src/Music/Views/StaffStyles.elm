module Music.Views.StaffStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./Music/Views/css/staff.css"
            { staff = "staff"
            , barline = "barline"
            , lines = "lines"
            }
