module TouchTunes.Overlay exposing
    ( Track
    , Tracking
    , view
    )

import CssModules as CssModules
import List.Extra exposing (find)
import Music.Beat as Beat exposing (Beat)
import Music.Duration as Duration exposing (Duration, quarter)
import Music.Measure.Layout as Layout
    exposing
        ( Location
        , beatSpacing
        , durationSpacing
        , inPx
        , scaleBeat
        )
import Music.Measure.Model as Measure exposing (Measure, toSequence)
import Music.Measure.View as MeasureView exposing (layoutFor)
import TouchTunes.Action as Action exposing (Msg(..))
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


view : Measure -> Beat -> Svg Msg
view measure beat =
    let
        css =
            .toString <|
                CssModules.css "./TouchTunes/editor.css"
                    { overlay = "overlay"
                    , selection = "selection"
                    }

        layout =
            layoutFor measure

        seq =
            toSequence measure

        sameBeat ( b, _ ) =
            Beat.equal beat b

        duration =
            case find sameBeat seq of
                Just ( _, n ) ->
                    n.duration

                Nothing ->
                    quarter
    in
    svg
        [ class <| [ css .overlay ]
        , height <| inPx <| Layout.height layout
        , width <| inPx <| Layout.width layout
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
