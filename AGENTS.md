# Repository Guide

This guide is for reviewing or maintaining **touying-greyc-ambrosia**. Start
with [CONTRIBUTING.md](CONTRIBUTING.md) and the
[maintainer index](docs/maintainers/README.md). Presentation authors use the
[user guide](docs/README.md).

## Code Map And Boundaries

| Area | Responsibility |
| --- | --- |
| `src/core.typ` | Single exact-version dependency on `touying-ambrosia`. |
| `src/lib.typ`, `src/ambrosia.typ` | Global/scoped re-exports and GREYC overrides. |
| `src/theme/greyc.typ` | Branded setup and IDE-visible shared theme parameters. |
| `src/theme/legacy.typ`, `src/theme/flavors.typ` | Legacy cover and GREYC flavor adaptations. |
| `src/assets.typ`, `src/branding.typ`, `src/colors.typ`, `src/palettes.typ` | Logo registry, teams, source colors, and four lab palettes. |
| `assets/` | GREYC/team/partner artwork and required package assets. Rights notices are in the README. |
| `template/`, `examples/` | Initialized legacy starter and branded demonstrations. |
| `tests/`, `scripts/`, `docs/maintainers/` | Integration checks, development tools, and developer documentation. |

General rendering, navigation, citations, metadata, and utilities belong in
the sibling `touying-ambrosia`. Fix shared behavior there rather than copying
it into this wrapper. The [package boundary](docs/maintainers/package-boundary.md)
explains the supported extension interface and exact dependency.

## Review Focus

- A team changes marks, not palette roles. The optional team accent is separate;
  the legacy cover follows the resolved palette primary.
- Legacy title logos and metadata stay in the text column. Shared native
  title/ending layouts retain the core's placement and fitting semantics.
- GREYC's top-attached traits logo reserves label space. Thin context/tree
  bands use a fading gutter; wide navigation bands extend behind the mark.
  Cambridge/Darmstadt use reserved footer branding instead.
- Resolve this package's SVG paths locally before passing bytes/content to
  the core. Preserve dark-surface recoloring and all asset/license notices.
- The shared parameters/forwarding in `src/theme/greyc.typ` are generated.
  Edit their generator/defaults and regenerate them when changing that surface.
- No separate consumer skill is needed: the core's Ambrosia authoring skill
  applies to this wrapper while preserving its branding configuration.

## Validation

Use Typst 0.15+, Python 3.11+, Poppler, and a sibling core checkout. From here:

```sh
python3 scripts/sync-theme-signature.py --check
python3 -m unittest discover -s tests -p 'test_*.py'
python3 tests/run.py
```

`--core-root /path/to/touying-ambrosia` selects another core for the signature
check and wrapper runner. The Python integration tests expect the sibling.
General behavior is covered by the core suite; choose validation matching the
change and report what ran. Documentation-only edits need link checks, not a
complete visual matrix. Artwork regeneration is separate; see
[development](docs/maintainers/development.md).

The installer defaults this package to `@local` while creating its pinned
`@preview` core alias. Both checkouts can be linked for live work; copied release
tests must honor exclusions. Prefer an isolated `--data-dir target/package-data`
for manual validation. Use `develop/` for disposable sources and `target/` for
output; both are ignored.

Follow [joint release preparation](docs/maintainers/releasing.md) for source
tags and trimmed package files. GREYC `0.2.0` depends on core `0.1.0`; the
published GREYC `0.1.0` submission directory must remain unchanged.
