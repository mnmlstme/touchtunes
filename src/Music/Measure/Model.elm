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


splitSequence : Beat -> Sequence -> ( Sequence, Sequence )
splitSequence beat =
    let
        precedes beat ( b, _ ) =
            b < beat
    in
        List.partition <| precedes beat


findInSequence : Beat -> Sequence -> Maybe ( Beat, Note )
findInSequence beat sequence =
    let
        ( before, rest ) =
            splitSequence beat sequence
    in
        List.head rest


openSequence : Beat -> Sequence -> ( Sequence, Note, Sequence )
openSequence beat sequence =
    let
        -- TODO: need to get time tfrom measure:
        time =
            Time.common

        blank =
            Note.restFor Duration.quarter

        ( before, rest ) =
            splitSequence beat sequence

        ( note, after ) =
            case List.head rest of
                Nothing ->
                    ( blank, rest )

                Just ( b, n ) ->
                    if b == beat then
                        ( n
                        , Maybe.withDefault [] <| List.tail rest
                        )
                    else
                        ( blank, rest )

        erofeb =
            List.reverse before

        ( prevNote, nextNote ) =
            case List.head erofeb of
                Nothing ->
                    ( Nothing, Nothing )

                Just ( b, n ) ->
                    let
                        beats =
                            Duration.beats time n.duration
                    in
                        if b + beats == beat then
                            ( Nothing, Nothing )
                        else
                            let
                                noteBeats =
                                    Duration.beats time note.duration

                                pre =
                                    beat - b

                                post =
                                    beats - pre - noteBeats
                            in
                                ( if pre /= 0 then
                                    Just
                                        ( b
                                        , { n
                                            | duration = Duration.fromTimeBeats time pre
                                          }
                                        )
                                  else
                                    Nothing
                                , if post /= 0 then
                                    Just
                                        ( beat + noteBeats
                                        , { n
                                            | duration = Duration.fromTimeBeats time post
                                          }
                                        )
                                  else
                                    Nothing
                                )

        earlier =
            case prevNote of
                Nothing ->
                    before

                Just beatnote ->
                    List.reverse <|
                        (::) beatnote <|
                            Maybe.withDefault [] <|
                                List.tail erofeb

        later =
            case nextNote of
                Nothing ->
                    after

                Just beatnote ->
                    beatnote :: after
    in
        ( earlier, note, later )


modifyNote : (Note -> Note) -> Beat -> Measure -> Measure
modifyNote f beat measure =
    let
        sequence =
            toSequence measure

        t =
            time measure

        ( before, note, after ) =
            openSequence beat sequence

        noteBeats =
            Duration.beats t note.duration

        newNote =
            f note

        newBeats =
            Duration.beats t newNote.duration

        delta =
            newBeats - noteBeats

        nowAfter =
            let
                tail =
                    case List.tail after of
                        Nothing ->
                            []

                        Just list ->
                            list
            in
                case List.head after of
                    Nothing ->
                        after

                    Just ( nextBeat, nextNote ) ->
                        let
                            b =
                                Duration.beats t nextNote.duration

                            n =
                                { nextNote
                                    | duration = Duration.fromTimeBeats t (b - delta)
                                }
                        in
                            if b == delta then
                                tail
                            else
                                ( nextBeat + delta, n ) :: tail

        newSequence =
            List.concat
                [ before
                , [ ( beat, f note ) ]
                , nowAfter
                ]
    in
        fromSequence newSequence
