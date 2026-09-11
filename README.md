# SpiceGrinder Cookbook

Agent skills, worked examples, and community-contributed models for [SpiceGrinder](https://obsvra.com) — Obsvra's local, deterministic synthetic-data engine.

**This is not the engine.** SpiceGrinder itself (the Free/Pro/Enterprise application) is closed-source and lives elsewhere. Nothing in this repo can generate data on its own — get the actual engine at [obsvra.com/get-spicegrinder](https://obsvra.com/get-spicegrinder) (Free tier costs nothing, no credit card). What's here is everything *around* the engine: how to describe your data to it, and proof that what it produces is exactly what it claims.

## What's in here

- **[`skills/`](skills/)** — six Claude Code agent skills (`build-spicegrinder-model`, `explain-model`, `extend-spicegrinder`, `fit-model-to-sample`, `pii-audit`, `tune-model-performance`). Point your agent at this directory and it can draft, explain, fit, extend, audit, or tune a SpiceGrinder model for you — grounded in the real component catalog, never guessing at a component that doesn't exist. Works even without SpiceGrinder installed (drafts a model you can validate once you do install it); several skills need a real install to actually run validation/profiling — each one says so.
- **[`examples/`](examples/)** — every showcase and library model from SpiceGrinder's own Free and Pro sample set, each with a matching `.csv` recording the seed used and the exact command to reproduce it. This is the "byte for byte, every time" determinism claim, made checkable: run the same model with the same seed on your own machine and diff the output yourself.
- **[`community-models/`](community-models/)** — models contributed by anyone, reviewed and validated before merge. See [CONTRIBUTING.md](CONTRIBUTING.md) if you want to add one.

## Quick start

**Using a skill with Claude Code**: clone this repo (or just `skills/`) into a project, and ask Claude to build/explain/fit/audit a model — it'll find and use the relevant skill automatically. Skills that need to validate or run a model against a real install will tell you if SpiceGrinder isn't found and point you to [obsvra.com/get-spicegrinder](https://obsvra.com/get-spicegrinder).

**Reproducing an example**: every file under `examples/` that ends in `.csv` starts with a `# seed=N -- reproduce with: grind --seed N --count 10 <path>` comment. Install SpiceGrinder Free, run that exact command, and the output should match the rest of the file line for line.

```bash
grind --seed 42 --count 10 examples/financial/claims-frequency-severity.xml
```

**Contributing a model**: read [CONTRIBUTING.md](CONTRIBUTING.md) — every submission needs to validate cleanly and ship with its own seed + sample output, checked automatically before a human ever reviews it.

## Elsewhere

- [obsvra.com](https://obsvra.com) — product site, pricing, download
- [obsvra.com/learn](https://obsvra.com/learn) — Modeling 101 / Agents 101 / Ops 101 lesson tracks
- [obsvra.com/docs](https://obsvra.com/docs) — full reference documentation
- [obsvra.com/security](https://obsvra.com/security) — what SpiceGrinder does and doesn't do with your data

Questions, feedback, or something in this repo looks wrong: [support@obsvra.com](mailto:support@obsvra.com).
