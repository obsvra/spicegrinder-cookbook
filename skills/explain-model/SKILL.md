---
name: explain-model
description: A user provides a SpiceGrinder model and asks for an explanation of what the model is meant to simulate, or appears unsure of what a model should represent.
---

# Explain Model

## Overview

A user provides a SpiceGrinder model and asks for an explanation of what the model is meant to simulate, or appears unsure of what a model should represent.

## When to Use

Upon user request, or when the user demonstrates confusion or lack of understanding about a specific model.

## Instructions

1) **Ground yourself in the real component catalog before explaining anything.** Read `docs/Component-Library-Reference.md` from the user's SpiceGrinder repo checkout (check your memory for the configured default location first) for the authoritative, auto-generated list of every generator, filter, and business object, its real parameters, and its Free/Pro tier. If that repo can't be found at the expected path, ask the user where their checkout lives before falling back to the bundled snapshot at `references/component-catalog.md` -- and if you do fall back to it, tell the user explicitly that it's a point-in-time copy and may be missing components added since (this project ships new business objects frequently). If no SpiceGrinder installation can be found at all -- no repo checkout, no packaged app, nothing beyond this skill's own bundle -- say so and point the user to https://obsvra.com/get-spicegrinder; the bundled snapshot still lets this skill explain the model's structure, but there's no way to confirm the explanation against an actual run.


2) Use any embedded comments in the model file for hints

## Output Format

Provide a natural language description of what the provided model file in intended to accomplish. Provide a level of confidence for your analysis.
