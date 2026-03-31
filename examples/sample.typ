#import "@preview/touying:0.6.2": *
#import "../src/lib.typ": *

// legacy | simple | cambridge | darmstadt | dewdrop | stargazer
#let flavor = "legacy"

#show: greyc-theme.with(
  flavor: flavor,
  aspect-ratio: "16-9",
  config-info(
    title: [theme: greyc-theme],
    subtitle: [flavor: #flavor],
    author: [Hoang-Nhat Tran#super[1]],
    date: datetime.today(),
    institution: [#super[1]SAFE team, GREYC laboratory, University Caen Normandy],
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

#tblock(title: [Sample Block Title])[
  This text is enclosed in a block, usage:
  ```typ
  #tblock(title: [Block title])[Block content]
  ```
]

#hidden-bibliography("bibliography.bib", style: "ieee")
