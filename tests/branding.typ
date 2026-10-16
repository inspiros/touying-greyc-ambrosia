#import "../src/lib.typ": *
#let mode = sys.inputs.at("primary", default: "auto")
#let layout = sys.inputs.at("layout", default: "auto")
#let primary(team) = self => branding.logo(team: team,
  light: palettes.prefer-light(self.store.at("logo-background", default: self.page.fill)))
#show: greyc-theme.with(
  palette: sys.inputs.at("palette", default: "greyc-light"),
  team: sys.inputs.at("team", default: none),
  team-accent: sys.inputs.at("team-accent", default: "false") == "true",
  ..if "brand-color" in sys.inputs { (brand-color: rgb(sys.inputs.at("brand-color")),) } else { (:) },
  primary-logos: if mode == "multiple" { (primary(none), primary("safe")) }
    else if mode == "none" { none } else { auto },
  title-layout: if layout == "auto" { auto } else { layout },
  config-info(title: [Collaborative Branding], author: [Research Team]),
)
#title-slide()
#slide(title: [Ordinary Content], self => context [
  #metadata(self.colors)<greyc-palette-probe>
  BODY
])
