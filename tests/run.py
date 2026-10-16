#!/usr/bin/env python3
"""Check the GREYC wrapper; general behavior is tested in touying-ambrosia."""
import argparse
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "target/tests"
PACKAGES = OUTPUT / "dependencies/typst/packages"
FLAVORS = ("legacy", "simple", "cambridge", "darmstadt", "dewdrop", "stargazer", "minimal", "portico")
TEAMS = ("amacc", "codag", "diamant", "electronique", "image", "mad", "safe")


def typst(*args):
    result = subprocess.run(["typst", *map(str, args), "--root", str(ROOT), "--package-path", str(PACKAGES)],
                            cwd=ROOT, capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(result.stderr)
    return result.stdout


def assert_headers():
    source = 'tests/headers.typ'
    expression = '''{
      let events(sel) = query(sel).map(it => (page: it.location().page(),
        x: it.location().position().x.pt(), y: it.location().position().y.pt(), ..it.value));
      (headers: events(<ambrosia-header-region>), body: events(<header-test-body>),
       logos: events(<ambrosia-header-logo>), strips: events(<ambrosia-logo-strip>),
       footer: events(<ambrosia-footer-logo>), fades: events(<ambrosia-header-fade>))
    }'''
    edge_flavors = ('legacy', 'simple', 'minimal', 'dewdrop', 'stargazer', 'portico')
    cases = [(f, nav, 'greyc-light', 'auto', None, 'slides', 'right', 'true')
             for f in FLAVORS for nav in ('auto', 'none', 'dots', 'tabs', 'context', 'tree', 'panes', 'breadcrumbs', 'sidebar', 'segments')]
    cases += [('dewdrop', nav, 'greyc-nocturne', mark, team, 'slides', 'right', roots)
              for nav in ('dots', 'tabs')
              for mark, team, roots in (('none', None, 'true'), ('custom', None, 'true'),
                                         ('multiple', None, 'true'), ('auto', 'image', 'true'), ('auto', None, 'false'))]
    cases += [('stargazer', 'auto', 'greyc-light', 'auto', None, 'slides', 'right', 'false')]
    cases += [('dewdrop', 'dots', 'greyc-light', 'auto', None, 'second-screen', side, 'true')
              for side in ('left', 'right', 'top', 'bottom')]
    cases += [('dewdrop', 'dots', 'greyc-light', 'auto', None, mode, 'right', 'true')
              for mode in ('handout', 'notes', 'article')]
    for flavor, nav, palette, mark, team, mode, side, roots in cases:
        values = dict(flavor=flavor, navigation=nav, palette=palette, mark=mark,
                      mode=mode, roots=roots, **{'notes-side': side})
        if team: values['team'] = team
        options = [arg for k, v in values.items() for arg in ('--input', f'{k}={v}')]
        data = json.loads(typst('eval', *options, '--in', source, '--format', 'json', expression))
        label = (flavor, nav, mark, mode, side, roots)
        if mode == 'article':
            assert not data['headers'], label
            continue
        for body in data['body']:
            header = next(h for h in data['headers'] if h['page'] == body['page'])
            offset_x = 841.8897637795276 if mode == 'second-screen' and side == 'left' else 0
            offset_y = 473.5629921259842 if mode == 'second-screen' and side == 'top' else 0
            if mode != 'notes':
                assert abs(header['y'] - offset_y) < .01, (label, header)
                assert header['y'] + header['height'] < body['y'], (label, header, body)
            logos = [logo for logo in data['logos'] if logo['page'] == body['page']]
            expected = 0 if mark == 'none' or flavor in ('cambridge', 'darmstadt') else 2 if mark == 'multiple' else 1
            assert len(logos) == expected, (label, logos)
            if flavor in ('cambridge', 'darmstadt'):
                assert len([logo for logo in data['footer'] if logo['page'] == body['page']]) == 1, label
            fades = [f for f in data['fades'] if f['page'] == body['page']]
            thin = nav in ('context', 'tree')
            assert len(fades) == (1 if flavor in edge_flavors and expected and thin else 0), (label, fades)
            if mode != 'notes':
                for fade in fades:
                    assert abs(fade['width'] - 27) < .01 and abs(fade['y'] - offset_y) < .01, (label, fade)
                    assert fade['x'] + fade['width'] < min(logo['x'] for logo in logos), (label, fade, logos)
                    assert all(logo['background'] == fade['target'] for logo in logos), (label, fade, logos)
            for logo in logos:
                if flavor in edge_flavors and mode != 'notes':
                    assert abs(logo['y'] - offset_y) < .01, (label, logo)
                if mode != 'notes':
                    assert logo['x'] + logo['width'] <= offset_x + 841.8897637795276 - .8 * 18 + .01, (label, logo)
                assert logo['logo-width'] <= logo['width'] + .01 and logo['logo-height'] <= logo['height'] + .01, (label, logo)
            strips = [s for s in data['strips'] if s['page'] == body['page'] and s['kind'] == 'header']
            assert len(strips) == (1 if expected else 0), (label, strips)
            assert all(s['width'] <= s['limit'] + .01 for s in strips), label
        if nav == 'auto' and mode == 'slides':
            typst('compile', *options, source, OUTPUT / f'header-{flavor}.pdf')
    print('PASS GREYC headers: top edge, all navigator/flavor pairs, bounded single/multiple/custom/hidden marks, teams, dark palettes and notes modes')


def assert_team_palettes():
    def observation(palette, team=None, accent=False, primary=None):
        options = ["--input", f"palette={palette}", "--input", f"team-accent={str(accent).lower()}"]
        if team:
            options += ["--input", f"team={team}"]
        if primary:
            options += ["--input", f"brand-color={primary}"]
        return json.loads(typst("eval", *options, "--format", "json", "--in", "tests/branding.typ", '''{
          (cover: query(<greyc-legacy-cover>).first().value,
           colors: query(<greyc-palette-probe>).first().value,
           stripes: query(<greyc-team-accent>).map(it => it.value))
        }'''))

    for palette in ("greyc-light", "greyc-ivory", "greyc-nocturne", "greyc-charcoal", "ocean", "midnight"):
        base = observation(palette)
        for team in (None, *TEAMS):
            for accent in (False, True):
                current = observation(palette, team, accent)
                assert current["colors"] == base["colors"], (palette, team, accent)
                assert current["cover"]["background"] == base["cover"]["background"], (palette, team)
                assert (current["cover"]["team-color"] is not None) == (team is not None)
                assert current["cover"]["team-accent"] == (team is not None and accent)
                assert len(current["stripes"]) == (1 if team and accent else 0), (palette, team, accent)
                if current["stripes"]:
                    assert current["stripes"][0]["color"] == current["cover"]["team-color"]
        explicit = observation(palette, primary="123456")
        assert explicit["colors"] != base["colors"], palette
        assert observation(palette, team="diamant", primary="123456")["colors"] == explicit["colors"]
    print("PASS teams preserve every palette role; legacy stripes are optional and explicit brand colors still work")


def assert_theme_options():
    for mode, size, nav in (("defaults", 18, "auto"), ("custom", 16, "tree"), ("overrides", 17, None)):
        options = ("--input", f"mode={mode}")
        observations = json.loads(typst("eval", *options, "--in", "tests/theme-options.typ", "--format", "json",
                                       'query(<greyc-options>).map(it => it.value)'))
        assert len(observations) == 1
        probe = observations[0]
        assert probe["text-size"] == size and probe["navigation"] == nav, (mode, probe)
        assert probe["logos"] == (4 if mode == "defaults" else 0), (mode, probe)
        assert probe["distribution"] == ("grouped" if mode == "defaults" else "equal"), (mode, probe)
        assert all(probe[key] == (mode != "defaults") for key in ("primary", "header", "watermark")), (mode, probe)
        path = OUTPUT / f"options-{mode}.pdf"
        typst("compile", *options, "tests/theme-options.typ", path)
        text = subprocess.check_output(["pdftotext", "-layout", str(path), "-"], text=True)
        assert ("Custom Slide Heading" in text) == (mode != "defaults")
        assert ("Custom Footer" in text) == (mode != "defaults")
    print("PASS explicit theme options: inherited branding, custom callbacks, hidden logos and positional config precedence")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--core-root", type=Path, help="Use an alternative core checkout for integration checks.")
    args = parser.parse_args()
    OUTPUT.mkdir(parents=True, exist_ok=True)
    subprocess.run([sys.executable, str(ROOT / "scripts/install.py"), "--namespace", "preview",
                    "--data-dir", str(OUTPUT / "dependencies"), "--reinstall",
                    *(["--core-root", str(args.core_root.resolve())] if args.core_root else [])],
                   check=True, capture_output=True, text=True)
    typst("compile", "tests/unit.typ", OUTPUT / "unit.pdf")
    assert_theme_options()
    assert_headers()
    for layout in ("auto", "stacked", "header", "plain", "cover", "featured"):
        for primary in ("auto", "multiple", "none"):
            options = ("--input", f"layout={layout}", "--input", f"primary={primary}")
            path = OUTPUT / f"branding-{layout}-{primary}.pdf"
            typst("compile", *options, "tests/branding.typ", path)
            groups = json.loads(typst("eval", *options, "--format", "json", "--in", "tests/branding.typ",
                'query(<ambrosia-logo-groups>).map(it => (..it.value, page: it.location().page(), x: it.location().position().x.pt()))'))
            if layout == "featured":
                assert groups == [], "Featured partners must use a centered equal-cell grid."
                cells = json.loads(typst("eval", *options, "--format", "json", "--in", "tests/branding.typ",
                    'query(<ambrosia-title-logo>).filter(it => it.location().page() == 1).map(it => it.value)'))
                partners = cells[-4:]
                assert len(partners) == 4 and max(p["width"] for p in partners) - min(p["width"] for p in partners) < .01
                continue
            assert len(groups) == 1 and groups[0]["page"] == 1
            assert groups[0]["primary"] == {"auto": 1, "multiple": 2, "none": 0}[primary]
            assert groups[0]["partners"] == 4
            if layout == "auto":
                assert groups[0]["x"] >= 35
                assert groups[0]["x"] + groups[0]["width"] <= 842 * .7 + .01
            else:
                assert 800 < groups[0]["width"] + 2 * groups[0]["x"] < 850
    print("PASS GREYC grouped title rows, legacy/native layouts, multiple and hidden primary marks")
    assert_team_palettes()
    cases = [(f, "greyc-light", None) for f in FLAVORS]
    cases += [(f, p, None) for p in ("greyc-ivory", "greyc-charcoal") for f in FLAVORS]
    cases += [("minimal", "greyc-nocturne", t) for t in TEAMS]
    cases += [("legacy", "midnight", None)]
    for flavor, palette, team in cases:
        name = f"{flavor}-{palette}" + (f"-{team}" if team else "")
        options = ["--input", f"flavor={flavor}", "--input", f"palette={palette}"]
        if team:
            options += ["--input", f"team={team}"]
        path = OUTPUT / f"{name}.pdf"
        typst("compile", *options, "tests/slides.typ", path)
        events = json.loads(typst("eval", *options, "--format", "json", "--in", "tests/slides.typ",
                                  "query(<ambrosia-test>).map(it => it.value)"))
        by_id = {key: [e for e in events if e["id"] == key] for key in {e["id"] for e in events}}
        assert len(by_id["main"]) == 2
        total = by_id["ending"][0]["slide"]
        assert all(e["total"] == total for e in events)
        assert total < by_id["appendix"][0]["slide"] < by_id["appendix-next"][0]["slide"]
        text = subprocess.check_output(["pdftotext", "-layout", str(path), "-"], text=True)
        assert "Appendix body must remain visible" in text and "Another appendix body" in text
        print(f"PASS {name}: branded integration and legacy/appendix behavior")
    print("GREYC checks passed. General regression coverage lives in touying-ambrosia/tests.")


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, AssertionError, subprocess.CalledProcessError) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
