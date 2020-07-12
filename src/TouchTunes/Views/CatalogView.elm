module TouchTunes.Views.CatalogView exposing (view)

import Array exposing (Array)
import Html as Html
    exposing
        ( Html
        , a
        , div
        , li
        , span
        , text
        , ul
        )
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Music.Models.Key as Key
import Music.Models.Time as Time
import TouchTunes.Actions.Top as Actions exposing (Msg(..))
import TouchTunes.Models.Catalog as Catalog exposing (Catalog, CatalogEntry)
import TouchTunes.Views.AppStyles exposing (css)


view : Catalog -> Html Msg
view cat =
    div
        [ classList
            [ ( css .catalog, True )
            , ( css .active, not <| Array.isEmpty cat )
            ]
        ]
        [ ul [ class (css .index) ] <|
            List.map entry <|
                Array.toList cat
        ]


entry : CatalogEntry -> Html Msg
entry e =
    li []
        [ a [ class (css .title), onClick <| GetScore e.id ] [ text e.title ]
        , span [class (css .key)] [ text <| Key.displayName e.key ]
        , span [class (css .time)] [ text <| (String.fromInt e.time.beats) ++ "/" ++ (String.fromInt <| Time.divisor e.time) ]
        , span [class (css .parts)] [ text e.part.name ]
        ]
