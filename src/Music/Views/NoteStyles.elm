module Music.Views.NoteStyles exposing
    ( part
    , partAbbrev
    , partBody
    , partHeader
    , parts
    )

import Css exposing (..)

note = batch []

stem = batch
    [
    ]

ledger = .ledger {
        stroke-width: 3px;
        stroke: #333;
        stroke-linecap: round;
    }

    .rest {

    }

    /* Blank */

    .blank {
        fill: rgba(17, 99, 216, 0.12);
        stroke: rgb(17, 99, 216);
        stroke-linejoin: round;
        stroke-width: 1px;
    }
