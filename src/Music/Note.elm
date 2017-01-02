module Music.Note
    exposing
        ( Note
        , heldFor
        , view
        )

import Music.Duration as Duration exposing (Duration)
import Music.Pitch as Pitch exposing (Pitch)
import Html
    exposing
        ( Html
        , span
        , text
        )
import Html.Attributes exposing (class)


type alias Note =
    { pitch : Pitch
    , duration : Duration
    }


heldFor : Duration -> Pitch -> Note
heldFor d p =
    Note p d


view : Note -> Html msg
view note =
    span [ class "note" ]
        [ span [ class "duration" ]
            [ text "("
            , text (Duration.toString note.duration)
            , text ")"
            ]
        , span [ class "pitch" ]
            [ text (Pitch.toString note.pitch) ]
        ]
