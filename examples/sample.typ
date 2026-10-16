#import "../src/lib.typ": *

// Edit these defaults in your IDE. CLI inputs optionally override them.
// Geometry: legacy | simple | cambridge | darmstadt | dewdrop | stargazer | minimal | portico
#let flavor = "legacy"
#let flavor = sys.inputs.at("flavor", default: flavor)
#let palette = "greyc-light" // greyc-light | greyc-ivory | greyc-nocturne | greyc-charcoal; core palettes also work
#let palette = sys.inputs.at("palette", default: palette)
#let team = none // or a team ID such as "safe"

#show: greyc-theme.with(
  flavor: flavor,
  palette: palette,
  team: sys.inputs.at("team", default: team),
  aspect-ratio: "16-9",
  config-info(
    title: [GREYC Ambrosia],
    subtitle: [Flavor: #flavor · Palette: #palette],
    authors: ((name: [Hoang-Nhat Tran], affiliations: ("lab",)),),
    date: datetime(year: 2026, month: 10, day: 15),
    institutions: (lab: [GREYC Laboratory, University Caen Normandy]),
  ),
)

#title-slide()

= Sample Section

== Sample Frame Title

=== Sample Header

This text is in the second frame#footnote[This is a sample footnote.].
For the sake of showing an example.

- This is a sample list.
- #footcite(<knuth84>) is a sample footnote citation using ```typ #footcite```.

#ambrosia-block(title: [Sample Block Title])[
  This text is enclosed in a block, usage:
  ```typ
  #ambrosia-block(title: [Block Title])[Block content]
  ```
]

#hidden-bibliography("bibliography.bib", style: "ieee")
