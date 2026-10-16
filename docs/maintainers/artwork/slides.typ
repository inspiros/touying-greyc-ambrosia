#import "../../../src/lib.typ": *

// Real slides used by the README hero. Change view in an IDE to inspect them.
// All branding and navigation use the package's public API.
#let view = sys.inputs.at("view", default: "legacy") // legacy | team | modern
#let flavor = if view == "legacy" { "legacy" } else if view == "team" { "stargazer" } else { "minimal" }
#let level = if flavor == "cambridge" { 3 } else { 2 }
#let team = if view == "team" { "diamant" } else if view == "modern" { "safe" } else { none }
#let palette = if view == "legacy" { "greyc-light" } else if view == "team" { "midnight" } else { "ocean" }
#let colors = palettes.resolve(palette)
#show: greyc-theme.with(
  flavor: flavor,
  palette: palette,
  team: team,
  navigation: if view == "team" { "tabs" } else if view == "modern" { "tree" } else { none },
  font: "DejaVu Sans",
  config-common(new-section-slide-fn: none),
  config-info(title: [Research In Your Own Flavor],
    subtitle: [A Shared Visual Identity], author: [Alex Researcher],
    institution: [GREYC · Université de Caen Normandie · ENSICAEN · CNRS],
    short-title: [A Shared Identity],
  ),
)
#if view == "legacy" {
  title-slide()
} else [
  = Research
  #heading(depth: level)[One Shared Identity]
  #grid(columns: (auto, 1fr), gutter: 0.7em, align: horizon,
    branding.logo(team: team, height: 1.6em, light: palettes.prefer-light(colors.background)),
    text(size: 0.65em, fill: colors.muted)[#upper(team) · A Palette Of Your Own],
  )
  #v(0.7em)
  #grid(columns: (1fr, 1fr), gutter: 1em,
    [
      #ambrosia-block(style: "poster", title: [Observation])[
        A common theme, adapted to your team and your audience.
      ]
      #v(0.6em)
      #ambrosia-badge(kind: "success")[Your Team. Your Palette.]
    ],
    [
      #ambrosia-block(style: "stripe", kind: "info", title: [Make It Yours])[
        - Keep the lab identity.
        - Choose a layout.
        - Set your colors.
      ]
    ],
  )
  = Perspectives
  #heading(depth: level)[Share The Result]
  Clear evidence. A recognizable identity.
]
