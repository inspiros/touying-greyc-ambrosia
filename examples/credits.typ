#import "@preview/touying-greyc-ambrosia:0.2.0": *

// Edit these defaults in your IDE; no QR-generation step is required.
#let palette = "greyc-light" // try greyc-charcoal for a dark surface
#let show-qr = true // false releases the QR column
#show: greyc-theme.with(flavor: "minimal",
  palette: sys.inputs.at("palette", default: palette),
  config-info(title: [People, Laboratory, And Tools], author: [Presenter]),
  config-common(new-section-slide-fn: none))

// An information card is the existing renderer with a different identity.
// The lab website and the package repository have separate URLs and QR codes.
#let lab = (
  name: "GREYC Laboratory",
  url: "https://www.greyc.fr/",
  logo: self => context branding.logo(lang: text.lang,
    light: palettes.prefer-light(self.store.logo-background)),
  qr: self => block(fill: white, inset: 0.35em,
    image(assets.read-asset(assets.asset-paths.lab-qr), width: 100%)),
)

#slide(title: [About The Laboratory])[
  // A standard dark-on-white code works on either palette. The extra backing
  // leaves space around the official artwork on light and dark surfaces.
  #ambrosia-credit-card(project: lab, title: [Research At GREYC],
    link-label: [Visit The Laboratory], qr: show-qr, qr-size: 6em, width: 85%)
]

#slide(title: [How These Slides Were Made])[
  // The default identity still points to the package source, never the lab site.
  #ambrosia-credit-card(qr: show-qr, width: 85%)
]
