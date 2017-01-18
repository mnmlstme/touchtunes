module Music.Measure.Edit
    exposing
        ( Edit
        , view
        )

import Music.Duration exposing (quarter)
import Music.Time exposing (Beat)
import Music.Note as Note exposing (Note, heldFor)
import Music.Measure.Layout as Layout exposing (Layout)
import Music.Measure.Action exposing (Action(..))
import Html exposing (Html, div, text)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (Decoder, field, int)
import Mouse
import Svg exposing (Svg, svg, g)
import Svg.Attributes
    exposing
        ( class
        , height
        , width
        , viewBox
        )


type alias Edit =
    { layout : Layout
    , at : Maybe Beat
    }



-- TODO: PR to add mouseOffset to elm-lang/mouse


mouseOffset : Decoder Mouse.Position
mouseOffset =
    Decode.map2 Mouse.Position
        (field "offsetX" int)
        (field "offsetY" int)


insertAction : Layout -> Mouse.Position -> Action
insertAction layout offset =
    let
        beat =
            Layout.unscaleBeat layout (toFloat offset.x)

        pitch =
            Layout.unscalePitch layout (toFloat offset.y)
    in
        InsertNote (pitch |> heldFor quarter) beat


stretchAction : Layout -> Mouse.Position -> Action
stretchAction layout offset =
    let
        beat =
            Layout.unscaleBeat layout (toFloat offset.x)
    in
        StretchNote beat


view : Edit -> Html Action
view edit =
    let
        lo =
            edit.layout

        w =
            Layout.width lo

        h =
            Layout.height lo

        vb =
            [ 0.0, 0.0, w, h ]

        onMousedownInsert =
            on "mousedown" <|
                Decode.map (insertAction lo) mouseOffset

        onMousemoveStretch =
            on "mousemove" <|
                Decode.map (stretchAction lo) mouseOffset
    in
        svg
            [ class "measure-edit"
            , height (toString h)
            , width (toString w)
            , viewBox (String.join " " (List.map toString vb))
            , onMousedownInsert
            , onMousemoveStretch
            ]
            []
