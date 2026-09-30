"""Build locale-specific customer pools with Faker, one CSV per market."""
import csv
from faker import Faker

LOCALES = {
    "de_DE": ("customers-de.csv", "DE"),
    "fr_FR": ("customers-fr.csv", "FR"),
    "es_ES": ("customers-es.csv", "ES"),
}
ROWS = 200

for locale, (path, cc) in LOCALES.items():
    fake = Faker(locale)
    Faker.seed(42)                      # reproducible pool
    seen, out = set(), []
    while len(out) < ROWS:
        name = fake.name()
        if name in seen:
            continue
        seen.add(name)
        # Country-prefix the postcode so it stays a string: a bare "09010"
        # is parsed as a number by FlatFile and loses its leading zero.
        out.append([name, fake.city(), f"{cc}-{fake.postcode()}"])
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["FULL_NAME", "CITY", "POSTCODE"])
        w.writerows(out)
    print(f"{locale:6s} -> {path} ({len(out)} rows)")
