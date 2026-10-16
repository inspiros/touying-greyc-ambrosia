# Development

Use Typst 0.15+, Python 3.11+, and Poppler. Keep the sibling `touying-ambrosia` checkout available; `--core-root` can select another location.

```sh
python3 scripts/install.py --link --reinstall
python3 tests/run.py
python3 -m unittest discover -s tests -p 'test_*.py'
```

The selected package defaults to `@local`. The installer links the pinned core under `@preview` by default to satisfy the wrapper's published dependency. `--link` links this wrapper too, making both editable in Tinymist without reinstalling. Use `--data-dir target/package-data` for an isolated package directory, then pass `--package-path target/package-data/typst/packages` to Typst. Restart the language server if it retains an old package view.

For release-shaped tests, omit `--link` and pass `--no-link-core`. Both installers honor manifest exclusions in copy mode and safely replace an existing link without deleting its target.

The short wrapper runner checks lab palettes and SVG transformations, all eight flavors with GREYC colors, every navigator with GREYC header branding, every team on a dark palette, and legacy/appendix integration. Header checks cover top-edge alignment, hidden/custom/multiple marks, and notes output. The Python tests check installation, live links, and real installed consumers outside either checkout, including caller-relative images/bibliographies/CSL. Run the core's own suite for general layout, utilities, authors, bibliography labels, and palette coverage.

The initial extraction was checked against 110 byte-identical rendered pages across ten decks. Ongoing shared visual changes belong to the core's tests. `scripts/render-previews.py` refreshes the GREYC samples and curated README sheets (legacy cover, four flavors, four lab palettes, seven teams, and four demo pages). Demo page selection uses metadata labels rather than fixed page indices. `--update-pdfs` also refreshes the branding/long-demo PDFs, starter check under `target`, and lossless manifest thumbnail. The latter is an unmodified initialized legacy cover. `--core-root` selects a staged core for these renders. Gallery images are excluded from the installable package.

Use `develop/` for disposable sources and `target/` for generated outputs. Both are gitignored.

Team names are derived from `src/assets.typ`’s `logo-teams` registry. Register both full and compact SVG paths there and add the accent in `src/colors.typ`; the team sheet and light-variant assertions pick up the entry automatically.

Branding regressions compare the entire resolved color record across all teams in light/dark lab and neutral palettes. Optional legacy-cover stripes retain the original team color; explicit primary overrides remain separate.

## README Hero

`python3 scripts/render-thumbnail.py` renders the maintained slide specimens and
SVG composition under `docs/maintainers/artwork`. The images are bundled under
`assets/gallery/hero-*` for direct IDE preview. `--core-root` selects a staged
core; `--package-path` reuses an existing isolated dependency tree. The full
preview generator refreshes this hero too. The manifest PNG remains an actual
initialized-template page.
