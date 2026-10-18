#!/usr/bin/env python3
"""Mirror the pinned core theme's named options for Typst IDE completion."""
import argparse
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
# GREYC owns these options or resolves them dynamically at runtime.
OWN = {"flavor", "palette"}
DEFAULTS = {"logos": "auto", "watermark-logo": "auto", "title-logo-distribution": '"grouped"', "outline-fill": "repeat[.]"}
BRANDING = {"logos", "header-logo", "logo-focus", "watermark-logo"}


def parameters(source):
    """Split only top-level commas, preserving nested expressions and strings."""
    start = source.index("(", source.index("#let ambrosia-theme(")) + 1
    stack, quoted, escaped, comment = [], False, False, False
    chunks, cursor = [], start
    for i in range(start, len(source)):
        c = source[i]
        if comment:
            if c == "\n": comment = False
            continue
        if quoted:
            if escaped: escaped = False
            elif c == "\\": escaped = True
            elif c == '"': quoted = False
            continue
        if source[i:i+2] == "//": comment = True; continue
        if c == '"': quoted = True
        elif c in "([{": stack.append(c)
        elif c in ")]}":
            if not stack:
                assert c == ")"
                break
            assert stack.pop() == {")": "(", "]": "[", "}": "{"}[c]
        elif c == "," and not stack:
            chunks.append(source[cursor:i].strip()); cursor = i + 1
    result = []
    for chunk in chunks:
        if ":" not in chunk: continue
        name, value = chunk.split(":", 1)
        assert re.fullmatch(r"[a-z][a-z-]*", name), name
        result.append((name, value.strip()))
    assert len(result) > 60, "Core signature was not recognized."
    return result


def render(source):
    params = [(n, v) for n, v in parameters(source) if n not in OWN]
    callbacks = {n for n, v in params if "=>" in v}
    signature = "\n".join(f"  {n}: {DEFAULTS.get(n, 'auto' if n in callbacks else v)}," for n, v in params)
    ordinary = [(n, v) for n, v in params if n not in callbacks | BRANDING]
    forwarding = "\n".join(f"    {n}: {n}," for n, _ in ordinary)
    # auto inherits the callback in the core, without duplicating its implementation.
    forwarding += "\n" + "\n".join(f"    ..if {n} == auto {{ (:) }} else {{ ({n}: {n},) }}," for n, _ in params if n in callbacks)
    return signature, forwarding


def update(text, name, content):
    begin, end = f"// BEGIN GENERATED {name}", f"// END GENERATED {name}"
    prefix, rest = text.split(begin, 1)
    _, suffix = rest.split(end, 1)
    indent = "    " if name == "FORWARDING" else "  "
    return prefix + begin + "\n" + content + "\n" + indent + end + suffix


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--core-root", type=Path, default=ROOT.parent / "touying-ambrosia")
    parser.add_argument("--check", action="store_true", help="fail if the wrapper's generated regions are stale")
    args = parser.parse_args()
    signature, forwarding = render((args.core_root / "src/theme/base.typ").read_text())
    path = ROOT / "src/theme/greyc.typ"
    original = path.read_text()
    updated = update(update(original, "PARAMETERS", signature), "FORWARDING", forwarding)
    if args.check:
        if updated != original:
            parser.exit(1, "GREYC theme signature is stale. Run scripts/sync-theme-signature.py.\n")
        print("GREYC theme signature matches the core.")
    elif updated != original:
        path.write_text(updated)
        print("Updated GREYC theme signature and forwarding.")


if __name__ == "__main__":
    main()
