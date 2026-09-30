![spicegrinder-icon](../docs/assets/spicegrinder-icon.png)
# SpiceGrinder Free-tier sample models

Six models in three domains. All load under the **Free** tier (numeric core only).

## JSON versions

Every model above (plus the D&D bonus sample) ships a `.json` twin alongside its `.xml` original — e.g. [claims-frequency-severity.json](financial/claims-frequency-severity.json) next to [claims-frequency-severity.xml](financial/claims-frequency-severity.xml). Generated mechanically (parsed the XML, re-serialized as JSON), not hand-translated, and verified: loading either twin with the same explicit seed produces byte-identical generated output. They exist to demonstrate the two formats are genuinely interchangeable, not just theoretically so — pick whichever fits your own tooling/diffing preferences.

**One real difference**: XML supports comments (`<!-- ... -->`); JSON doesn't. The narrative header comment at the top of each `.xml` file (what the model demonstrates, the Pro upgrade path pointers) has no JSON equivalent and isn't carried over — the `.json` twin is a functionally identical but undocumented sibling.

## Bonus sample

[dnd-ability-scores.xml](dnd-ability-scores.xml) — old-school D&D ability scores (3d6, six times, no rerolls). A small, deliberately silly but relatable demo of composing core primitives. It demonstrates a simple pipeline with no branching: `Uniform` (continuous draw) → `ToInteger` (convert to integer to get a d6 [six-sided die roll]) → `Redimension` (1:3 to get three d6 values) → `Calculate` (add them together) → `Arrange` (keep only the sum) → `Redimension` (1:6 to collect six total 3d6 results together).

Run it:

```bash
java -cp target/spicegrinder-*-free.jar com.obsvra.spicegrinder.tools.Grind --count 5 samples/dnd-ability-scores.xml
```