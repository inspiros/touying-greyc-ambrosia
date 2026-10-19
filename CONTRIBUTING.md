# Contributing To Touying GREYC Ambrosia

These instructions are for working on the package. For presentation authoring,
use the [user documentation](docs/README.md).

For a code-review entry point and source map, read [AGENTS.md](AGENTS.md).

Use Typst 0.15+, Python 3.11+, and Poppler for the checks. Artwork scripts also
use Pillow (`python3 -m pip install Pillow`).

## Checkout Setup

For checkout development, keep the repositories side by side:

```sh
git clone https://github.com/inspiros/touying-ambrosia
git clone https://github.com/inspiros/touying-greyc-ambrosia
cd touying-greyc-ambrosia
python3 scripts/install.py --link --reinstall
```

The selected package defaults to **local**: import
`@local/touying-greyc-ambrosia:0.2.0` for the development checkout.
The installer also creates the pinned `@preview/touying-ambrosia:0.1.0`
dependency alias so the wrapper sees live core changes. This alias is separate
from the default namespace of the selected package.

The installer links the sibling core by default, so edits to its source and assets reach this wrapper immediately. `--link` also links the GREYC checkout. Pass `--no-link-core` and omit `--link` to test copied release snapshots. Published packages depend on an exact core version; a core release still requires a dependency-version update here.

```sh
python3 tests/run.py
python3 -m unittest discover -s tests -p 'test_*.py'
```

`greyc-theme` declares shared options explicitly so Tinymist can complete them.
After changing the pinned core theme signature, run
`python3 scripts/sync-theme-signature.py`; use `--check` to verify it without edits.
The generator keeps GREYC branding defaults and inherits core callback renderers.

These checks cover GREYC presets, logos, team integration, the legacy cover, and installed consumers. General behavior is tested in the core. Disposable experiments belong in `develop/`, outputs in `target/`. See [development](docs/maintainers/development.md), [the package boundary](docs/maintainers/package-boundary.md), [release preparation](docs/maintainers/releasing.md), and the concise [changelog](CHANGELOG.md).

The [maintainer index](docs/maintainers/README.md) collects implementation,
artwork, architecture, and release notes.
