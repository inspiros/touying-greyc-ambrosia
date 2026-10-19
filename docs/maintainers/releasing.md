# Preparing The Joint Submission

The joint submission contains these two new version directories in
[PR #6154](https://github.com/typst/packages/pull/6154):

| Package | Version | Submission directory |
| --- | --- | --- |
| `touying-ambrosia` | `0.1.0` | `packages/preview/touying-ambrosia/0.1.0` |
| `touying-greyc-ambrosia` | `0.2.0` | `packages/preview/touying-greyc-ambrosia/0.2.0` |

The existing GREYC `0.1.0` directory stays unchanged. `src/core.typ` must retain
its exact `@preview/touying-ambrosia:0.1.0` dependency. The single pull request
should explain that the neutral core is new and the GREYC update depends on it.
Both proposed versions must be tested together before submission.

Follow the core's [release preparation guide](https://github.com/inspiros/touying-ambrosia/blob/master/docs/maintainers/releasing.md)
for archive contents, version-pinned README links, source tags, and isolated
starter checks. Use the matching core source revision when assembling a release.

The GREYC README uses published `@preview` imports. Its local installer defaults
to `@local`, while the retained core alias uses `@preview` to preserve live
updates. Neither local installation nor an isolated preview override publishes
anything.

`assets/template-thumbnail.webp` is the first page of an unmodified initialized
legacy starter. `scripts/render-previews.py --update-pdfs` refreshes it and the
starter validation PDF under `target` (not in `template`). `scripts/render-thumbnail.py` generates the SVG README hero from
real legacy, team-branded, and modern slide renders. That artwork remains
separate from the manifest thumbnail.

The source READMEs keep relative links for GitHub. The submission copy must
rewrite documentation and artwork URLs to each project's final source tag,
while keeping the package's `README.md` and `LICENSE`. Avoid blindly copying
all generated samples or losing README illustrations through runtime exclusions.

## Source And Submission Boundaries

Use source tag `v0.2.0` here and core tag `v0.1.0` in the other repository.
Keep versions independent: this wrapper's breaking API changes justify `0.2.0`,
while its core dependency remains pinned to `0.1.0`.

The personal repository retains full source, tests, scripts, guides, artwork,
and the selected `examples/demo.pdf` / `examples/branding.pdf` inspection copies.
The core also commits `docs/manual.pdf` and `examples/slide-previews.pdf`.
`template/template.pdf` is intentionally absent; initialized projects receive
only useful starter source and assets.

The packages submission contains the manifest, README, licenses, `src`, starter
files, runtime assets, and required manifest thumbnail. Omit docs, examples,
scripts, tests, agent guidance (`AGENTS.md`, `CLAUDE.md`), generated PDFs, sample
sheets, and the SVG README hero. Rewrite
README documentation/artwork links to this repository's `v0.2.0`, and core links
to its `v0.1.0`, including links that currently mention `master` or `main`. Shipped starter
links must be stable too. Keep README and licenses in runtime downloads.

The maintainer confirmed logo redistribution permission from GREYC's former head
of communication. Lab and institutional logo source:
[GREYC intranet templates](https://www.greyc.fr/intranet/#1647886250909-16337474-b9c8).
Team-logo source and usage guidelines:
[GREYC communication resources](https://giguete.users.greyc.fr/com/), created by
the former head of communication. The legacy cover photograph comes from the
LaTeX presentation template linked by the intranet page. The maintainer confirmed
permission to redistribute these materials in this theme. The public resource
page is not a blanket open-source license; the README preserves the respective
owners' rights and distinguishes the artwork from the MIT code. Retain this
notice in the trimmed submission.

Before merge, apply reviewed corrections to the source repository and staged
copy together. Refresh an unpublished source tag only as part of authorized
release work, then check its pinned links. After publication, keep existing
tags/package versions immutable and make changes in a new release.
