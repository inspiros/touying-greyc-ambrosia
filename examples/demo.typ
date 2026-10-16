#import "../src/lib.typ": *

// A fuller GREYC presentation. Edit these defaults in Tinymist or another IDE.
// The optional CLI inputs exist for rendering the same source in several styles.
#let flavor = "legacy" // the historical cover; try stargazer or minimal as well
#let palette = "greyc-light" // greyc-nocturne, ocean, forest, or another palette
#let team = none // amacc | codag | diamant | electronique | image | mad | safe
#let navigation = "tree" // auto | none | tabs | dots | context | panes | sidebar | segments
#let buttons = true
#let flavor = sys.inputs.at("flavor", default: flavor)
#let level = if flavor == "cambridge" { 3 } else { 2 }
#let navigation = sys.inputs.at("navigation", default: navigation)

#show: greyc-theme.with(
  flavor: flavor, palette: sys.inputs.at("palette", default: palette),
  team: sys.inputs.at("team", default: team), // logos; the palette stays independent
  // team-accent: true, // optional team-color stripe on the legacy cover
  navigation: if navigation == "none" { none } else if navigation == "auto" { auto } else { navigation },
  navigation-buttons: buttons,
  text-size: 18pt, // relative component sizes follow this value
  affiliation-numbering: "*", // "1", "a", and numbering functions also work
  config-info(
    title: [From An Idea To Shared Results],
    subtitle: [A GREYC Ambrosia Presentation],
    authors: (
      (name: [Alex Researcher], affiliations: ("greyc", "unicaen"), email: "alex@example.org"),
      (name: [Sam Collaborator], affiliations: ("greyc", "ensicaen"), email: "sam@example.org"),
    ),
    institutions: (greyc: [GREYC · CNRS], unicaen: [Université de Caen Normandie], ensicaen: [ENSICAEN]),
    short-author: [Researcher & Collaborator], // concise footer metadata
    short-title: [An Idea To Shared Results],
    date: datetime(year: 2026, month: 10, day: 15),
  ),
)

// These local helpers keep Cambridge's === slides and ordinary == slides alike.
#let topic(body) = if level == 3 { heading(depth: 2, body) }
#let frame(body) = heading(depth: level, body)
#let preview(name) = [#metadata(name)<greyc-demo-view>]

#title-slide() // auto preserves the legacy cover; native layouts remain available
#outline-slide(depth: 1)

= A Shared Visual Identity
#topic[The Core Choices]

#frame[One Laboratory, Many Ways To Present]
#grid(columns: (1fr, 1fr), gutter: 1em,
  ambrosia-block(style: "poster", title: [A Familiar Identity])[
    Lab, team, and partner branding stay together.

    - A historical cover, with modern Typst authoring.
    - Linked author affiliations and email addresses.
    - Readable headers and measured footer fields.
  ],
  ambrosia-block(style: "outlined", kind: "info", title: [Your Own Preferences])[
    Choose a #alert[flavor], a #alert[palette], and a navigator independently.

    #muted[The same content can serve a seminar, a lecture, or a project meeting.]
  ],
)

#frame[Color Without Rewriting Content]
// This shows the resolved palette, including explicit color or local overrides.
#ambrosia-palette-showcase(columns: 5, title: [The Colors In This Presentation])

#frame[Navigation That Knows The Structure]
The tree strips above show the talk title and its current ancestors.
The slide title keeps its own row.

#ambrosia-block(style: "stripe", kind: "info", title: [Try It Live])[
  Change `navigation` near the top of this file to `"dots"`, `"context"`,
  `"panes"`, `"sidebar"`, or `none` and preview the same presentation.
]

#muted[The small footer controls link between logical slides. Animation frames share one navigation step.]

= Explain The Main Idea
#topic[Components And Emphasis]

#frame[Containers With A Common Language]
#preview("blocks")
// style controls geometry; kind controls semantic color. Both can vary locally.
#grid(columns: (1fr, 1fr), gutter: 0.8em,
  ambrosia-block(style: "poster", kind: "info", title: [Observation])[
    A clear claim deserves a visible home.

    #ambrosia-badge(kind: "success", shadowed: true)[Reproducible]
  ],
  ambrosia-block(style: "tabbed", kind: "success", title: [Evidence])[
    Keep the result and its explanation together.
  ],
  ambrosia-block(style: "stripe", kind: "warning", title: [Qualification])[
    Show the conditions under which the claim holds.
  ],
  ambrosia-block(style: "outlined", kind: "neutral", title: [Next Question])[
    What would make the evidence stronger?
  ],
)

#frame[Reveal A Nested Argument]
// Touying sees pauses inside Ambrosia blocks; no separate animation API is needed.
#ambrosia-block(style: "poster", title: [Start With A Claim], shadowed: false)[
  State the main observation in one sentence.

  #pause
  #ambrosia-block(style: "outlined", kind: "info", title: [Add The Supporting Reason])[
    Explain the evidence, then make the limitation visible.

    #pause
    #ambrosia-badge(kind: "warning")[Check The Assumptions]
  ]
]

#frame[Give Secondary Information Less Weight]
An #alert[important phrase] should remain easy to locate.

#muted[Secondary context inherits the current font and size.]

#subtle[A brief aside can be quieter without turning unreadable.]

#quote(block: true, attribution: [A Presentation Design Note])[
  Give the audience one clear idea to carry into the next slide.
]

#focus-slide[Make The Central Idea Easy To Remember.]

= Show Evidence And Methods
#topic[Figures, Tables, And Sources]

#frame[Comparable Evidence At A Glance]
#preview("evidence")
// Native grids and figures cover comparisons without needing another slide type.
#grid(columns: (1.2fr, 1fr), gutter: 1em,
  figure(
    grid(columns: (auto, 1fr), row-gutter: 0.7em, column-gutter: 0.5em, align: horizon,
      [Baseline], rect(width: 54%, height: 1em, fill: rgb("8195ad"), stroke: none),
      [Variant], rect(width: 72%, height: 1em, fill: rgb("529baa"), stroke: none),
      [Proposed], rect(width: 88%, height: 1em, fill: rgb("5c9862"), stroke: none),
    ),
    caption: [Illustrative scores on the same scale.],
  ),
  [
    #figure(
      table(columns: (1fr, auto), inset: 0.45em,
        table.header[Method][Score],
        [Baseline], [0.54], [Variant], [0.72], [Proposed], [0.88],
      ),
      caption: [A synthetic comparison.],
    )
    #ambrosia-source-note[Illustrative data; no empirical claim is intended.]
  ],
)

#frame[Code Remains Native Typst Content]
// code-style: "plain" would disable the panel while retaining native raw behavior.
```python
from statistics import mean

def summarize(scores):
    return {"count": len(scores), "mean": mean(scores)}
```
#ambrosia-block(style: "stripe", title: [Keep It Readable])[
  Preserve language highlighting and explain what the audience should notice.
]

#frame[Citation Identities Stay Consistent]
A normal reference @knuth84 and a footnote citation #footcite(<knuth84>)
share their compact identity with the bibliography.

A second publication by the same author and year #footcite(<knuth1984programming>)
receives its own disambiguation suffix.

#ambrosia-source-note[Author–year labels identify sources across slides even when footnote counters restart.]

= Plan The Next Steps
#topic[Timing And Perspective]

#frame[From Discovery To Delivery]
#preview("roadmap")
// Times are elapsed positions in the chosen unit; fractional durations are valid.
#ambrosia-roadmap(
  total: 12, unit: "week", tick-every: 2, now: 4.5,
  phases: (
    (name: [Discover], end: 3, kind: "info"),
    (name: [Build], end: 8, kind: "success"),
    (name: [Share], end: 12, kind: "warning"),
  ),
  milestones: ((at: 5, label: [Review]), (at: 10, label: [Pilot])),
  tasks: (
    (content: [Explore And Specify], start: 0, end: 2.5, kind: "info"),
    (content: [Develop And Evaluate], start: 2.5, end: 8, kind: "success"),
    (content: [Prepare Materials], start: 4, end: 10.5),
    (content: [Pilot And Share], start: 8, end: 12, kind: "warning",
      details: [Gather feedback, document the main decisions, and prepare a short handover.]),
  ),
)

#section-slide(title: [Change Perspective], subtitle: [A Deliberate Pause Before The Conclusion])
#image-slide("../assets/greyc-cover.webp", caption: [Our Research Environment],
  credit: [GREYC], alt: "The building featured on the GREYC legacy cover")

= Bring The Talk Together
#topic[References And Discussion]

#frame[People And Tools]
#preview("credits")
#grid(columns: (1fr, 1fr), gutter: 1em, align: top,
  ambrosia-block(style: "outlined", title: [Acknowledgements])[
    Thanks to collaborators, technical staff, and supporting institutions.

    - Discussion and feedback.
    - Data and infrastructure.
    - Careful review and reproducibility.
  ],
  ambrosia-credit-card(), // static repository QR; qr: false hides it
)

// Native bibliography entries use the same markers as the preceding citations.
#bibliography-slide("bibliography.bib", title: [Selected References])

#ending-slide(layout: "split", title: [Let's Discuss])[
  - Keep the main claim visible.
  - Connect it to comparable evidence.
  - Make the next step easy to find.
]

#show: appendix
= Supporting Material
#topic[Backup Details]
#frame[An Explicit Supporting Detail]
Appendix slides remain visible while the main slide total stays fixed.

#ambrosia-block(style: "framed", title: [Extra Context])[
  Reserve detail for questions without overloading the main argument.
]
#frame[Materials And Links]
#link("https://github.com/inspiros/touying-greyc-ambrosia")[GREYC Ambrosia Source And Examples]

#link("https://github.com/inspiros/touying-ambrosia")[The Neutral Ambrosia Core]
