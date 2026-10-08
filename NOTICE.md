# Notice

This repository uses three different license terms depending on which files you're looking at. See the [README](README.md#license) for the short version; this file lists the exception in full.

## Excluded from the MIT license: bundled skill reference docs

Everything under `plugins/spicegrinder/skills/*/references/` (`Customization.md`, `ModelAnalyzerApp.md`, `Model-File-Format-Reference.md`, and the `component-catalog.md` snapshots) is a copy of SpiceGrinder's own product documentation, included here only so a skill has something to ground itself in when SpiceGrinder isn't installed locally.

These files are **not** covered by this repository's MIT license. They remain:

> © Obsvra. These documents describe SpiceGrinder and are provided to help you evaluate and use it. They are not a license to reproduce, adapt, or use this material to build a competing product or service.

Redistributing them as part of this repository (or a fork of it) for the purpose of using SpiceGrinder is fine — that's the point of them being here. Extracting and reusing them for something else isn't covered by anything in this repo.

## Separately licensed: community-models/

Everything under `community-models/` is licensed under CC0 1.0 Universal, not MIT — see [`community-models/LICENSE`](community-models/LICENSE). This is deliberate: contributions come from many different people over time, and CC0's public-domain dedication avoids needing to track per-file attribution/license compliance for hundreds of small community submissions. Each contribution's own `README.md` credits its author as a matter of repository convention, independent of what the license itself requires.

## Not covered by the MIT license: share-alike data files

The following files are NOT covered by this repository's MIT license, and neither is anything derived from them:

- `examples/pro/useragent_browser_os_weighted.csv`
- `examples/pro/useragent.csv`

`useragent_browser_os_weighted.csv` adapts browser and operating-system share figures from StatCounter Global Stats (https://gs.statcounter.com), which StatCounter licenses under the Creative Commons Attribution-ShareAlike 3.0 Unported License (https://creativecommons.org/licenses/by-sa/3.0/). `useragent.csv` is the recorded output of a model that samples from that table, so it is derived from it. Both files remain under CC BY-SA 3.0, with attribution to StatCounter Global Stats (the attribution text is in `examples/THIRD-PARTY-DATA-NOTICES.md`). If you copy, adapt or build on them you must keep the attribution, make clear that yours is an adaptation, and license the result under CC BY-SA 3.0 as well. The root LICENSE (MIT) does not apply to them. The model file `examples/pro/useragent.xml` only refers to the table by path and contains none of its data, so it stays under MIT.

## Everything else

`plugins/spicegrinder/skills/*/SKILL.md`, `CONTRIBUTING.md`, this file, the GitHub Actions workflow, and the example models under `examples/` (the `.xml`, `.json` and `.sgm` files, their `.csv` output records, except the two share-alike files listed above, and the READMEs) are covered by the root [LICENSE](LICENSE) (MIT).

## Separately licensed: reference data tables under examples/

The reference tables the example models read (the `.csv` and `.txt` data files under `examples/pro/`, and `examples/health/` and `examples/software/` where they carry a source header) come from third-party sources and keep those sources' licenses (CC BY 4.0, CC BY-SA 3.0, the Statistics Canada Open Licence, and others). They are listed one by one, with attribution, in [`examples/THIRD-PARTY-DATA-NOTICES.md`](examples/THIRD-PARTY-DATA-NOTICES.md). Reusing them means following those licenses, not the MIT license above.
