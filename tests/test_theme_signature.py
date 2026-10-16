"""Keep the IDE-visible wrapper signature synchronized with its pinned core."""
import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("sync_theme_signature", ROOT / "scripts/sync-theme-signature.py")
sync = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sync)


class ThemeSignatureTests(unittest.TestCase):
    def test_signature_and_forwarding_match_core(self):
        source = (ROOT.parent / "touying-ambrosia/src/theme/base.typ").read_text()
        signature, forwarding = sync.render(source)
        wrapper = (ROOT / "src/theme/greyc.typ").read_text()
        self.assertEqual(wrapper, sync.update(sync.update(wrapper, "PARAMETERS", signature), "FORWARDING", forwarding))

    def test_nested_defaults_stay_intact(self):
        source = (ROOT.parent / "touying-ambrosia/src/theme/base.typ").read_text()
        params = dict(sync.parameters(source))
        self.assertEqual(params["header-a-columns"], "(1fr, 1fr)")
        self.assertIn('selector-filter:', params["header-aa"])
        self.assertIn('display-current-heading(', params["header-aa"])
        self.assertEqual(params["brand-color"], "auto")
        signature, forwarding = sync.render(source)
        self.assertIn("title: auto,", signature)
        self.assertIn('..if title == auto { (:) } else { (title: title,) }', forwarding)


if __name__ == "__main__":
    unittest.main()
