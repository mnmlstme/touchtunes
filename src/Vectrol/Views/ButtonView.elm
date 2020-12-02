module Vectrol.Views.ButtonView exposing (view)

import Html exposing (Html)
import Html.Events exposing (onClick)
import Svg exposing (Svg, g, circle)
import Svg.Attributes exposing (class, r, cx, cy)
import Vectrol.Views.ButtonStyles exposing (css)

view : msg -> Svg msg -> Svg msg
view click body =
    g
        [ class (css .button)
        , onClick click
        ]
        [ circle
              [ class (css .ring)
              , r "20"
              , cx "0"
              , cy "0"
              ]
              []
        , body ]
