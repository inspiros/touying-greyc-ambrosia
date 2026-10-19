#!/usr/bin/env python3
"""Refresh GREYC samples and curated README artwork from real Typst examples."""
import argparse
from concurrent.futures import ThreadPoolExecutor
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tomllib
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / 'target/previews'
PACKAGE_PATH = OUTPUT / 'package-data/typst/packages'


def run(*args):
    if args[0] == 'typst' and '--package-path' not in args:
        args = (*args[:2], '--package-path', PACKAGE_PATH, *args[2:])
    subprocess.run(list(map(str, args)), cwd=ROOT, check=True)


def comparison(paths, captions, destination):
    width, caption, gap, margin = 900, 40, 18, 20
    with Image.open(paths[0]) as source:
        height = round(width * source.height / source.width)
    rows = (len(paths) + 1) // 2
    result = Image.new('RGB', (width * 2 + gap + margin * 2,
        rows * (height + caption) + gap * (rows - 1) + margin * 2), '#e9edf2')
    draw = ImageDraw.Draw(result)
    try:
        font = ImageFont.truetype('DejaVuSans.ttf', 24)
    except OSError:
        font = ImageFont.load_default()
    for i, (path, label) in enumerate(zip(paths, captions, strict=True)):
        x, y = margin + (i % 2) * (width + gap), margin + (i // 2) * (height + caption + gap)
        draw.text((x, y), label, font=font, fill='#263341')
        with Image.open(path) as source:
            result.paste(source.convert('RGB').resize((width, height), Image.Resampling.LANCZOS), (x, y + caption))
    result.save(destination, quality=92)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--update-pdfs', action='store_true')
    parser.add_argument('--core-root', type=Path, help='Use another core checkout for staged integration checks.')
    args = parser.parse_args()
    OUTPUT.mkdir(parents=True, exist_ok=True)
    gallery = ROOT / 'assets/gallery'
    gallery.mkdir(exist_ok=True)
    install = [sys.executable, ROOT / 'scripts/install.py', '--data-dir', OUTPUT / 'package-data', '--namespace', 'preview', '--reinstall']
    if args.core_root:
        install += ['--core-root', args.core_root.resolve()]
    run(*install)
    registry = json.loads(subprocess.check_output([
        'typst', 'eval', '--root', str(ROOT), '--package-path', str(PACKAGE_PATH), '--format', 'json',
        '{ import "src/theme/flavors.typ": flavor-names; flavor-names }',
    ], cwd=ROOT, text=True))

    def render(case):
        flavor, palette = case
        name = flavor if palette == 'greyc-light' else f'{flavor}-{palette}'
        run('typst', 'compile', '--jobs', '1', '--root', ROOT, '--ppi', '144',
            '--input', f'flavor={flavor}', '--input', f'palette={palette}',
            ROOT / 'examples/sample.typ', OUTPUT / f'{name}-{{p}}.png')
        for page in range(1, 4):
            Image.open(OUTPUT / f'{name}-{page}.png').save(ROOT / f'assets/samples/sample-{name}-{page}.webp', quality=90)
        print(f'Updated {name} previews')
        return OUTPUT / f'{name}-3.png'

    cases = [(name, 'greyc-light') for name in registry]
    lab_palettes = ('greyc-light', 'greyc-ivory', 'greyc-nocturne', 'greyc-charcoal')
    cases += [('cambridge', 'ocean'), *[('minimal', p) for p in lab_palettes[1:]]]
    with ThreadPoolExecutor(max_workers=3) as pool:
        renders = dict(zip(cases, pool.map(render, cases), strict=True))
    selected = [('legacy', 'greyc-light'), ('stargazer', 'greyc-light'), ('cambridge', 'ocean'), ('minimal', 'greyc-nocturne')]
    comparison([renders[c] for c in selected], ['Legacy · GREYC', 'Stargazer · GREYC', 'Cambridge · Ocean', 'Minimal · GREYC Nocturne'], gallery / 'flavors.webp')
    comparison([renders[('minimal', p)] for p in lab_palettes],
        ['GREYC Light', 'GREYC Ivory', 'GREYC Nocturne', 'GREYC Charcoal'], gallery / 'palettes.webp')

    run('typst', 'compile', '--root', ROOT, '--ppi', '144', ROOT / 'examples/teams.typ', OUTPUT / 'teams.png')
    Image.open(OUTPUT / 'teams.png').save(gallery / 'teams.webp', quality=92)
    observations = json.loads(subprocess.check_output([
        'typst', 'eval', '--root', str(ROOT), '--package-path', str(PACKAGE_PATH), '--format', 'json',
        '--in', 'examples/demo.typ', 'query(<greyc-demo-view>).map(it => (name: it.value, page: it.location().page()))',
    ], cwd=ROOT, text=True))
    pages = {item['name']: item['page'] for item in observations}
    thumbnails = []
    for name in ('blocks', 'evidence', 'roadmap', 'credits'):
        path = OUTPUT / f'demo-{name}.png'
        run('typst', 'compile', '--jobs', '1', '--root', ROOT, '--ppi', '144', '--pages', str(pages[name]), ROOT / 'examples/demo.typ', path)
        thumbnails.append(path)
    comparison(thumbnails, ['Explain · Semantic Containers', 'Compare · Figures And Tables', 'Plan · Flexible Roadmaps', 'Share · People And Tools'], gallery / 'demo.webp')
    run('typst', 'compile', '--jobs', '1', '--root', ROOT, '--ppi', '144', '--pages', '1', ROOT / 'examples/demo.typ', OUTPUT / 'demo-cover.png')
    Image.open(OUTPUT / 'demo-cover.png').save(gallery / 'legacy-cover.webp', quality=92)
    print('Updated the legacy cover, flavor comparison, team marks and curated demo pages.')
    run(sys.executable, ROOT / 'scripts/render-thumbnail.py', '--package-path', PACKAGE_PATH)

    if args.update_pdfs:
        for name in ('branding', 'demo'):
            run('typst', 'compile', '--root', ROOT, ROOT / f'examples/{name}.typ', OUTPUT / f'{name}.pdf')
            shutil.copyfile(OUTPUT / f'{name}.pdf', ROOT / f'examples/{name}.pdf')
        run(*install)
        package = tomllib.loads((ROOT / 'typst.toml').read_text())['package']
        identifier = package['name'] + ':' + package['version']
        starter = OUTPUT / 'starter'
        if starter.exists():
            shutil.rmtree(starter)
        run('typst', 'init', '@preview/' + identifier, starter)
        entrypoint = starter / 'template.typ'
        run('typst', 'compile', '--root', starter, entrypoint, OUTPUT / 'template.pdf')
        # Keep the starter check under target; no PDF belongs in a new project.
        # Universe accepts WebP; the cover photograph compresses far better lossy.
        thumbnail = OUTPUT / 'template-thumbnail.png'
        run('typst', 'compile', '--root', starter, '--pages', '1', '--ppi', '144', entrypoint, thumbnail)
        with Image.open(thumbnail) as image:
            image.convert('RGB').save(ROOT / 'assets/template-thumbnail.webp', quality=90, method=6)


if __name__ == '__main__':
    main()
