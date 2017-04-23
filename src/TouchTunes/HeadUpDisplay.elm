module TouchTunes.HeadUpDisplay
    exposing
        ( HeadUpDisplay
        , hud
        , update
        , view
        )

import TouchTunes.Gesture as Gesture exposing (Gesture)
import Music.Measure.Layout as Layout
    exposing
        ( Layout
        , Pixels
        , Tenths
        , Location
        , heightPx
        , widthPx
        , positionToLocation
        )
import Json.Decode as Decode exposing (Decoder, field, int)
import Mouse
import Svg exposing (Svg, svg, g)
import Svg.Attributes exposing (class)
import Html.Events
    exposing
        ( on
        , onMouseUp
        , onMouseOut
        )


type alias HeadUpDisplay =
    { layout : Layout
    , gesture : Gesture
    }


hud : Layout -> HeadUpDisplay
hud layout =
    HeadUpDisplay layout Gesture.Idle


mouseOffset : Decoder Mouse.Position
mouseOffset =
    -- TODO: submit PR to elm-lang/mouse to add mouseOffset
    Decode.map2 Mouse.Position
        (field "offsetX" int)
        (field "offsetY" int)


update : Gesture.Action -> HeadUpDisplay -> HeadUpDisplay
update action hud =
    { hud | gesture = Gesture.update action hud.gesture }


view : HeadUpDisplay -> Svg Gesture.Action
view hud =
    let
        toLocation =
            positionToLocation hud.layout

        down =
            on "mousedown" <|
                Decode.map Gesture.StartGesture <|
                    Decode.map toLocation mouseOffset

        move =
            on "mousemove" <|
                Decode.map Gesture.ContinueGesture <|
                    Decode.map toLocation mouseOffset

        up =
            onMouseUp Gesture.FinishGesture

        out =
            onMouseOut Gesture.FinishGesture

        actions =
            case hud.gesture of
                Gesture.Idle ->
                    [ down ]

                Gesture.Touch _ ->
                    [ move
                    , up
                    ]

                Gesture.Drag _ _ ->
                    [ move
                    , up
                    , out
                    ]

                Gesture.Reversal _ _ _ ->
                    [ move
                    , up
                    , out
                    ]
    in
        svg
            (List.append
                [ class "measure-hud"
                , heightPx <| Layout.height hud.layout
                , widthPx <| Layout.width hud.layout
                ]
                actions
            )
            []
