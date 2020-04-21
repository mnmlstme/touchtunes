module TouchTunes.Views.AppStyles exposing (..)

import CssModules


css =
    .toString <|
        CssModules.css "./TouchTunes/Views/css/app.css"
            { app = "app"
            , fullscreen = "fullscreen"
            , body = "body"
            , footer = "footer"
            }
