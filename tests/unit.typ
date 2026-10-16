#import "../src/lib.typ": *
#import "../src/core.typ" as core
#import "../src/theme/flavors.typ": flavor-names, get-flavor
#assert.eq(config-info, ambrosia.config-info)
#assert.eq(config-info, core.config-info)
#assert.eq(config-info(), (info: (:)))
#assert.eq(ambrosia.config-info(authors: none).info, (authors: none))
#assert.eq(flavor-names.len(), 8)
#assert.eq(type(get-flavor("legacy").title-renderer), function)
#assert.eq(colors.primary, rgb("631058"))
#assert.eq(palettes.resolve("greyc-light").accent, colors.primary)
#assert.eq(palettes.resolve("greyc-light").primary-lightest, colors.tertiary)
#assert.eq(palettes.palette-names.len(), core.palettes.palette-names.len() + 4)
#for (name, dark) in (("greyc-light", false), ("greyc-ivory", false), ("greyc-nocturne", true), ("greyc-charcoal", true)) {
  let palette = palettes.resolve(name)
  assert.eq(palette.dark, dark)
  assert.eq(palette.name, name)
  assert.eq(palettes.definition(name).accent, colors.primary)
  // Palette roles must stay legible on page, container, and alternate surfaces.
  for background in (palette.background, palette.surface, palette.surface-alt) {
    for role in ("foreground", "muted", "accent", "info", "success", "warning", "danger") {
      assert(core.palettes.contrast(palette.at(role), background) >= 4.5,
        message: name + ": unreadable " + role)
    }
  }
  let custom = ambrosia.palette(base: name, name: "Lab variation", primary: rgb("246844"))
  assert.eq(palettes.resolve(custom).background, palette.background)
  assert.eq(custom.accent, rgb("246844"))
}
#assert.ne(palettes.resolve("greyc-ivory").background, palettes.resolve("greyc-light").background)
#assert.ne(palettes.resolve("greyc-charcoal").background, palettes.resolve("greyc-nocturne").background)
#for name in core.palettes.palette-names {
  assert.eq(palettes.resolve(name), core.palettes.resolve(name))
}
#let customized = ambrosia.palette(base: "greyc-light", name: "Lab custom", primary: rgb("246844"))
#assert.eq(customized.name, "Lab custom")
#assert.eq(palettes.resolve(customized).accent.to-hex(), "#246844")
#assert.eq(branding.normalize-team(" ÉLECTRONIQUE "), "electronique")
#assert.eq(branding.normalize-team("elec"), "electronique")
#assert.eq(branding.normalize-team("SAFE"), "safe")
#assert.eq(branding.normalize-team(" DIAMANT "), "diamant")
#assert.eq(branding.team-color("diamant"), rgb("077c88"))
#assert.eq(branding.team-names, assets.asset-paths.logo-teams.keys())
#for team in (none,) + branding.team-names {
  if team != none { assert.eq(type(branding.team-color(team)), color) }
  for variant in ("full", "small") {
    let normal = lower(branding.logo-data(team: team, variant: variant))
    let light = lower(branding.logo-data(team: team, variant: variant, light: true))
    assert(light.contains("#fbf7f8") and not light.contains("#78216b"))
    if team != none {
      for match in normal.matches(regex("#[a-f0-9]{6}")) {
        if match.text != "#78216b" { assert(light.contains(match.text), message: "Light logos must preserve team accents.") }
      }
    }
  }
}
#let mark = lower(str(branding.watermark-data(rgb("123456"))))
#assert(mark.contains("#123456") and not mark.contains("#78216b"))
GREYC assertions passed.
