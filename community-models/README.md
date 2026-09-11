# Community models

Models contributed by anyone, not authored by Obsvra. See [`../CONTRIBUTING.md`](../CONTRIBUTING.md) for how to add one — every submission is checked automatically (validates + reproduces its own committed output) before a maintainer reviews it, and nothing merges on a passing check alone.

**License note:** unlike the rest of this repo, everything under this directory is contributed by third parties. <!-- TODO: state the actual license community submissions are accepted under (CC0 recommended — public-domain-equivalent, no attribution burden on reusers — but this is Obsvra's call to make explicitly, not assumed here) and confirm it doesn't need to match whatever license covers skills/ and examples/. --> Each contribution's own `README.md` credits its author regardless of license terms.

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
