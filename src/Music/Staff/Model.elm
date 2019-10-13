module Music.Staff.Model exposing
    ( Staff
    , bass
    , treble
    )

import Music.Pitch as Pitch exposing (Pitch)


type alias Staff =
    { -- basePitch is the pitch of the top space on staff
      basePitch : Pitch
    }


treble : Staff
treble =
    Staff (Pitch.e_ 5)


bass : Staff
bass =
    Staff (Pitch.g 3)
