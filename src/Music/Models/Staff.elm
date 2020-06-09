module Music.Models.Staff exposing
    ( Staff(..)
    , basePitch
    , toString
    )

import Music.Models.Pitch as Pitch exposing (Pitch)


type Staff
    = Treble
    | Bass


basePitch : Staff -> Pitch
basePitch staff =
    -- basePitch is the pitch of the top space on staff
    case staff of
        Treble ->
            Pitch.e_ 5

        Bass ->
            Pitch.g 3


toString : Staff -> String
toString staff =
    case staff of
        Treble ->
            "Treble"

        Bass ->
            "Bass"
