#!/usr/bin/env python3
"""Install the package locally using the exclusions declared in typst.toml."""

import argparse
import fnmatch
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tomllib


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root_dir", "--root-dir", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--data_dir", "--data-dir", type=Path, help="Application data directory containing typst/packages.")
    parser.add_argument("--namespace", default="local", help="Installation namespace (default: local).")
    parser.add_argument("--link-core", action=argparse.BooleanOptionalAction, default=True,
                        help="Link the core checkout for live updates (default); --no-link-core installs a snapshot.")
    parser.add_argument("--core-root", type=Path, help="Neutral core checkout (defaults to sibling touying-ambrosia).")
    parser.add_argument("--package_name", "--package-name")
    parser.add_argument("--version")
    parser.add_argument("--exclude", nargs="+", default=[], help="Additional package-relative paths or glob patterns to exclude.")
    parser.add_argument("--reinstall", action="store_true")
    parser.add_argument("--link", action="store_true", help="Link the checkout for live development instead of copying a release snapshot.")
    return parser.parse_args()


def default_data_dir():
    if sys.platform.startswith("linux"):
        return Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))
    if sys.platform == "darwin":
        return Path.home() / "Library/Application Support"
    if sys.platform == "win32":
        return Path(os.environ["APPDATA"])
    raise RuntimeError("Specify --data-dir on this operating system.")


def exclusion_filter(root, patterns):
    """Match both basenames and package-relative paths, including directories."""
    def ignore(directory, names):
        relative_dir = Path(directory).relative_to(root)
        return [
            name for name in names
            if any(
                fnmatch.fnmatchcase(name, pattern)
                or fnmatch.fnmatchcase((relative_dir / name).as_posix(), pattern)
                for pattern in patterns
            )
        ]
    return ignore


def main():
    args = parse_args()
    source = args.root_dir.resolve()
    with (source / "typst.toml").open("rb") as manifest:
        metadata = tomllib.load(manifest)
    package = metadata["package"]
    thumbnail = metadata.get("template", {}).get("thumbnail")
    namespace = args.namespace.removeprefix("@")
    name = args.package_name or package["name"]
    version = args.version or package["version"]
    for part in (namespace, name, version):
        if not part or part in (".", "..") or "/" in part or "\\" in part:
            raise ValueError("Namespace, package name, and version must be single path components.")
    data_dir = args.data_dir if args.data_dir is not None else default_data_dir()
    # Resolve parents only: resolving a linked leaf could delete the source on reinstall.
    destination = (data_dir / "typst/packages" / namespace / name).resolve() / version
    if destination == source or source.is_relative_to(destination):
        raise ValueError("The installation directory must not contain the source checkout.")
    patterns = [".git", ".agents", ".codex", ".aws", "develop", "target", "__pycache__",
                *package.get("exclude", []), *([thumbnail] if thumbnail else []), *args.exclude]
    if destination.is_relative_to(source):
        relative = destination.relative_to(source)
        excluded = False
        for index, part in enumerate(relative.parts):
            prefix = Path(*relative.parts[:index + 1]).as_posix()
            if any(fnmatch.fnmatchcase(part, pattern) or fnmatch.fnmatchcase(prefix, pattern)
                   for pattern in patterns):
                excluded = True
                break
        if not excluded:
            raise ValueError("An installation inside the checkout must use an excluded directory such as target.")
    if destination.exists() or destination.is_symlink():
        if not args.reinstall:
            raise FileExistsError("Package already exists. Rerun with --reinstall to replace it.")
    if package["name"] == "touying-greyc-ambrosia":
        core_root = (args.core_root or source.parent / "touying-ambrosia").resolve()
        with (core_root / "typst.toml").open("rb") as manifest:
            core = tomllib.load(manifest)["package"]
        if core["name"] != "touying-ambrosia" or core["version"] != "0.1.0":
            raise ValueError("GREYC requires touying-ambrosia:0.1.0; choose a matching --core-root checkout.")
        # Install the live core alias under the wrapper's pinned dependency identifier. The
        # selected data directory controls whether this is isolated or persistent.
        subprocess.run([sys.executable, str(Path(__file__).resolve()), "--root-dir", str(core_root),
                        "--data-dir", str(data_dir), "--namespace", "preview", "--reinstall",
                        *(["--link"] if args.link_core else [])], check=True)
    if destination.exists() or destination.is_symlink():
        if destination.is_symlink():
            destination.unlink()
        else:
            shutil.rmtree(destination)
    print(f"Installing {name}:{version}\n> source_dir = {source}\n> install_dir = {destination}")
    if args.link:
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.symlink_to(source, target_is_directory=True)
    else:
        shutil.copytree(source, destination, ignore=exclusion_filter(source, patterns))
    print(f'Success! Import with:\n\n#import "@{namespace}/{name}:{version}": *')


if __name__ == "__main__":
    main()
