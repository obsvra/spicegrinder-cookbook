# Contributing a community model

`community-models/` is open to anyone. Contributions go through two gates before they're part of the repo: an automated check when you open the PR, and a maintainer review after that passes. This document covers both.

## Where your model goes

```
community-models/<category>/<your-model-name>/
  model.xml            (or .json, or .sgm)
  README.md
  output.csv
```

Pick an existing category if your model fits one (`financial/`, `health/`, `software/`, `ecommerce/`, etc.) or propose a new one in your PR description if it doesn't. `<your-model-name>` should be short and descriptive (`claim-severity-lognormal`, not `model1` or `my-test`).

## What `README.md` needs to say

- **What this model represents** — the real-world thing it's simulating, in a sentence or two.
- **Which tier it needs** — Free or Pro, and why (name the specific Pro-only component if it needs one).
- **Anything a user should know before reusing it** — parameters they'd realistically want to recalibrate, known simplifications, anything you'd want called out if someone copied this into production use.

## What `output.csv` needs to say

The same convention every example in [`examples/`](examples/) already uses: a leading comment line naming the seed and the exact command to reproduce it, then the real output.

```
# seed=42 -- reproduce with: grind --seed 42 --count 10 community-models/<category>/<name>/model.xml
<actual output rows>
```

Ten rows is enough. The point isn't volume, it's that anyone can run your exact command against their own SpiceGrinder Free install and get byte-identical output back — that's what gets checked automatically (see below), and it's the same standard every vendor-authored example in this repo holds itself to.

## What NOT to submit

- **No real data, ever.** Every value in `model.xml`/`output.csv` has to come from the model's own generation — not values copied from a real dataset, even anonymized, even from your own systems. If a column's shape matches a business object (SSN, email, address, etc.), use that business object rather than replaying observed values — the same rule the `fit-model-to-sample` skill in this repo already follows.
- **No component that doesn't exist.** Every generator/filter/business object your model uses has to be real, checkable against `Component-Library-Reference.md`. A plausible-sounding name that doesn't exist just produces a model that won't load — the automated check will catch this, but save yourself the round-trip.
- **No custom classpath classes.** A submitted model can't reference `<definitions><custom class="...">`, `Convert`'s `class=""`, or `dataset.random` with a class name — none of us can verify what an arbitrary class on *your* classpath would actually do, and nobody reviewing or running this model has it on theirs anyway. Built-in components only.

## The automated check

Opening a PR that touches `community-models/` runs [`.github/workflows/validate-community-models.yml`](.github/workflows/validate-community-models.yml) against every changed model: downloads SpiceGrinder Free, runs `ModelValidatorApp` against your model file, then re-runs your `output.csv`'s own reproduce command and diffs the result against what you committed. A failing check means either the model doesn't validate or the committed output doesn't match a fresh run with the seed you named — fix whichever it is and push again.

This proves your model *validates and reproduces*. It doesn't (and can't) prove your model is a good representation of whatever it claims to simulate, that it's not quietly replaying real data, or that a component was used sensibly rather than just technically-correctly — that's what the human review after CI passes is for.

## Review and merge

A maintainer reviews every PR that passes CI before merging — there's no auto-merge, even on green. Expect questions if something's ambiguous (tier, real-world accuracy, an unusual component choice) rather than a silent merge or a silent close.

## License

By submitting a model, you're agreeing it can be included in this repo and redistributed under the license that applies to `community-models/` — see [`community-models/README.md`](community-models/README.md) for exactly which one and why it's separate from the rest of the repo. You keep authorship credit (your `README.md` and the git history both preserve it); you're not signing away ownership, just granting redistribution rights for what you submitted.

## Questions before you open a PR

Open a GitHub Discussion, or email [support@obsvra.com](mailto:support@obsvra.com) — either works, and a question that turns out to matter to more than one person is exactly what Discussions are for.
