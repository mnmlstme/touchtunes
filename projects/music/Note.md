---
title: Notes (🎶) in Elm
platform: elm
imports:
  Duration: Music.Models.Duration
  Key: Music.Models.Key
  Layout: Music.Models.Layout
  Measure: Music.Models.Measure
  MV: Music.Views.MeasureView
  Note: Music.Models.Note
  Pitch: Music.Models.Pitch
  Staff: Music.Models.Staff
  Time: Music.Models.Time
model:
  time: [4, 4]
  key: C
  mode: Major
---

```elm
Html.div [ class "hi" ]
  [
    let
      attributes = Measure.Attributes
        (Just Staff.Treble)
        (Just Time.common)
        (Just <| Key.keyOf Key.C Key.Major)
      notes =
        [ Pitch.c 4 |> Note.playFor Duration.quarter ]
      measure =
        Measure.fromNotes Measure.noAttributes notes
      layout =
        Layout.forMeasure attributes measure
    in
    MV.view layout measure
  ]
```

# Introduction

We can write Html expressions in Elm and have them rendered.

### subtitle

We can also pull in CSS classes and reference them using the `class` attribute.

```css
.hi {
  font-family: Georgia;
  color: #835cf0;
  font-size: 4rem;
}
```

---
