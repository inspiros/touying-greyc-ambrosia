#import "../src/lib.typ": *

// Edit the defaults in your IDE; optional CLI inputs override them.
#let flavor = "legacy" // legacy | simple | minimal | cambridge | darmstadt | dewdrop | stargazer
#let palette = "greyc-light" // greyc-light | greyc-ivory | greyc-nocturne | greyc-charcoal; core palettes also work
#let team = none // none | amacc | codag | diamant | electronique | image | mad | safe
#show: greyc-theme.with(
  flavor: sys.inputs.at("flavor", default: flavor),
  palette: sys.inputs.at("palette", default: palette),
  team: sys.inputs.at("team", default: team), // logos; the palette stays independent
  // team-accent: true, // optional team-color stripe on the legacy cover
  // font: "DejaVu Sans",
  navigation: "tree",
  config-info(
    title: [Research, In Your Own Flavor],
    subtitle: [One Laboratory. Many Ways To Present.],
    author: [GREYC research team],
    institution: [Université de Caen Normandie · ENSICAEN · CNRS],
    date: datetime(year: 2026, month: 10, day: 13),
  ),
)

#title-slide(layout: auto)

= Research

== Ideas That Stand Out

We share the #greyc identity and choose a style that fits our work.

#grid(columns: (1fr, 1fr), gutter: 1em,
  ambrosia-block(title: [One Clear Idea], shadowed: false)[
    A common set of utilities across seven layouts.
    - Readable typography.
    - Team-specific branding.
    - #alert[Consistent visual hierarchy.]
  ],
  ambrosia-block(style: "framed", title: [Evidence And Context], shadowed: true)[
    Strong presentations connect results to their sources.
    #footcite(<knuth84>)
  ],
)

== Methods And Results

#grid(columns: (1fr, 1fr), gutter: 1em,
  [```python
  def present(idea):
      # A small, readable example
      return {"result": idea}
  ```],
  figure(
    table(columns: (1fr, auto), inset: 0.5em,
      table.header[Method][Score],
      [Baseline], [0.74],
      [Our method], [0.91],
    ),
    caption: [Comparison.]
  ),
)

#hidden-bibliography("bibliography.bib")

#ending-slide(title: [Let's Discuss])[
  Questions, comments, and new ideas.
]

#show: appendix

== Supporting Details

This appendix remains available without increasing the main slide total.

#ambrosia-credit-card()
