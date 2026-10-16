#import "../src/lib.typ": *

// Exercise the shared header independently of cover/ending compositions.
#let flavor = sys.inputs.at("flavor", default: "dewdrop")
#let choice = sys.inputs.at("navigation", default: "auto")
#let mode = sys.inputs.at("mode", default: "slides")
#let mark = sys.inputs.at("mark", default: "auto")
#let sides = (left: left, right: right, top: top, bottom: bottom)
#let options = { if mark == "none" { (header-logo: none) }
  else if mark == "custom" { (header-logo: self => box(width: 40em, height: 1em, fill: self.colors.primary)) }
  else if mark == "multiple" { (primary-logos: (
    self => box(width: 3em, height: 1em, fill: self.colors.primary),
    self => box(width: 4em, height: 1em, fill: self.colors.primary),
  )) } else { (:) } }
#show: greyc-theme.with(
  flavor: flavor,
  palette: sys.inputs.at("palette", default: "greyc-light"),
  team: sys.inputs.at("team", default: none),
  navigation: if choice == "auto" { auto } else if choice == "none" { none } else { choice },
  ..options,
  config-common(slide-level: 2, new-section-slide-fn: none,
    handout: mode == "handout", show-only-notes: mode == "notes", article-mode: mode == "article",
    show-notes-on-second-screen: if mode == "second-screen" {
      sides.at(sys.inputs.at("notes-side", default: "right"))
    } else { none }),
  config-info(title: [Header Branding], author: [Presenter]),
)
#let probe() = layout(size => context [#metadata((width: size.width.pt(), height: size.height.pt()))<header-test-body>])
#if sys.inputs.at("roots", default: "true") == "true" { heading(depth: 1)[SectionOne] }
== CurrentSlide
#probe()
BODYMARKER
#speaker-note[Speaker Notes]
== NextSlide
#probe()
Another slide.
