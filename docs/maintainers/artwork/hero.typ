#import "../../../src/lib.typ": ambrosia-shadow

// SVG README artwork, separate from the manifest's initialized-template PNG.
// The miniature slides are bundled renders; this file previews directly in an IDE.
// Refresh everything with `python3 scripts/render-thumbnail.py`.
#set text(font: "Inter", size: 18pt, fill: rgb("fbf7f8"))
#let unit = 1em / 18
#set page(width: 960 * unit, height: 540 * unit, margin: 0em, fill: rgb("281326"))
#set par(leading: 0.4em)

#place(top + left, dx: -130 * unit, dy: -50 * unit,
  circle(width: 680 * unit, stroke: none,
    fill: gradient.radial(rgb("a335862e"), rgb("a3358600"))))
#place(bottom + right, dx: 70 * unit, dy: 180 * unit,
  circle(width: 830 * unit, stroke: none,
    fill: gradient.radial(rgb("78216b80"), rgb("78216b00"))))
#place(top + right, dx: 160 * unit, dy: -230 * unit,
  circle(width: 720 * unit, stroke: none,
    fill: gradient.radial(rgb("21adf22b"), rgb("21adf200"))))

#let card(name, x, y, width, angle) = place(top + left, dx: x * unit, dy: y * unit,
  rotate(angle, reflow: false,
    ambrosia-shadow(radius: 7 * unit, blur: 16 * unit, dx: 0em, dy: 8 * unit,
      fill: rgb("10061180"),
      block(width: width * unit, height: width * unit * 9 / 16,
        radius: 7 * unit, clip: true, stroke: 0.65 * unit + rgb("fbf7f85c"),
        image("../../../assets/gallery/hero-" + name + ".webp", width: 100%, height: 100%)))))

#card("team", 486, 36, 390, -10deg)
#card("modern", 442, 159, 420, 6deg)
#card("legacy", 475, 279, 425, -5deg)

#place(top + left, dx: 51 * unit, dy: 49 * unit,
  text(size: 12 * unit, weight: "medium", tracking: 0.15em, fill: rgb("dec7db"))[TYPST × TOUYING])
#place(top + left, dx: 35 * unit, dy: 85 * unit,
  image("../../../assets/logos/touying-greyc-ambrosia-dark.svg", height: 190 * unit))
#place(top + left, dx: 51 * unit, dy: 279 * unit,
  text(size: 16 * unit, weight: "medium", tracking: 0.03em)[touying])
#place(top + left, dx: 47 * unit, dy: 302 * unit,
  text(size: 50 * unit, weight: "bold", tracking: -0.04em)[GREYC])
#place(top + left, dx: 47 * unit, dy: 356 * unit,
  text(size: 47 * unit, weight: "bold", tracking: -0.04em)[Ambrosia])
#place(top + left, dx: 52 * unit, dy: 426 * unit,
  text(size: 18 * unit, fill: rgb("dec7db"))[One Lab. Many Flavors.])
#place(top + left, dx: 53 * unit, dy: 478 * unit,
  rect(width: 247 * unit, height: 5 * unit, radius: 3 * unit, stroke: none,
    fill: gradient.linear(rgb("78216b"), rgb("a15bd5"), rgb("e14f4f"), rgb("6bb540"), rgb("21adf2"))))
#place(top + left, dx: 53 * unit, dy: 499 * unit,
  text(size: 10 * unit, weight: "medium", fill: rgb("c7abc5"))[
    Legacy · Team Branding · Every Palette
  ])
