#import "../src/lib.typ": branding, palettes

// A reusable branding sheet. Edit the palette and inspect the logos in your IDE.
#let palette = "greyc-light" // try greyc-nocturne to inspect the light variants
#let colors = palettes.resolve(sys.inputs.at("palette", default: palette))
#set page(width: 960pt, height: auto, margin: 18pt, fill: colors.background)
#set text(font: "DejaVu Sans", size: 14pt, fill: colors.foreground)
#set par(justify: false)
#grid(columns: (1fr,) * 3, gutter: 12pt,
  ..branding.team-names.enumerate().map(((i, team)) => grid.cell(
    x: if i == branding.team-names.len() - 1 and calc.rem(branding.team-names.len(), 3) == 1 { 1 } else { auto },
    block(height: 105pt, width: 100%, inset: 12pt,
      radius: 5pt, fill: colors.surface, stroke: 0.6pt + colors.border, {
        align(center + horizon)[
          #branding.logo(team: team, width: 100%, height: 52pt, fit: "contain",
            light: palettes.prefer-light(colors.surface))
          #v(8pt)
          #text(size: 11pt, weight: "semibold", upper(team))
        ]
      }))),
)
