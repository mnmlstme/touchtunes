module TouchTunes.Views.OverlayView exposing
    ( Track
    , Tracking
    , pointerCoordinates
    , view
    )

import CssModules as CssModules
import Html.Events.Extra.Pointer as Pointer
import List.Extra exposing (find)
import Music.Models.Beat as Beat exposing (Beat)
import Music.Models.Duration as Duration exposing (Duration, quarter)
import Music.Models.Layout as Layout
    exposing
        ( Layout
        , Location
        , beatSpacing
        , durationSpacing
        , forMeasure
        , inPx
        , scaleBeat
        )
import Music.Models.Measure as Measure exposing (Measure, toSequence)
import Music.Views.MeasureView as MeasureView
import TouchTunes.Actions.Top as Action exposing (Msg(..))
import Tuple exposing (pair)
import TypedSvg
    exposing
        ( circle
        , g
        , rect
        , svg
        )
import TypedSvg.Attributes
    exposing
        ( class
        , height
        , transform
        , width
        , x
        , y
        )
import TypedSvg.Core exposing (Svg)
import TypedSvg.Types exposing (Transform(..), px)


type alias Track =
    { beat : Beat
    , location : Location
    }


type alias Tracking =
    Maybe Track


pointerCoordinates : Pointer.Event -> ( Float, Float )
pointerCoordinates event =
    event.pointer.offsetPos


css =
    .toString <|
        CssModules.css "./TouchTunes/Views/css/editor.css"
            { overlay = "overlay"
            , selection = "selection"
            }


view : Layout -> Measure -> Beat -> Svg Msg
view layout measure beat =
    let
        seq =
            toSequence (Layout.time layout) measure

        sameBeat ( b, _ ) =
            Beat.equal beat b

        duration =
            case find sameBeat seq of
                Just ( _, n ) ->
                    n.duration

                Nothing ->
                    quarter

        upHandler =
            Pointer.onUp (\_ -> Action.FinishEdit)

        cancelHandler =
            Pointer.onCancel (\_ -> Action.CancelEdit)

        leaveHandler =
            cancelHandler

        outHandler =
            cancelHandler

        moveHandler =
            Pointer.onMove <|
                pointerCoordinates
                    >> Tuple.mapBoth floor floor
                    >> Action.DragEdit layout
    in
    svg
        [ class [ css .overlay ]
        , height <| inPx <| Layout.height layout
        , width <| inPx <| Layout.width layout
        , moveHandler
        , upHandler
        , cancelHandler
        , leaveHandler
        , outHandler
        ]
        [ rect
            [ class <| [ css .selection ]
            , width <| inPx <| durationSpacing layout duration
            , x <| inPx <| scaleBeat layout beat
            , y <| px 0
            , height <| inPx <| Layout.height layout
            ]
            []
        ]
