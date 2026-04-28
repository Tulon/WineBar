# This script generates the following file:
#
#     ../data/locales.json
#
# Requires:
#   pip install babel

from babel import Locale, localedata
from pathlib import Path

import json


def build_locales_list():
    locale_ids = sorted(localedata.locale_identifiers())
    list_items = []
    for loc_id in locale_ids:
        if loc_id.find('_') == -1:
            # Wine doesn't like locales consisting only of a language name,
            # so, "uk_UA" is fine while "uk" is not.
            continue

        loc = Locale.parse(loc_id)

        localized_name = loc.get_display_name()
        english_name = loc.get_display_name('en')

        if localized_name is None and english_name is None:
            continue
        
        list_items.append((loc_id, localized_name, english_name))
    return list_items

if __name__ == "__main__":
    script_dir = Path(__file__).resolve().parent
    out_path = script_dir / ".." / "data" / "locales.json"

    locales_list = build_locales_list()

    with open(out_path, "w", newline="", encoding="utf-8") as f:
        json.dump(locales_list, f, ensure_ascii=False, indent=2)
    
    print("All done!")
