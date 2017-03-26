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
            Note.blankFor Duration.whole


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
            Note.blankFor Duration.quarter

        ( before, rest ) =
            splitSequence beat sequence

        ( note, after, insertion ) =
            case List.head rest of
                Nothing ->
                    ( blank, rest, Nothing )

                Just ( b, n ) ->
                    if b == beat then
                        case n.do of
                            Note.Blank ->
                                let
                                    beats =
                                        Duration.beats time n.duration

                                    bbeats =
                                        Duration.beats time blank.duration

                                    remainder =
                                        beats - bbeats

                                    insertion =
                                        if remainder > 0 then
                                            Just
                                                ( b + bbeats
                                                , { n | duration = Duration.fromTimeBeats time remainder }
                                                )
                                        else
                                            Nothing
                                in
                                    ( blank
                                    , Maybe.withDefault [] <| List.tail rest
                                    , insertion
                                    )

                            _ ->
                                ( n
                                , Maybe.withDefault [] <| List.tail rest
                                , Nothing
                                )
                    else
                        ( blank, rest, Nothing )

        erofeb =
            List.reverse before

        ( prevNote, nextNote ) =
            case List.head erofeb of
                Nothing ->
                    ( Nothing, insertion )

                Just ( b, n ) ->
                    let
                        beats =
                            Duration.beats time n.duration
                    in
                        if b + beats == beat then
                            ( Nothing, insertion )
                        else
                            let
                                noteBeats =
                                    Duration.beats time note.duration

                                pre =
                                    beat - b

                                post =
                                    beats - pre - noteBeats

                                what =
                                    case n.do of
                                        Note.Blank ->
                                            Note.Rest

                                        _ ->
                                            n.do
                            in
                                ( if pre /= 0 then
                                    Just
                                        ( b
                                        , { n
                                            | duration = Duration.fromTimeBeats time pre
                                            , do = what
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

        ( before, note, after ) =
            openSequence beat sequence

        newSequence =
            List.concat
                [ before
                , [ ( beat, f note ) ]
                , after
                ]
    in
        fromSequence newSequence
