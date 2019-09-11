module TouchTunes.MeasureEdit.Model
    exposing
        ( MeasureEdit
        , open
        )

import Music.Time exposing (Beat)
import Music.Measure.Model as Measure
    exposing
        ( Measure
        )
import TouchTunes.MeasureEdit.HeadUpDisplay as HeadUpDisplay exposing (HeadUpDisplay)


type alias MeasureEdit =
    { saved : Measure
    , measure : Measure
    , selection : Maybe Beat
    , hud : Maybe HeadUpDisplay
    }


open : Measure -> MeasureEdit
open measure =
    MeasureEdit measure measure Nothing Nothing
