![spicegrinder-icon](../../docs/assets/spicegrinder-icon.png)
# Showcase: Clinical trial control vs treatment outcomes

**Model file:** `samples/health/clinical-trial-arms.xml`  
**Tier:** Free  
**Root:** `PatientOutcome` (0/1 response)

## Problem statement

Building and testing trial analytics (randomization checks, interim analysis code, dashboard pipelines) against **real patient outcomes** means PHI under HIPAA/GDPR and often sample sizes too small for volume or rare-event testing.

Synthetic arm-level outcomes let engineers and biostats IT validate systems before real enrollment data exists — and after, without copying identifiable records into lower environments.

## Modeling steps

1. **Control arm** — `Binomial(n=1, p=0.30)` (Bernoulli response).
2. **Treatment arm** — `Binomial(n=1, p=0.45)`.
3. **Enrollment mix** — `Mix` weights 2:1 control:treatment so draws reflect unequal allocation without a separate randomization table.

## Results (how to reproduce)

```bash
java -cp target/spicegrinder-*-free.jar com.obsvra.spicegrinder.tools.Grind --count 10 samples/health/clinical-trial-arms.xml
```

Each observation is a single 0/1 outcome from the selected arm. Aggregate many draws to estimate empirical response rates near 30% / 45% weighted by enrollment.

## How Pro-tier can go further

| Feature | What it models |
|------|-----------------|
| **Perturb** on TreatmentArm | Protocol deviations, adverse clusters |
| **Custom DataPoint** | Site, arm, covariates as one business object |
| **Import** | Per-site sub-models in a multi-center trial — see [showcase-multi-site-trial.md](showcase-multi-site-trial.md) |
