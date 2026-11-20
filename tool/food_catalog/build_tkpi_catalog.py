#!/usr/bin/env python3
"""Bangun katalog makanan aplikasi dari snapshot TKPI (panganku.org).

Sumber: Tabel Komposisi Pangan Indonesia (TKPI), Kementerian Kesehatan RI,
https://www.panganku.org — snapshot CSV dari rilis
https://github.com/nichsedge/indoscraping/releases/tag/dataset-panganku-latest
(disalin ke tool/food_catalog/source/panganku.csv).

Aturan (brief §Database makanan Indonesia):
- Angka TIDAK diubah/ditebak. Hanya pembulatan float hasil scraping
  (0.6000000000000001 → 0.6) dan perapian spasi pada nama.
- Baris tanpa energi/protein/lemak/karbohidrat lengkap TIDAK dimasukkan.
- Baris yang energinya jauh berbeda dari 4/4/9 × makro ditandai
  quality = "inconsistent" (ditampilkan sebagai peringatan di aplikasi).
- Semua nilai per 100 g bagian yang dapat dimakan (BDD).

Pemakaian:  python3 tool/food_catalog/build_tkpi_catalog.py
"""

import csv
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "tool/food_catalog/source/panganku.csv"
OUT = ROOT / "assets/catalog/foods_tkpi.json"

VERSION = "tkpi-panganku-2026-10-28"
# Toleransi selisih energi tercatat vs 4/4/9 × makro sebelum ditandai.
INCONSISTENT_TOLERANCE = 0.35


def num(s):
    s = (s or "").strip()
    if not s:
        return None
    v = round(float(s), 2)
    return int(v) if v == int(v) else v


def clean_name(s):
    s = re.sub(r"\s+", " ", s.strip())
    s = re.sub(r"\s+,", ",", s)
    s = re.sub(r",(?=\S)", ", ", s)
    return s


def main():
    raw = SRC.read_bytes()
    rows = list(csv.DictReader(raw.decode("utf-8").splitlines()))
    foods, skipped = [], []
    for r in rows:
        kcal, p, f, c = (num(r[k]) for k in ("Energy", "Protein", "Fat", "CHO"))
        if None in (kcal, p, f, c):
            skipped.append(f'{r["Kode"]} {r["Nama"]}')
            continue
        computed = 4 * p + 4 * c + 9 * f
        inconsistent = abs(computed - kcal) > INCONSISTENT_TOLERANCE * max(kcal, 20)
        food = {
            "code": r["Kode"].strip(),
            "name": clean_name(r["Nama"]),
            "category": r["Kategori"].strip(),
            "form": "raw" if r["Tipe Bahan"].startswith("Mentah") else "processed",
            "kcal": kcal,
            "protein": p,
            "fat": f,
            "carbs": c,
            "quality": "inconsistent" if inconsistent else "source",
        }
        for key, col in (("origin", "Asal"), ("note", "Keterangan")):
            v = r[col].strip()
            if v:
                food[key] = re.sub(r"\s+", " ", v)
        fiber = num(r["Fibre"])
        if fiber is not None:
            food["fiber"] = fiber
        bdd = num(r["BDD"])
        if bdd is not None:
            food["ediblePct"] = bdd
        foods.append(food)

    foods.sort(key=lambda x: x["code"])
    codes = [x["code"] for x in foods]
    assert len(codes) == len(set(codes)), "kode TKPI duplikat"

    out = {
        "version": VERSION,
        "source": {
            "name": "Tabel Komposisi Pangan Indonesia (TKPI)",
            "publisher": "Kementerian Kesehatan Republik Indonesia",
            "url": "https://www.panganku.org",
            "snapshot": "https://github.com/nichsedge/indoscraping/releases/tag/dataset-panganku-latest",
            "retrieved": "2026-11-20",
            "sha256": hashlib.sha256(raw).hexdigest(),
            "basis": "per 100 g bagian yang dapat dimakan (BDD)",
        },
        "skipped": skipped,
        "foods": foods,
    }
    OUT.write_text(json.dumps(out, ensure_ascii=False, separators=(",", ":")) + "\n", "utf-8")
    flagged = sum(1 for x in foods if x["quality"] == "inconsistent")
    print(f"{len(foods)} makanan → {OUT.relative_to(ROOT)} "
          f"({flagged} ditandai inconsistent, {len(skipped)} dilewati: {skipped})")


if __name__ == "__main__":
    sys.exit(main())
