module TouchTunes.ScoreEdit.Action exposing (..)

import TouchTunes.PartEdit as PartEdit exposing (PartEdit)


type Action
    = OnPart Int PartEdit.Action
