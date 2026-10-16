#!/usr/bin/env python3
"""Render the GREYC SVG README hero from legacy, team, and modern slide variants."""
import argparse
from pathlib import Path
import subprocess
import sys
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "target/hero"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--core-root", type=Path, help="Optional sibling core checkout override.")
    parser.add_argument("--package-path", type=Path, help="Reuse an existing isolated package tree.")
    args = parser.parse_args()
    OUTPUT.mkdir(parents=True, exist_ok=True)
    packages = args.package_path.resolve() if args.package_path else OUTPUT / "package-data/typst/packages"
    if args.package_path is None:
        command = [sys.executable, str(ROOT / "scripts/install.py"), "--data-dir", str(OUTPUT / "package-data"),
                   "--namespace", "preview", "--reinstall"]
        if args.core_root:
            command += ["--core-root", str(args.core_root.resolve())]
        subprocess.run(command, cwd=ROOT, check=True)

    def compile(source, destination, *options):
        subprocess.run(["typst", "compile", "--root", str(ROOT), "--package-path", str(packages),
                        "--jobs", "1", "--ppi", "144", *options, str(source), str(destination)],
                       cwd=ROOT, check=True)

    gallery = ROOT / "assets/gallery"
    gallery.mkdir(parents=True, exist_ok=True)
    for view in ("team", "modern", "legacy"):
        render = OUTPUT / f"{view}.png"
        compile(ROOT / "docs/maintainers/artwork/slides.typ", render,
                "--input", f"view={view}", "--pages", "1")
        with Image.open(render) as image:
            image.convert("RGB").save(gallery / f"hero-{view}.webp", quality=94)
    compile(ROOT / "docs/maintainers/artwork/hero.typ", ROOT / "assets/thumbnail.svg")
    print("Updated GREYC SVG README hero and three bundled real slide renders.")


if __name__ == "__main__":
    main()
