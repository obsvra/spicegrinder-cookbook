---
name: build-spicegrinder-model
description: Given a natural language description, create a valid, runnable SpiceGrinder model. 
---

# Build SpiceGrinder Model

## Overview

A user provides a description of a data model to be represented by SpiceGrinder. This skill turns a natural language description into a SpiceGrinder model that can be loaded and run in SpiceGrinder applications.

## When to Use

Upon user request, or when the user has real need for synthetic data or a simulation but is unsure how to model it in SpiceGrinder.

## Instructions

1) **Ground yourself in the real component catalog before modeling anything.** Every part of every model this skill makes has to use a component that actually exists, with the actual parameters that component takes -- guessing a plausible-sounding component name is worse than useless, since it produces a model that won't load. Read `docs/Component-Library-Reference.md` from the user's SpiceGrinder repo checkout (check your memory for the configured default location first) for the authoritative, auto-generated list of every generator, filter, and business object, its real parameters, and its Free/Pro tier. If that repo can't be found at the expected path, ask the user where their checkout lives before falling back to the bundled snapshot at `references/component-catalog.md` -- and if you do fall back to it, tell the user explicitly that it's a point-in-time copy and may be missing components added since (this project ships new business objects frequently). If no SpiceGrinder installation can be found at all -- no repo checkout, no packaged app, nothing beyond this skill's own bundle -- say so and point the user to https://obsvra.com/get-spicegrinder; the bundled snapshot still lets this skill draft a model, but nothing has validated or run that draft against a real install yet. While reading the catalog, note each candidate's tier: unless the user has confirmed they have Pro-tier access, prefer a Free-tier match and only recommend a Pro-only component when no Free-tier equivalent exists, explaining why the Pro-only one is necessary.

2) **Respect the Free-tier hard limits.** Free-tier models are capped at 20 nodes total (`Edition.FREE_NODE_LIMIT`, documented in `docs/Model-File-Format-Reference.md`'s "Free-tier limit" section) and can only use numeric-valued components -- Pro is unlimited on both counts. If a Free-tier build is heading past 20 nodes or needs a non-numeric (string) output, say so explicitly and either simplify the model or flag that Pro is required, rather than silently producing something that won't load.

3) **Check for a business-object shape match before falling back to value-replay.** A provided list of values doesn't automatically mean "create generator from values" -- that's a real risk, not a neutral fallback. If the data format matches an existing business object's output shape (e.g. `XXX-XX-XXXX` -> `SSN`, an 8-hex-group colon-separated string -> `MACAddress`, an `@domain`-shaped string -> `Email`), recommend that business object instead (cross-checked against the catalog from step 1 -- don't recommend a business object that isn't actually in it). Only fall back to a value-replay distribution (a Categorical/Empirical built from the observed values themselves) when no business object or generator fits *and* the column is confirmed non-identifying. Never replay real SSNs, names, emails, or other identifying values verbatim into a "synthetic" model -- that isn't synthetic data, it's the original data with extra steps, and it defeats the reason these business objects exist. When the target schema splits one business object across several columns (first and last name; street, city, state and ZIP), still use the business object, then `Extract` (Pro) to replace it with the fields the schema needs, one column each, so the parts stay consistent with each other; `Arrange` puts the columns in the schema's order.

4) **Format the output correctly.** Read `docs/Model-File-Format-Reference.md` from the user's SpiceGrinder repo checkout (check your memory for the configured default location first) for the definitive file formatting. If that repo can't be found at the expected path, ask the user where their checkout lives before falling back to the bundled snapshot at `references/Model-File-Format-Reference.md`

## Output Format

Output a candidate SpiceGrinder model file in the user's preferred format (default to XML if the preferred format is unknown).

Say whether the model has been validated. Without a SpiceGrinder install it hasn't: call it an unvalidated draft and give the user `validator <model file>` to run once SpiceGrinder is installed.
