module TouchTunes.MeasureEdit.Model
    exposing
        ( MeasureEdit
        , open
        )

import Music.Measure.Model as Measure
    exposing
        ( Measure
        )
import TouchTunes.MeasureEdit.HeadUpDisplay as HeadUpDisplay exposing (HeadUpDisplay)


type alias MeasureEdit =
    { saved : Measure
    , measure : Measure
    , hud : HeadUpDisplay
    }


open : Measure -> MeasureEdit
open measure =
    let
        hud =
            HeadUpDisplay measure Nothing
    in
        MeasureEdit measure measure hud
