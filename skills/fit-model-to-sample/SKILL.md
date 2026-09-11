---
name: fit-model-to-sample
description: Analyzes a real data sample (a CSV export, database dump, or other tabular data) and produces a matching SpiceGrinder model definition by statistically fitting each column to SpiceGrinder's available generators, filters, and business objects. Use this skill whenever the user has real sample data and wants to generate synthetic data with a similar statistical shape, asks how to represent a dataset as a SpiceGrinder model, mentions matching, mimicking, or replicating the statistics of real data, or shares a CSV/data export and asks about modeling it, its distribution, or turning it into synthetic test data -- even if they don't explicitly say "SpiceGrinder" or "model." Do not use for general statistics questions with no SpiceGrinder connection, or for building a model from scratch with no real sample data to fit (use build-spicegrinder-model for that).
---

# Fit Model to Sample

## Overview

A user provides sample data and wants to determine how to generate similar data using SpiceGrinder. This skill turns a real data sample into a working SpiceGrinder model by fitting each column to the closest available generator, filter, or business object, then composing the pieces into a model definition.

## When to Use

Upon user request, or when the user has real sample data at hand but is unsure how to model it in SpiceGrinder.

## Instructions

1) **Ground yourself in the real component catalog before fitting anything.** Every recommendation this skill makes has to name a component that actually exists, with the actual parameters that component takes -- guessing a plausible-sounding generator name is worse than useless, since it produces a model that won't load. Read `docs/Component-Library-Reference.md` from the user's SpiceGrinder repo checkout (check your memory for the configured default location first) for the authoritative, auto-generated list of every generator, filter, and business object, its real parameters, and its Free/Pro tier. If that repo can't be found at the expected path, ask the user where their checkout lives before falling back to the bundled snapshot at `references/component-catalog.md` -- and if you do fall back to it, tell the user explicitly that it's a point-in-time copy and may be missing components added since (this project ships new business objects frequently). If no SpiceGrinder installation can be found at all -- no repo checkout, no packaged app, nothing beyond this skill's own bundle -- say so and point the user to https://obsvra.com/get-spicegrinder; the bundled snapshot still lets this skill produce a fitted draft, but nothing has validated or run that draft against a real install yet. While reading the catalog, note each candidate's tier: unless the user has confirmed they have Pro-tier access, prefer a Free-tier match and only recommend a Pro-only component when no Free-tier equivalent exists, explaining why the Pro-only one is necessary.

2) **Fit each column statistically, don't eyeball it.** For each independent subset of the data (e.g. each column in a CSV), compute summary statistics -- mean, variance, skewness, discreteness, cardinality -- and test candidate distributions against the data with a Python script (a KS test or AIC/BIC comparison across candidates). "Best fit" means the distribution the data actually supports, not a guess from looking at a few rows.

3) **Check numeric columns for correlation before fitting them independently.** Two or more numeric columns that are genuinely correlated (e.g. height and weight, or any pair with real covariance) lose that relationship if modeled as independent per-column distributions -- the synthetic data would look right column-by-column but fall apart the moment someone checks the relationship between them. Compute pairwise correlation (or a full covariance matrix for more than two columns) across the numeric columns before committing to independent fits. Where a real correlation exists, recommend SpiceGrinder's `MultivariateNormal` generator over separate univariate fits.

4) **Check for a business-object shape match before falling back to value-replay.** A column with no good statistical fit doesn't automatically mean "sample from the values I found" -- that's a real risk, not a neutral fallback. If a column's format matches an existing business object's output shape (e.g. `XXX-XX-XXXX` -> `SSN`, an 8-hex-group colon-separated string -> `MACAddress`, an `@domain`-shaped string -> `Email`), recommend that business object instead (cross-checked against the catalog from step 1 -- don't recommend a business object that isn't actually in it). Only fall back to a value-replay distribution (a Categorical/Empirical built from the observed values themselves) when no business object or generator fits *and* the column is confirmed non-identifying. Never replay real SSNs, names, emails, or other identifying values verbatim into a "synthetic" model -- that isn't synthetic data, it's the original data with extra steps, and it defeats the reason these business objects exist.

5) **Consider mixtures.** A column that resists a single clean distributional fit may actually be several distinct sub-populations mixed together (e.g. two customer segments with different purchase-amount distributions). Check whether splitting the data (by another column, or by a bimodal/multimodal shape in the fit itself) produces cleaner per-group fits before concluding the column just doesn't fit anything.

6) **Look for patterned outliers -> perturbation, not a second mixture.** After accounting for mixtures in step 5, examine what's left. If the remaining outliers follow a describable, consistent pattern relative to the base distribution (e.g. a fixed offset, a scaled variant, systematic noise around an otherwise-clean fit), that's a signal for SpiceGrinder's perturbation filter (`Perturb`) wrapping the base generator -- not a new, separate mixture component. Reserve `Mix` for genuinely distinct sub-populations (step 5) and `Perturb` for structured noise on top of one.

7) **Compose the model.** Once a best fit is established for every column, use the `build-spicegrinder-model` skill to turn the fitted pieces into an actual SpiceGrinder model definition. Don't hand-roll the XML/JSON here -- that's what the sibling skill is for.

## Output Format

Output a candidate SpiceGrinder model file in the user's preferred format (default to XML if the preferred format is unknown).
