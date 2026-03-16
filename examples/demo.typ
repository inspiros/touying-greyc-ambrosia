#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.4.1" as th
#import th.cosmos.clouds as thc
// #import th.cosmos.fancy as thc
// #import th.cosmos.rainbow as thc
#show: th.show-theorion
#import "@preview/codly:1.3.0": *

#set text(lang: "en")
#set par(justify: true)
#set heading(numbering: numbly("{1}.", default: "1.1"))

#import "../src/lib.typ": *
#show: greyc-theme.with(
  // legacy | cambridge | darmstadt | dewdrop | stargazer
  flavor: "cambridge",
  aspect-ratio: "16-9",
  config-info(
    title: [GREYC Ambrosia Theme for Typst],
    subtitle: [Customize Your Slide Subtitle Here],
    author: [Hoang-Nhat TRAN],
    date: datetime.today(),
    institution: [GREYC, Université de Caen Normandie],
    email: [hoang-nhat.tran\@unicaen.fr],
  ),
)

#title-slide()

#[
  #set heading(numbering: none)
  === Introduction

  This #greyc theme comes with different flavors, which can be set by changing the `flavor` parameter when initialized:
  ```typ
  #show: greyc-theme.with(
    flavor: "legacy",  // legacy | gazer | dewdrop | cambridge | darmstadt
    ..)
  ```
]

#outline-slide()

= Showcase I

== Basics

=== Figure

- The logo of the is shown in @fig:lab-logo. I dispise its color but I have no choice.
#context {
  let logo_mapping = (
    en: assets.asset-paths.logo-greyc.en,
    fr: assets.asset-paths.logo-greyc.fr,
  )
  [
    #figure(
      image(
        logo_mapping.at(text.lang, default: logo_mapping.en),
        width: 40%,
      ),
      caption: [
        Logo of the lab, adapting to the language.
      ],
    ) <fig:lab-logo>
  ]
}
- Lab website: #link("https://www.greyc.fr").

=== Table

Research groups and their respective sizes are listed alphabetically in @tab:tab1.

#figure(
  caption: [Number of permanent members in each research team of the lab, as of #datetime.today().display("[day]/[month]/[year]").],
  table(
    // settings and potentially move them into a set rule.
    columns: (auto, auto),
    align: (left, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) } else if y == 6 { (bottom: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0 { rgb("#efefef") },

    table.header[#strong[Équipe]][\#members $arrow.t$],
    [AMACC], [12],
    [CODAG], [14],
    [ÉLECTRIQUE], [24],
    [IMAGE], [21],
    [MAD], [10],
    [SAFE], [13],
  ),
) <tab:tab1>

#th.note-box[
  You may notice that the header of the slide consists of the last 2#super[nd] level header and the titles of all visible 3#super[rd] level headers (or the last one if none is visible).

  To surpress all slide subtitles, init with ```typ subtitle: none```.
]

#slide(
  subtitle: text(fill: orange.lighten(10%))[
    A Cool Subtitle
  ],
)[
  === Double-column layout
  The #alert[ReLU] activation computes its output as follows:

  $
  y = cases(
    x quad "if" x > 0,
    0 quad "otherwise",
  )
  $

  *Some properties:*
  + Solves vanishing gradient.
  + Induces sparsity.
  + Is almost zero-cost, making it become the most widely adopted non-linearity.
][
  An example usage of `relu` activation function in PyTorch:
  ```py
  import torch
  import torch.nn.functional as F

  x = torch.randn(3, 10)
  y = F.relu(x)
  assert y[x < 0].eq(0).all()
  assert y[x >= 0].equal(x[x >= 0])
  ```
]

// #import "theme/assets.typ" as assets
// #image(bytes(assets.transparentize-svg(
//   assets.colorize-svg(assets.asset-paths.logo-greyc.en,
//   source: colors.logo, target: red),
//   opacity: 0.5)), width: 50%)


== Animations
=== `pause` and `meanwhile`

Slide is empty.

#pause

But this is actually not true, just something hidden.

#meanwhile

This seems true.

---

=== Alternatives

```typ #pause``` and ```typ #meanwhile``` are sometimes not enough, let's check the other options we have.

#uncover("2-")[#emoji.face.devil]

This
#alternatives-cases(("1, 3", "2"), case => [
  #set text(fill: teal, weight: "medium") if case == 1
  text
])
changes styling depending on the subslide it is in, thanks to ```typ #alternative-cases```.

#alternatives-match((
  "1, 3": [A #emoji.cake is served on subslide 1 and 3.],
  "2": [A #emoji.cupcake is served only on subslide 2.],
))

= Showcase II

#focus-slide()[
  Focus Here!
]

== Blocks and `theorion` boxes

#tblock(title: [=== Block], fill: green.darken(30%))[
  The title of a block can be either a text, a heading, or ```typ none```. Usage:
  #show: codly-init.with()
  ```typ
  #tblock(title: [=== Section Title], fill: rgb(0, 255, 0).darken(30%))[
    Section content, containing something #emph[interesting].
    - blah.
    - blah blah.
  ]
  ```
]

#grid(columns: (1fr, 1fr), column-gutter: 0.2em,
  tblock(title: [Another Simple Block], fill: blue)[
    Content blocks are very practical.
    - It helps organizing contents.
    - It looks #alert[beautiful].
  ],
  framed-tblock(title: [A Framed Block], fill: red.darken(50%))[
    Two variants are offered by the theme:
    + ```typ #tblock```
    + ```typ #framed-tblock```
  ],
)

---

=== `theorion`

For referenceable theorems, you should instead rely on the `theorion` library.

#greyc-components.shadow[
  #thc.definition(title: [Prime number])[
  A whole number greater than 1 that cannot be exactly divided by any whole number other than itself and 1.
] <def:prime>
]

#thc.theorem(title: [Euclid's Theorem])[
  There are infinitely many prime numbers.
] <thm:euclid>

#th.proof[
  @thm:euclid is self-explainatory.
]

#th.example[
  2, 3, 5, 7, 11, 13, 17, ...
]

#th.quote-box[
  I hope you want to use this template already. - Author
]

== Citation

Aside from the #emph[\@citation] @einstein1905, we can use ```typ #footcite``` to show citation in the footnote.

#footcite(<einstein1905>) would love #footcite(<knuth84>)'s impressive work if he was still alive.
#speaker-note[A secret note.]

#th.important-box[
  To cite, you must include somewhere in your document either a bibliography slide:
  ```typ
  #bibliography-slide("refs.bib", style: "ieee")
  ```
  or a hidden bibliography if you don't want an extra slide:
  ```typ
  #hidden-bibliography("bibliography.bib", style: "ieee")
  ```
]

---

#footcite(<einstein1905>) would not agree with the claim of #footcite(<vaswani2017attention>), for sure.

#th.tip-box[
  By default, references that are already cited in previous slides will not be footnoted again.

  If you want their footnotes to be shown in all slides they are mentioned, initialize the theme with ```typ footcite-once: false```.
]

#th.caution-box[
  ```typ #footcite``` is a limited hack and sometimes link might not work as expected, _unpredictably_.
  Do not use it with citation styles like `chicago-notes` or the footnote will be a mess.
]

#bibliography-slide("bibliography.bib", style: "ieee")
// #hidden-bibliography("bibliography.bib", style: "ieee")

#ending-slide(title: "The End")[
  Thanks for nothing!
]

#show: appendix

// = Appendix

== Backup Slides

To apply the show rules for the appendix, include this line right after the final slide:

#{
  show: codly-init.with()
  codly(
    highlights: (
      (line: 2, start: none, end: none, fill: red.transparentize(50%)),
    ),
  )
  ```typ
  #ending-slide()[Thanks for listening!]
  #show: appendix
  == Appendix
  ...
  ```
}
