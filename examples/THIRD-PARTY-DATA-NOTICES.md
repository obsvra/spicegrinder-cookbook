# Third-party data notices

Some of the reference tables under `examples/` (mostly `examples/pro/`) were made from data published by others. This page credits them and says under which license each is used. The tables are not covered by this repository's MIT license: each stays under the license listed here. Each file's own header comment repeats its source.

This page is the data section of SpiceGrinder's `THIRD-PARTY-NOTICES.md`, copied from the product's own documentation. Where it says `samples/`, the same file is under `examples/` here.

## Sources

| File | Source | License |
|---|---|---|
| `city_state_zip.csv` | GeoNames postal code data, United States (download.geonames.org/export/zip) | CC BY 4.0 |
| `city_province_postal_ca.csv` | GeoNames postal code data, Canada (download.geonames.org/export/zip/CA_full.csv.zip). Changed from the source: a sample of its rows, reordered, with a weight column added. | CC BY 4.0 |
| `street_names_weighted.csv` | US Census Bureau, 2025 TIGER/Line Feature Names files; counts by county are ours | Public domain (US government work) |
| `street_names_ca_weighted.csv`, `street_names_qc_weighted.csv` | Statistics Canada, 2021 Census Road Network File; counts by municipality are ours | Statistics Canada Open Licence (notice below) |
| `female_names.csv`, `male_names.csv`, `female_names_weighted.csv`, `male_names_weighted.csv` | US Social Security Administration, Popular Baby Names (ssa.gov/oact/babynames) | Public domain (US government work) |
| `surnames.csv`, `surnames_weighted.csv` | US Census Bureau, Frequently Occurring Surnames from the 2010 Census | Public domain (US government work) |
| `email_words.txt` | SCOWL (Spell Checker Oriented Word Lists), levels 10 and 20; offensive words removed using the LDNOOBW list | SCOWL permission notice (below); LDNOOBW CC BY 4.0 |
| `area_codes.csv` | North American Numbering Plan Administration, NPA report (reports.nanpa.com) | Public factual data |
| `mac_vendors.csv` | IEEE Registration Authority, MA-L public listing (standards-oui.ieee.org) | Public factual data |
| `vin_manufacturers.csv` | NHTSA vPIC database (vpic.nhtsa.dot.gov) | Public domain (US government work) |
| `useragent_browser_os_weighted.csv` | StatCounter Global Stats (https://gs.statcounter.com) | CC BY-SA 3.0; this file is an adaptation and is itself distributed under CC BY-SA 3.0 |
| `creditcard_networks_weighted.csv` | Market-share figures from WalletHub's published compilation (wallethub.com) | Facts, credited |
| `email_domains_weighted.csv` | Provider user-share figures from SellCell's published compilation (sellcell.com) | Facts, credited |
| `domain_tlds.csv` | Top-level domains, checked against Hostinger's and domaindetails.com's published registration statistics | Facts, credited |
| `iban_countries.csv`, `isbn_registration_groups.csv`, `business_suffixes.csv` | Standard codes and naming conventions (ISO 13616, the International ISBN Agency's group identifiers, US business-entity suffixes) | Facts |
| `software/customers-de.csv`, `-fr.csv`, `-es.csv` | Generated with Faker (github.com/joke2k/faker) by `samples/pro/software/build-pools.py` | Faker is MIT-licensed, Copyright (c) 2012 Daniele Faraglia |
| `health/member-pool.csv` | Generated with Synthea (github.com/synthetichealth/synthea), as described in `samples/docs/showcase-synthea-claims.md` | Synthea is Apache-2.0-licensed; the records are synthetic |

### Required notices

**GeoNames.** Postal code data from GeoNames (https://www.geonames.org), licensed under the Creative Commons Attribution 4.0 License (https://creativecommons.org/licenses/by/4.0/).

**Statistics Canada.** Adapted from Statistics Canada, 2021 Census Road Network File, 2021. This does not constitute an endorsement by Statistics Canada of this product. Used under the Statistics Canada Open Licence (https://www.statcan.gc.ca/en/terms-conditions/open-licence).

**StatCounter.** Browser and operating-system share figures from StatCounter Global Stats (https://gs.statcounter.com), licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License (https://creativecommons.org/licenses/by-sa/3.0/). `useragent_browser_os_weighted.csv` adapts those figures and is distributed under the same license.

**LDNOOBW.** Offensive-word filtering uses the List of Dirty, Naughty, Obscene, and Otherwise Bad Words (https://github.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words), licensed under the Creative Commons Attribution 4.0 License. The list itself isn't included.

**SCOWL.** `email_words.txt` is drawn from SCOWL (http://wordlist.aspell.net), whose notice follows:

> Copyright 2000-2018 by Kevin Atkinson
>
> Permission to use, copy, modify, distribute and sell these word lists, the associated scripts, the output created from the scripts, and its documentation for any purpose is hereby granted without fee, provided that the above copyright notice appears in all copies and that both that copyright notice and this permission notice appear in supporting documentation. Kevin Atkinson makes no representations about the suitability of this array for any purpose. It is provided "as is" without express or implied warranty.

SCOWL's most common words, the levels used here, come from the public-domain Moby Words II lexicon (Grady Ward) and Brian Kelk's public-domain UK English Wordlist with Frequency Classification.

**Faker.** The customer pools were generated with Faker. Copyright (c) 2012 Daniele Faraglia. Faker is distributed under the MIT License (https://github.com/joke2k/faker/blob/master/LICENSE.txt).

**Synthea.** The member pool was generated with Synthea, Copyright 2017-2025 The MITRE Corporation, distributed under the Apache License 2.0 (https://github.com/synthetichealth/synthea/blob/master/LICENSE).

### How the tables are rebuilt

The address, street-name and word-list tables are built by scripts under `scripts/data/` (`build_us_street_names.py`, `build_canada_address_tables.py`, `build_email_words.py`), which name their sources and filtering in their own comments. The downloaded sources aren't included.
