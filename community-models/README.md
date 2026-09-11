# Community models

Models contributed by anyone, not authored by Obsvra. See [`../CONTRIBUTING.md`](../CONTRIBUTING.md) for how to add one — every submission is checked automatically (validates + reproduces its own committed output) before a maintainer reviews it, and nothing merges on a passing check alone.

**License note:** unlike the rest of this repo (MIT), everything under this directory is licensed [CC0](LICENSE) — a public-domain dedication, not a copyright license, so there's nothing to track per-file across many small third-party contributions. Each contribution's own `README.md` credits its author as a matter of convention; CC0 itself doesn't require it.

## Layout

```
community-models/
  financial/
    <model-name>/
      model.xml (or .json, or .sgm)
      README.md
      output.csv
  health/
  software/
  ecommerce/
  ...
```

A category with nothing in it yet isn't missing — it just hasn't had a first contribution. Propose a new category in your PR if none of the existing ones fit.

## Nothing here yet

This directory is intentionally empty at launch. The first entries will be whatever the community actually submits.
