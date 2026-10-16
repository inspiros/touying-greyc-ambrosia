# Package Boundary

[touying-ambrosia](https://github.com/inspiros/touying-ambrosia) owns the general theme: flavors, palette construction, slides, fitting, authors, blocks, citations, and utilities. Its supported `extensions` module allows institution wrappers to reuse these mechanisms.

GREYC re-exports that API and adds only lab/team/partner branding, the `legacy` flavor and cover, and named `greyc-light`, `greyc-ivory`, `greyc-nocturne`, and `greyc-charcoal` palettes. `src/core.typ` is the single exact-version package dependency. Neutral palette names retain the core's meaning.

During development, `scripts/install.py` installs the wrapper under `@local` and links the sibling core under its pinned `@preview` dependency identifier by default. Core source changes automatically affect GREYC; no vendor copy is required. If the core theme signature changes, refresh the IDE-visible parameter declarations with `python3 scripts/sync-theme-signature.py`; the regression checks detect drift. Use `--no-link-core` for a packaged snapshot. Published versions remain immutable, so adopting a later core release requires updating the exact import in `src/core.typ` and installer version validation.

Other institutions can build a similarly small wrapper with their logos and a custom flavor. See the core's [extension guide](https://github.com/inspiros/touying-ambrosia/blob/main/docs/extensions.md).

For future poster/thesis wrappers, keep a native component renderer layer and
lab identity assets reusable without importing Touying. Extract them when a
second real consumer establishes the boundary; see the core’s
[component architecture guide](https://github.com/inspiros/touying-ambrosia/blob/main/docs/maintainers/architecture.md).
