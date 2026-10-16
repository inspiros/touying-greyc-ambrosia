"""Compile consumers outside both repositories using installed package roots."""

from pathlib import Path
import json
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
CORE = ROOT.parent / "touying-ambrosia"


class PackageBoundaryTests(unittest.TestCase):
    def test_real_packages_and_caller_relative_resources(self):
        with tempfile.TemporaryDirectory() as directory:
            temporary = Path(directory)
            data = temporary / "data"
            subprocess.run([sys.executable, str(ROOT / "scripts/install.py"), "--core-root", str(CORE),
                            "--data-dir", str(data), "--no-link-core"], check=True, capture_output=True, text=True)
            packages = data / "typst/packages"
            core_package = packages / "preview/touying-ambrosia/0.1.0"
            wrapper_package = packages / "local/touying-greyc-ambrosia/0.2.0"
            self.assertTrue((core_package / "assets/citations/compact-author-year.csl").is_file())
            self.assertTrue((core_package / "assets/qr/repository.svg").is_file())
            self.assertTrue((wrapper_package / "assets/qr/repository.svg").is_file())
            self.assertTrue((wrapper_package / "assets/qr/qr-code-greyc-light.svg").is_file())
            self.assertFalse((wrapper_package / "assets/qr/qr-code-greyc-dark.svg").exists())
            self.assertFalse((wrapper_package / "assets/citations").exists())
            self.assertFalse((core_package / "assets/logos/greyc").exists())
            for source in (core_package / "src").rglob("*.typ"):
                self.assertNotIn("greyc", source.read_text().lower(), source)
            for name, setup in (
                ("neutral", '#show: ambrosia-theme.with(flavor: ambrosia-flavor(name: "independent", base: "simple"), palette: "midnight", config-info(title: [External consumer], author: [Researcher]))'),
                ("greyc", '#show: greyc-theme.with(team: "safe", palette: "nocturne", config-info(title: [External consumer], author: [Researcher]))'),
            ):
                with self.subTest(package=name):
                    project = temporary / name
                    (project / "images").mkdir(parents=True)
                    (project / "images/local.svg").write_text('<svg xmlns="http://www.w3.org/2000/svg" width="240" height="120"><rect width="240" height="120" fill="#415e87"/></svg>')
                    (project / "references.bib").write_text('@book{boundary, author={Ada Boundary}, title={First Boundary Source}, year={2026}, publisher={Example Press}}\n@book{other, author={Bob Other}, title={Second Boundary Source}, year={2025}, publisher={Example Press}}')
                    shutil.copy2(core_package / "assets/citations/compact-author-year.csl", project / "local.csl")
                    package = "@preview/touying-ambrosia:0.1.0" if name == "neutral" else "@local/touying-greyc-ambrosia:0.2.0"
                    source = '#import "' + package + '": *\n#import "@preview/touying-ambrosia:0.1.0" as core\n' + setup + "\n" + '''
#title-slide()
#slide(title: [Relative references])[
  #ambrosia.block(style: "poster", shadowed: true, title: [Nested content])[
    BEFORE. #footcite(<boundary>) #core.footcite(<boundary>)
    #pause
    AFTER. #footcite(<other>, foot-style: path("local.csl"))
  ]
  ```python
  value = "packaged dark highlighting"
  ```
  #hidden-bibliography("references.bib")
]
#slide(title: [One citation identity])[Repeated through the core namespace #core.footcite(<boundary>).]
#image-slide("images/local.svg", caption: [CALLERIMAGE], alt: "A caller-owned image")
#ending-slide(title: [Questions?])[#ambrosia.credit-card(width: 65%)]
#show: appendix
== Extra material
APPENDIXBODY
#context [#metadata((slide: utils.slide-counter.get().first(), total: utils.last-slide-counter.final().first()))<external-counters>]
'''
                    document = project / "main.typ"
                    document.write_text(source)
                    options = ["--root", str(project), "--package-path", str(packages)]
                    pdf = project / "result.pdf"
                    subprocess.run(["typst", "compile", *options, str(document), str(pdf)], check=True, capture_output=True, text=True)
                    text = subprocess.check_output(["pdftotext", "-layout", str(pdf), "-"], text=True)
                    pages = text.rstrip("\f\n").split("\f")
                    self.assertEqual(len(pages), 7)
                    self.assertNotIn("AFTER", pages[1])
                    self.assertIn("AFTER", pages[2])
                    self.assertEqual(pages[1].count("First Boundary Source"), 1)
                    self.assertEqual(pages[2].count("First Boundary Source"), 1)
                    self.assertNotIn("First Boundary Source", pages[3])
                    self.assertIn("CALLERIMAGE", pages[4])
                    self.assertIn("APPENDIXBODY", pages[-1])
                    counters = json.loads(subprocess.check_output(["typst", "eval", *options, "--in", str(document),
                        "--format", "json", "query(<external-counters>).map(it => it.value)"], text=True))
                    credit = json.loads(subprocess.check_output(["typst", "eval", *options, "--in", str(document),
                        "--format", "json", "query(<ambrosia-credit-card>).map(it => it.value)"], text=True))
                    self.assertEqual(len(credit), 1)
                    self.assertEqual(credit[0]["name"], "touying-ambrosia" if name == "neutral" else "touying-greyc-ambrosia")
                    self.assertTrue(credit[0]["qr"])
                    self.assertEqual(len(counters), 1)
                    self.assertGreater(counters[0]["slide"], counters[0]["total"])


if __name__ == "__main__":
    unittest.main()
