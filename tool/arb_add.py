"""Adds or removes strings in lib/l10n/app_{en,de}.arb.

Usage: python3 tool/arb_add.py strings.json

strings.json:
  {"en": {"key": "Text {name}"}, "de": {"key": "Text {name}"},
   "types": {"key": {"name": "int"}}, "remove": ["oldKey"]}

Placeholders default to String; plural/select messages need manual metadata.
Run `flutter gen-l10n` afterwards.
"""
import json
import pathlib
import re
import sys

spec = json.load(open(sys.argv[1]))
root = pathlib.Path(__file__).resolve().parent.parent / 'lib' / 'l10n'

for lang in ('en', 'de'):
    path = root / f'app_{lang}.arb'
    data = json.loads(path.read_text())
    for key in spec.get('remove', []):
        data.pop(key, None)
        data.pop('@' + key, None)
    for key, value in spec.get(lang, {}).items():
        data[key] = value
        placeholders = re.findall(r'\{(\w+)\}', value)
        if lang == 'en' and placeholders and not re.search(r'\{\w+,', value):
            types = spec.get('types', {}).get(key, {})
            data['@' + key] = {
                'placeholders': {
                    name: {'type': types.get(name, 'String')}
                    for name in dict.fromkeys(placeholders)
                }
            }
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')
