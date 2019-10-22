module Music.Measure.Model exposing
    ( Measure
    , Sequence
    , aggregateRests
    , fitTime
    , fromNotes
    , fromSequence
    , length
    , modifyNote
    , new
    , notesLength
    , time
    , toSequence
    )

import List.Extra exposing (scanl)
import List.Nonempty as Nonempty exposing (Nonempty)
import Music.Beat as Beat exposing (Beat)
import Music.Duration as Duration exposing (Duration)
import Music.Note.Model as Note exposing (Note)
import Music.Time as Time exposing (Time)


type alias Measure =
    { notes : Nonempty Note
    }


new : Measure
new =
    Measure <|
        Nonempty.fromElement <|
            Note.restFor Duration.whole


fromNotes : List Note -> Measure
fromNotes notes =
    case Nonempty.fromList notes of
        Nothing ->
            new

        Just nonempty ->
            Measure nonempty


time : Measure -> Time
time measure =
    -- the time (signature) for a measure
    -- TODO get from Timeline
    Time.common


notesLength : Measure -> Duration
notesLength measure =
    -- sum of the duration of all notes in measure
    let
        durs =
            Nonempty.map .duration measure.notes
    in
    Nonempty.foldl1 Duration.add durs


length : Measure -> Beat
length measure =
    -- count the total number of beats in a measure
    let
        t =
            time measure

        tdur =
            Time.toDuration t

        mdur =
            notesLength measure
    in
    if Duration.longerThan tdur mdur then
        Beat.fromDuration t <| mdur

    else
        Beat.fullBeat t.beatsPerMeasure


fitTime : Measure -> Time
fitTime measure =
    -- compute a new time signature that notes will fit in
    let
        t =
            time measure

        beats =
            length measure
    in
    Beat.fitToTime t beats


startingBeats : Measure -> Nonempty Beat
startingBeats measure =
    -- gives the starting beat for each note
    let
        t =
            time measure

        beats =
            Nonempty.map .duration measure.notes

        head =
            Nonempty.head beats

        tail =
            List.map (Beat.fromDuration t) <|
                scanl Duration.add head <|
                    Nonempty.tail beats
    in
    Nonempty.Nonempty Beat.zero tail


type alias Sequence =
    -- (possibly empty) lists of (Beat, Note) pairs
    List ( Beat, Note )


toSequence : Measure -> Sequence
toSequence measure =
    let
        startsAt =
            startingBeats measure
    in
    Nonempty.toList <|
        Nonempty.map2 (\a b -> ( a, b )) startsAt measure.notes


fromSequence : Sequence -> Measure
fromSequence sequence =
    let
        justNotes seq =
            List.map (\( b, n ) -> n) seq
    in
    fromNotes <| justNotes sequence


openSequence : Beat -> Sequence -> ( Sequence, Note, Sequence )
openSequence beat sequence =
    let
        -- TODO: need to get time from measure:
        t =
            Time.common

        precedes ( b, n ) =
            Beat.earlierThan beat <|
                Beat.add t n.duration b

        ( before, after ) =
            List.partition precedes sequence

        ( maybeBefore, note ) =
            case List.head after of
                Nothing ->
                    ( Nothing, Note.restFor Duration.quarter )

                Just ( b, n ) ->
                    if Beat.equal b beat then
                        ( Nothing, n )

                    else
                        let
                            durBefore =
                                Beat.durationFrom t b beat

                            durAfter =
                                Beat.durationFrom t beat <|
                                    Beat.add t n.duration b
                        in
                        ( Just
                            ( b
                            , { n | duration = durBefore }
                            )
                        , { n | duration = durAfter }
                        )
    in
    ( case maybeBefore of
        Nothing ->
            before

        Just tuple ->
            List.append before [ tuple ]
    , note
    , case List.tail after of
        Nothing ->
            []

        Just list ->
            list
    )


modifyNote : (Note -> Note) -> Beat -> Measure -> Measure
modifyNote f beat measure =
    let
        sequence =
            toSequence measure

        t =
            time measure

        ( before, note, after ) =
            openSequence beat sequence

        newNote =
            f note

        maybeRemainder =
            if Duration.longerThan note.duration newNote.duration then
                Just
                    ( Beat.subtract t newNote.duration beat
                    , Note.restFor <|
                        Duration.subtract newNote.duration note.duration
                    )

            else
                Nothing

        endBeat =
            Beat.add t newNote.duration beat

        follows ( b, n ) =
            Beat.laterThan endBeat <|
                Beat.add t n.duration b

        following =
            List.filter follows after

        -- the first note following may be clipped
        maybeClipped =
            case List.head following of
                Just ( b, n ) ->
                    if Beat.laterThan endBeat b then
                        let
                            d =
                                Duration.subtract n.duration <|
                                    Beat.durationFrom t b endBeat
                        in
                        Just ( endBeat, { n | duration = d } )

                    else
                        Nothing

                Nothing ->
                    Nothing

        rest =
            case maybeClipped of
                Just bn ->
                    bn
                        :: (Maybe.withDefault [] <|
                                List.tail following
                           )

                Nothing ->
                    case maybeRemainder of
                        Just bn ->
                            bn :: following

                        Nothing ->
                            following

        newSequence =
            List.concat
                [ before
                , if newNote.duration.count == 0 then
                    []

                  else
                    [ ( beat, newNote ) ]
                , rest
                ]
    in
    fromSequence newSequence
        |> aggregateRests


aggregateRests : Measure -> Measure
aggregateRests measure =
    let
        -- agg operates right to left so that previous note is head of list
        agg : Nonempty Note -> Nonempty Note -> Nonempty Note
        agg singleton sofar =
            let
                note =
                    Nonempty.head singleton

                prevNote =
                    Nonempty.head sofar
            in
            case ( prevNote.do, note.do ) of
                ( Note.Rest, Note.Rest ) ->
                    Nonempty.replaceHead
                        { prevNote
                            | duration =
                                Duration.add prevNote.duration note.duration
                        }
                        sofar

                _ ->
                    Nonempty.cons note sofar
    in
    Nonempty.map Nonempty.fromElement measure.notes
        |> Nonempty.reverse
        |> Nonempty.foldl1 agg
        |> Measure
