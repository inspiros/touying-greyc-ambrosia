# Flavors, Palettes, And Branding

Version 0.2.0 requires Typst 0.15+, Touying 0.8.0, and Touying Ambrosia 0.1.0. For checkout development, the installer defaults to `@local`; published presentations use the import below.

```typst
#import "@preview/touying-greyc-ambrosia:0.2.0": *
#show: greyc-theme.with(
  flavor: "minimal",
  palette: "greyc-nocturne",
  team: "safe",
  font: "DejaVu Sans",
  config-info(title: [A Research Presentation], author: [Your Name]),
)
#title-slide()
```

## Choose Independently

`flavor` selects geometry and component defaults. GREYC offers `legacy` plus
the core's seven flavors: `minimal`, `simple`, `cambridge`, `darmstadt`,
`dewdrop`, `stargazer`, and `portico`. The default is `legacy`; structural
navigation can be chosen independently of every flavor.

`palette` selects colors independently. Four lab presets supplement the twelve neutral core palettes. All four use GREYC purple as their accent seed, adjusted for readable contrast on their surfaces. Any palette works with any flavor:

| Light palette | Character | Dark palette | Character |
| --- | --- | --- | --- |
| `greyc-light` (default) | White with GREYC purple | `greyc-nocturne` | Cool blue-gray with GREYC purple |
| `greyc-ivory` | Warm paper with soft plum surfaces | `greyc-charcoal` | Neutral dark gray with GREYC purple |
| `ocean` | Cool blue | `midnight` | Navy with blue |
| `forest` | Soft green | `evergreen` | Deep green with mint |
| `sand` | Warm ivory with terracotta | `ember` | Warm brown with amber |
| `rose` | Pale rose with plum | `nebula` | Deep purple with mauve |
| `slate` | Restrained blue-gray | `graphite` | Neutral gray |

Dark palettes supply light text, subtle surfaces, readable accents, and matching
code highlighting. For example, `flavor: "cambridge", palette: "nebula"`
retains Cambridge's context navigator and level-three slide headings with
purple dark surfaces. `nocturne` and `nebula` are palettes, not flavors.

`team` selects the team logos without changing any palette color. Use `amacc`, `codag`, `diamant`, `electronique`, `image`, `mad`, or `safe`. Names are case-insensitive; `elec` and `électronique` also select ELECTRONIQUE. Omit the option or use `none` for the lab-wide identity. The default is logos only. `team-accent: true` optionally adds a thin vertical stripe in the team's original color to the legacy title slide; other title layouts keep their native geometry.

Full marks appear on title slides; compact team marks fit slide headers. Logo variants follow their actual surface, including dark navigation bands on light pages and the legacy cover. On dark backgrounds, only the primary purple `#78216B` becomes `#FBF7F8`. Team accent colors and the other SVG data remain intact. Lab logos choose French/English wording from `text.lang`.

Palette accents are adjusted for readable text contrast: darkened on light pages and lightened on dark pages. To deliberately use a team's color as the main accent, pass `brand-color: branding.team-color("diamant")` or build a palette descriptor with that primary. An explicit `config-colors(primary: ...)` takes precedence.

Team color works well as a small identity accent without reassigning semantic palette roles:

```typst
#ambrosia-badge(fill: branding.team-color("diamant"))[DIAMANT]
```

The badge chooses readable text for that fill. Use it on a team introduction or closing slide; normal content can rely on the accent already present in the logo.

## Typography And Custom Colors

`font: auto` retains the document's font choice. `mono-font` defaults to `DejaVu Sans Mono`, and `text-size` defaults to **18pt**. Table text defaults to `0.85em`, figure captions to `0.8em`, and footnotes to `0.65em`; customize these through `table-text-size`, `caption-text-size`, and `footnote-text-size`. Set these in `greyc-theme` or `ambrosia-theme`.

Theme spacing, header/footer decorations, logo frames, block radii, and shadows use `em`, so they scale with the surrounding text size. Page proportions and widths retain percentage/fraction units. The shadow renderer resolves relative lengths before generating its SVG.

The semantic color roles include `background`, `foreground`, `surface`, `surface-alt`, `muted`, `border`, and `on-accent`, alongside Touying's `primary` family. `info`, `success`, `warning`, `danger`, and `neutral` provide readable accents for block and badge kinds. `accent-strong`/`on-accent-strong`, `chrome`/`on-chrome`/`chrome-muted`, and `cover`/`on-cover` supply paired colors for accent cards, navigation bands, and the legacy cover. Preset text/accent roles are checked for at least 4.5:1 contrast on their associated surfaces. For example:

```typst
#show: greyc-theme.with(
  flavor: "minimal",
  palette: "greyc-nocturne",
  team: "image",
  config-colors(primary: rgb("a9d9f0"), surface: rgb("203344")),
  config-info(title: [Custom Presentation], author: [Presenter]),
)
```

Palette colors are resolved from the chosen palette and explicit color overrides; flavor presets choose how to use those roles. Explicit user configurations and then per-slide overrides take precedence. Custom colors can change contrast and should be reviewed. Existing options such as `header-logo`, `logos` (institution partners), `logo-focus`, and `config-info(logo: ..., logo-light: ...)` remain available for their respective placements.

## Keep Title Metadata On One Page

Title slides fit their content as a single unit. Short titles retain their original size; dense titles reduce the text and its `em` spacing together, down to `title-min-scale: 65%` by default. If content still cannot fit, compilation reports a clear error instead of moving the date onto another page. Shorten metadata, choose a smaller base size, lower the minimum scale, or provide your own title slide.

```typst
#show: greyc-theme.with(
  flavor: "minimal", palette: "nebula", text-size: 18pt,
  title-fit: true, title-min-scale: 65%,
  config-info(title: [Title], author: [Presenter]),
)
#title-slide(min-scale: 60%)  // override this title only
```

Use `title-fit: false` globally or `title-slide(fit: false)` to take responsibility for sizing yourself. Custom metadata with fixed absolute dimensions cannot shrink automatically; use relative sizes when possible.

`examples/branding.typ` demonstrates the palettes, team identity, blocks, code, a table, citation footnotes, and appendix. Compile alternatives with `--input flavor=stargazer --input palette=nebula --input team=image`.

The core's [title-layout presets](https://github.com/inspiros/touying-ambrosia/blob/master/docs/title-layouts.md) work here too. `greyc-theme(title-layout: "header", ...)` uses a native cover with GREYC/team and partner logos in the top band. A per-slide `title-slide(layout: "split", ...)` changes only that opening. Leave `title-layout: auto` to retain the legacy custom cover. Native `title-logos` / per-slide `logos` replaces the complete ordered title logo list.

`title-layout: "featured"` promotes the first logo (GREYC/team in the automatic
collection) above the title and places the four partners in a smaller row below
the metadata. Shared [ending layouts](https://github.com/inspiros/touying-ambrosia/blob/master/docs/ending-layouts.md)
offer centered, plain, split takeaway/contact, and cover compositions through
theme `ending-layout` or per-slide `ending-slide(layout: ...)`.

The core's [palette example](https://github.com/inspiros/touying-ambrosia/blob/master/examples/palettes.typ) and [utilities example](https://github.com/inspiros/touying-ambrosia/blob/master/examples/utilities.typ) demonstrate shared color and component options.

## Decorative Watermarks

GREYC's compact symbol appears as a quiet, cropped background mark on title, outline, and default section slides in `simple`, `dewdrop`, and `minimal`. Other flavors retain their existing decoration; the photograph-based legacy cover stays uncluttered.

`watermark: false` disables page watermarks globally. `watermark: true` enables them for title/outline/section slides in other layouts. A helper's `watermark: false` or `true` overrides its preset. An explicitly enabled legacy-cover mark appears above its photograph; it is off by default.

The default mark is 50% of page height, with 25% of its width and 20% of its height beyond the bottom-right border. Its 5.5% opacity keeps it behind the content. Customize `watermark-height` and `watermark-opacity`. The tint follows the actual background, including dark palettes. A monochrome copy is generated from the cached SVG; the source logo remains intact.

`ambrosia-theme` has no GREYC watermark by itself. To supply your own symbol, pass `watermark-logo: fill => svg-bytes`, returning SVG data tinted to the supplied color.

Containers independently accept `ambrosia-block(watermark: "body", ...)` or `"title"`; see [utilities](https://github.com/inspiros/touying-ambrosia/blob/master/docs/utilities.md). These remain opt-in to avoid decorating every panel.

## Shared API

The neutral `light` and `nocturne` palettes match the core. For lab presets choose `greyc-light`, `greyc-ivory`, `greyc-nocturne`, or `greyc-charcoal`. Build custom variants with `ambrosia-palette(base: "greyc-ivory", name: "My colors", primary: rgb("246844"))`, or use `rotate: 30deg` and role overrides. See the core's [palette guide](https://github.com/inspiros/touying-ambrosia/blob/master/docs/palettes.md).

The core also documents [linked affiliation markers](https://github.com/inspiros/touying-ambrosia/blob/master/docs/people.md), the [palette showcase](https://github.com/inspiros/touying-ambrosia/blob/master/docs/palettes.md), and [matching citation/bibliography labels](https://github.com/inspiros/touying-ambrosia/blob/master/docs/citations.md). These work in GREYC, including its legacy cover, through the shared implementation.

## Header Logos

`legacy`, `simple`, `minimal`, `dewdrop`, `stargazer`, and `portico` attach the
GREYC traits artwork to the top-right edge. Wide bands (including Stargazer's
tabs or dots) paint across the full page behind the mark; their labels reserve
room for the logo. Cambridge and Darmstadt keep normal marks in the footer.

Only thin `context` and `tree` navigation uses a separate logo column. Its
header paint fades into the page before the mark, with labels clear of the
fade. Custom flavor descriptors can set `header-logo-fade: 0em` for a hard edge.

Team selection substitutes its compact mark. `primary-logos` substitutes a
bounded collection, and `header-logo` overrides that placement independently.
Set `header-logo: none` to hide the header mark without reserving an empty
column. The lab mark adapts its purple to `#FBF7F8` on dark surfaces; its traits
retain their original colors.

## Footer Logos

The shared `footer-logo` option accepts `auto` (the flavor preset), `true`, or `false`. Cambridge and Darmstadt share one compact row for logo/buttons above any segmented navigation rail. Its body space is reserved, so the logo cannot overlap slide content. Set `footer-logo: false` in `greyc-theme` to hide it, or `config-store(footer-logo: false)` on one slide. `footer-logo-height` defaults to `1.1em`. The native header title layout hides the repeated footer logo on that title slide.


## Primary And Partner Groups

GREYC defaults to `title-logo-distribution: "grouped"`: its lab/team mark sits
against the left edge and institution partners against the right of their row.
The legacy row stays inside its palette-colored text column, aligned with the metadata;
it does not extend over the cover photograph. The legacy cover follows the resolved palette primary, including explicit
primary overrides, with contrasting text and logos. Set `team-accent: true` to add a
thin vertical strip at the left edge in the team's original color. It is off by default and never changes the palette.

Native horizontal title rows inherit grouped distribution; split panels retain
their vertical grid. Featured primary marks have their own region, so partners
use a centered equal-cell grid. A native descriptor with
`logos-distribution: "equal"` overrides ordinary horizontal grouping.

The core's `primary-logos` option can supply several repeated marks, e.g. a team
and joint project: `primary-logos: (image("team.svg"), image("project.svg"))`.
It replaces the GREYC/team fallback in native headers, footer rows, section and
focus slides, title groups, and closing cards. The custom legacy cover also
uses the whole collection. Partner logos remain in `logos`. Passing `none`
hides the primary collection. Explicit `header-logo` / `logo-focus` values
continue to override their own placement. See the core's branding guide.

## Optional Theme Credit

`#ambrosia-credit-card()` / `#ambrosia.credit-card()` uses this package’s logo,
repository URL, and bundled QR, and links to Touying Ambrosia as its base. Use
`qr: false` for a quieter card. It is never inserted automatically. The core’s
[credit and acknowledgement example](https://github.com/inspiros/touying-ambrosia/blob/master/examples/credits.typ)
works here too. Native blocks remain suitable for collaborator/funder acknowledgements.

For laboratory information, reuse the card with a GREYC identity, lab logo,
website URL, and the lab's official QR. The
[lab information and package credit example](../examples/credits.typ) shows the
two identities separately. `assets.asset-paths.lab-qr` names the official lab
website QR; `assets.asset-paths.credit-qr` remains the package repository QR. The example places the standard lab QR on a white backing on
both light and dark palettes. No additional public component is needed.

Portico's sidebar is transparent by default (`sidebar-background: none`). Set
`auto` to enable the flavor's panel paint, or supply a solid color. A local
`config-store(sidebar-background: none)` changes a single slide. Its reserved
width and label padding remain the same, and labels adapt to the new surface.

## Editor Completion

`greyc-theme` exposes the shared `ambrosia-theme` options directly for Tinymist
completion. GREYC defaults to `flavor: "legacy"`, `palette: "greyc-light"`, and
grouped title logos. For `logos`, `header-logo`, `logo-focus`, and `watermark-logo`,
`auto` selects GREYC branding and `none` hides the mark. Custom content or
callbacks override those defaults; positional Touying configurations apply last.

## Outline Leaders

GREYC agendas use dotted leaders by default (`outline-fill: repeat[.]`). Set
`outline-fill: none` on `greyc-theme` to remove them, or use
`outline-slide(fill: ...)` / `new-section-slide(fill: ...)` for a local override.
The same choice applies to the fitted list, card, and path treatments. See the
[core agenda guide](https://github.com/inspiros/touying-ambrosia/blob/master/docs/agendas.md).
