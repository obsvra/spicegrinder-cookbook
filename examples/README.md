# SpiceGrinder sample models

Free-tier showcase models live at the top level and in `financial/`, `health/`, and `software/`; everything under `pro/` needs a Pro license to load. Every model file has a matching `.csv` — see "Reproducing an example" below.

## Free-tier showcase models

Six models in three domains. All load under the **Free** tier (numeric core only).

## JSON versions

Every model above (plus the D&D bonus sample) ships a `.json` twin alongside its `.xml` original — e.g. [claims-frequency-severity.json](financial/claims-frequency-severity.json) next to [claims-frequency-severity.xml](financial/claims-frequency-severity.xml). Generated mechanically (parsed the XML, re-serialized as JSON), not hand-translated, and verified: loading either twin with the same explicit seed produces byte-identical generated output. They exist to demonstrate the two formats are genuinely interchangeable, not just theoretically so — pick whichever fits your own tooling/diffing preferences.

**One real difference**: XML supports comments (`<!-- ... -->`); JSON doesn't. The narrative header comment at the top of each `.xml` file (what the model demonstrates, the Pro upgrade path pointers) has no JSON equivalent and isn't carried over — the `.json` twin is a functionally identical but undocumented sibling.

## Bonus sample

[dnd-ability-scores.xml](dnd-ability-scores.xml) — old-school D&D ability scores (3d6, six times, no rerolls). A small, deliberately silly but relatable demo of composing core primitives. It demonstrates a simple pipeline with no branching: `Uniform` (continuous draw) → `ToInteger` (convert to integer to get a d6 [six-sided die roll]) → `Redimension` (1:3 to get three d6 values) → `Calculate` (add them together) → `Drop` (discard the unneeded values) → `Redimension` (1:6 to collect six total 3d6 results together).

Run it:

```bash
grind --count 5 examples/dnd-ability-scores.xml
```

## Pro-tier samples

Everything under [`pro/`](pro/) demonstrates a Pro-only capability — business objects (`SSN`, `CreditCard`, `Email`, `Phone`, ...), `Import`-based model decomposition, `Perturb` anomaly injection, and more. Each still has its own seed-tagged `.csv`; you'll need a Pro license to actually run one yourself (see [obsvra.com/get-spicegrinder](https://obsvra.com/get-spicegrinder)), but the committed output lets you inspect what a Pro-only model produces either way.

## Reproducing an example

Every `.csv` in this tree starts with a comment line naming the seed and the exact command that produced the rest of the file:

```
# seed=42 -- reproduce with: grind --seed 42 --count 10 examples/financial/claims-frequency-severity.xml
```

Run that command yourself (adjust the path to wherever you cloned this repo) and the output should match the remaining rows exactly — the same "byte for byte, every time" claim every SpiceGrinder example in this repo holds itself to.