#import "../src/lib.typ": *
#let mode = sys.inputs.at("mode", default: "defaults")
#let custom = mode != "defaults"
#show: greyc-theme.with(
  flavor: "minimal",
  ..if custom { (
    outline-fill: none,
    logos: none, primary-logos: none, header-logo: none, logo-focus: none,
    watermark-logo: none, text-size: 16pt, navigation: "tree",
    title: self => [Custom Slide Heading], subtitle: none,
    footer-aa: self => [Custom Footer],
    title-logo-distribution: "equal",
  ) } else { (:) },
  config-common(new-section-slide-fn: none),
  config-info(title: [Theme Options], author: [Presenter]),
  ..if mode == "overrides" { (config-store(text-size: 17pt, navigation: none),) } else { () },
)
#title-slide()
= Test Section
== Native Heading
#slide(self => context [
  #metadata((
    text-size: self.store.text-size.pt(),
    navigation: self.store.navigation,
    no-outline-fill: self.store.outline-fill == none,
    distribution: self.store.title-logo-distribution,
    logos: if self.store.logos == none { 0 } else { self.store.logos.len() },
    primary: self.store.primary-logos == none,
    header: self.store.header-logo == none,
    watermark: self.store.watermark-logo == none,
  ))<greyc-options>
  Option forwarding and configuration precedence.
])
