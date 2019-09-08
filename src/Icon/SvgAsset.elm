-- Icon.SvgAsset.elm
-- after https://github.com/cultureamp/babel-elm-assets-plugin/tree/1.0.1#advanced-configuration


module Icon.SvgAsset exposing (..)


type alias SvgAsset =
    { id : String
    , viewBox : String
    }


svgAsset : String -> SvgAsset
svgAsset path =
    -- these placeholder values are replaced by Webpack at build time
    { id = "elm-svg-asset-placeholder"
    , viewBox = "0 0 0 0"
    }
