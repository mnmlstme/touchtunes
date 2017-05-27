module Music.Measure.Model
    exposing
        ( Measure
        , new
        , fromNotes
        , time
        , notesLength
        , length
        , fitTime
        , modifyNote
        , aggregateRests
        , Sequence
        , toSequence
        , fromSequence
        )

import List.Nonempty as Nonempty exposing (Nonempty, (:::))
import Music.Time as Time exposing (Time, Beat)
import Music.Note.Model as Note exposing (Note)
import Music.Duration as Duration


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


notesLength : Measure -> Beat
notesLength measure =
    -- sum of the number of beats of all notes in measure
    let
        t =
            time measure

        beats =
            Nonempty.map (Duration.beats t << .duration) measure.notes
    in
        Nonempty.foldl1 (+) beats


length : Measure -> Beat
length measure =
    -- count the total number of beats in a measure
    let
        t =
            time measure
    in
        max t.beats <| notesLength measure


fitTime : Measure -> Time
fitTime measure =
    -- compute a new time signature that notes will fit in
    let
        t =
            time measure

        beats =
            length measure
    in
        Time.longer t beats


cumulativeBeats : Measure -> Nonempty Beat
cumulativeBeats measure =
    -- gives the start beat for each note in measure
    let
        t =
            time measure

        beats =
            Nonempty.map (Duration.beats t << .duration) measure.notes
    in
        Nonempty.scanl (+) 0 beats


type alias Sequence =
    -- (possibly empty) lists of (Beat, Note) pairs
    List ( Beat, Note )


toSequence : Measure -> Sequence
toSequence measure =
    let
        startsAt =
            cumulativeBeats measure
    in
        Nonempty.toList <|
            Nonempty.map2 (,) startsAt measure.notes


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
        -- TODO: need to get time tfrom measure:
        t =
            Time.common

        precedes ( b, n ) =
            b + Duration.beats t n.duration <= beat

        ( before, after ) =
            List.partition precedes sequence

        ( maybeBefore, note ) =
            case List.head after of
                Nothing ->
                    ( Nothing, Note.restFor Duration.quarter )

                Just ( b, n ) ->
                    if b == beat then
                        ( Nothing, n )
                    else
                        let
                            durBefore =
                                Duration.fromTimeBeats t <|
                                    beat
                                        - b

                            durAfter =
                                Duration.fromTimeBeats t <|
                                    Duration.beats t n.duration
                                        - (beat - b)
                        in
                            ( Just
                                ( beat - b
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

        noteBeats =
            Duration.beats t note.duration

        newBeats =
            Duration.beats t newNote.duration

        delta =
            newBeats - noteBeats

        -- any duration remaining from original note is filled with rest
        maybeRemainder =
            if delta < 0 then
                Just
                    ( beat - newBeats
                    , Note.restFor <|
                        Duration.fromTimeBeats t (0 - delta)
                    )
            else
                Nothing

        endBeat =
            beat + newBeats

        follows ( b, n ) =
            b + Duration.beats t n.duration > endBeat

        following =
            List.filter follows after

        -- the first note following may be clipped
        maybeClipped =
            case List.head following of
                Just ( b, n ) ->
                    if b < endBeat then
                        let
                            d =
                                Duration.fromTimeBeats t <|
                                    Duration.beats t n.duration
                                        - (endBeat - b)
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
                , if newBeats == 0 then
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
                t =
                    time measure

                note =
                    Nonempty.head singleton

                prevNote =
                    Nonempty.head sofar
            in
                case ( prevNote.do, note.do ) of
                    ( Note.Rest, Note.Rest ) ->
                        let
                            newDuration =
                                Duration.add prevNote.duration note.duration
                        in
                            if Duration.beats t newDuration <= t.beats then
                                Nonempty.replaceHead
                                    { prevNote
                                        | duration = newDuration
                                    }
                                    sofar
                            else
                                note ::: sofar

                    _ ->
                        note ::: sofar
    in
        Nonempty.map Nonempty.fromElement measure.notes
            |> Nonempty.reverse
            |> Nonempty.foldl1 agg
            |> Measure
