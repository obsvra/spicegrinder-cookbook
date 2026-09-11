![spicegrinder-icon](../../docs/assets/spicegrinder-icon.png)
# Showcase: Insurance claim frequency & severity

**Model file:** `samples/financial/claims-frequency-severity.xml`  
**Tier:** Free  
**Root:** `ClaimObservation` → `[frequency, severity]`

## Problem statement

Underwriting and claims analytics need large volumes of claim counts and sizes.
Using **production claims** has two structural problems:

1. **Privacy** — policyholder identifiers, addresses, and loss details are sensitive.
2. **Coverage of the future** — historical claims only show what has already happened; capital models and regression tests need scenarios that have not occurred yet (catastrophe clusters, inflation shocks, new product lines).

Synthetic frequency/severity data lets teams stress pipelines and models without exporting PII and without being limited to the past.

## Modeling steps

1. **Frequency** — `Poisson(lambda=3.5)` for claims per period.
2. **Severity** — `Lognormal(mu=8, sigma=1.2)` for heavy-tailed dollar amounts
   (interpret on a log scale appropriate to your currency unit).
3. **Combine** — `Append` so each observation is a pair `(count, amount)`.

## Results (how to reproduce)

```bash
java -cp target/spicegrinder-*-free.jar com.obsvra.spicegrinder.tools.Grind --count 10 samples/financial/claims-frequency-severity.xml
```

Or load with `ModelLoader` and draw N observations from root `ClaimObservation` in your own code.

Expect integer-like frequencies (Poisson) and positive continuous severities (Lognormal).

## How Pro-tier can go further

| Feature | What it models |
|------|-----------------|
| **Perturb** on Severity | Catastrophe spikes / systemic loss bursts |
| **Custom DataPoint** | `ClaimEvent` with line-of-business, region |
| **Import** | Shared `claims-core` library across products |
