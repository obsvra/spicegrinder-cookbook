![spicegrinder-icon](../../docs/assets/spicegrinder-icon.png)
# Showcase: Multi-center clinical trial with parameterized per-site sub-models

**Model files:** `samples/pro/health/clinical-trial-multi-site.xml` (outer model), `samples/pro/health/site-arm-lib.xml` (shared library)
**Tier:** Pro
**Root:** `TrialOutcome` (0/1 pooled response)
**Builds on:** [Showcase: Clinical trial control vs treatment outcomes](showcase-health-trial.md) (Free) — same Mix/Binomial shape, one site.

## Problem statement

A real multi-center trial doesn't have one control rate and one treatment rate — it has one *per site*. Different patient populations, standard-of-care baselines, and protocol adherence shift both the true response rate and the apparent effect size at each site, even under a single shared protocol. Code that pools or meta-analyzes multi-site data (random-effects models, I² heterogeneity statistics, DSMB interim-monitoring dashboards) needs to be tested against data with a **known, per-site ground truth** — not just a single flat rate repeated four times, and not four hand-duplicated model files that quietly drift out of sync with each other as the trial design evolves.

Before parameterized sub-models, the only way to represent "the same trial-arm logic, four times, with different numbers" without a custom Java component was to copy `clinical-trial-arms.xml` four times by hand — four files to keep in sync every time the shared Mix/Binomial structure itself needs to change.

## Modeling steps

1. **`site-arm-lib.xml`** — the shared per-site model: a `Mix` of `Binomial(n=1, p=$controlP)` / `Binomial(n=1, p=$treatmentP)` control/treatment arms, enrollment-weighted `$controlWeight`:`$treatmentWeight` (default 2:1). All four values are `<declare>`d with the original single-site showcase's own numbers as defaults.
2. **Four `<Import>`s, one per site** — `clinical-trial-multi-site.xml` imports `site-arm-lib.xml` four times, each overriding just the `controlP`/`treatmentP` that site's own real-world-realistic response rates need (`RuralSite` also overrides its enrollment ratio — a site-specific amendment — the other three keep the library's 2:1 default, deliberately showing "override some or all of the declared values," not "override everything every time").
3. **Pool** — an outer `Mix`, weighted by each site's real enrollment share (40% / 30% / 20% / 10%), combines all four sites' outcome streams into one pooled `TrialOutcome`.

```xml
<!-- site-arm-lib.xml -->
<definitions>
	<declare name="controlP" value="0.30"/>
	<declare name="treatmentP" value="0.45"/>
	<declare name="controlWeight" value="2"/>
	<declare name="treatmentWeight" value="1"/>
</definitions>
<nodes>
	<Mix name="SiteOutcome" synchronous="false">
		<input name="ControlArm" weight="$controlWeight"/>
		<input name="TreatmentArm" weight="$treatmentWeight"/>
	</Mix>
	<Binomial name="ControlArm" n="1" p="$controlP"/>
	<Binomial name="TreatmentArm" n="1" p="$treatmentP"/>
</nodes>
```

```xml
<!-- clinical-trial-multi-site.xml (excerpt) -->
<Import name="AcademicCenter" file="site-arm-lib.xml" controlP="0.27" treatmentP="0.49"/>
<Import name="CommunityHospital" file="site-arm-lib.xml" controlP="0.31" treatmentP="0.45"/>
<Import name="RuralSite" file="site-arm-lib.xml"
	controlP="0.34" treatmentP="0.42" controlWeight="1" treatmentWeight="1"/>
<Import name="IntlSite" file="site-arm-lib.xml" controlP="0.20" treatmentP="0.38"/>
```

## Results (how to reproduce)

```bash
java -cp target/spicegrinder-*-pro.jar com.obsvra.spicegrinder.tools.Grind --seed 42 --count 20000 \
  samples/pro/health/clinical-trial-multi-site.xml | sort | uniq -c
```

Real output from that exact command: **6,788 / 20,000 responders (33.9%) pooled** across all four sites — each site's own true rate is known by construction, so a heterogeneity-detection pipeline under test has a real answer to check against, not a guess. Loading each site's `<Import>` alone (overriding nothing else) reproduces its own independent rate:

| Site | `controlP` | `treatmentP` | Enrollment ratio | Enrollment share | Real observed rate (n=20,000) |
|---|---|---|---|---|---|
| AcademicCenter | 0.27 | 0.49 | 2:1 (default) | 40% | 34.3% |
| CommunityHospital | 0.31 | 0.45 | 2:1 (default) | 30% | 35.5% |
| RuralSite | 0.34 | 0.42 | 1:1 (overridden) | 20% | 37.9% |
| IntlSite | 0.20 | 0.38 | 2:1 (default) | 10% | 25.7% |

## How Pro-tier can go further

| Feature | What it models |
|------|-----------------|
| **Perturb** on one site's arm | A protocol-deviation cluster at a single site, not the whole trial |
| **Custom DataPoint** | `SiteVisit` carrying site ID, region, and covariates alongside the 0/1 outcome |
| **A fifth site added by copy-paste of one `<Import>` line** | No new file, no risk of the shared logic drifting between sites |
| **Service API** | Regenerate one site's synthetic arm on demand as its real enrollment/response assumptions change, without touching the other three |
