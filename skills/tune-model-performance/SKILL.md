---
name: tune-model-performance
description: A user provides a SpiceGrinder model and wants a performance review -- identifying inefficient structure, likely bottleneck nodes, and suggestions for improvement based on the Model Analyzer's documented profiling process and any previously recorded component costs.
---

# Tune Model Performance

## Overview

A user provides a SpiceGrinder model and requests a performance review of it.

## When to Use

Upon user request.

## Instructions

1) **Refer to the Model Analyzer documentation.** Every recommendation this skill makes has to name a component that actually exists, with the actual documented performance of that component -- guessing a plausible-sounding set of changes is worse than useless, since it produces a model that either won't load or doesn't actually perform any better. Read `docs/ModelAnalyzerApp.md` from the user's SpiceGrinder repo checkout (check your memory for the configured default location first) for SpiceGrinder's performance profiling process and what the results mean. If that repo can't be found at the expected path, fall back to the bundled snapshot at `references/ModelAnalyzerApp.md`. Also look in the user's `~/.spicegrinder/component-weights.properties` for previously computed costs for specific components. If no SpiceGrinder installation can be found at all -- no repo checkout, no packaged app -- stop and point the user to https://obsvra.com/get-spicegrinder; unlike the docs-only fallback above, there's no bundled substitute for actually running `ModelAnalyzerApp` (step 2 below), so this skill can't produce real numbers without a real install.

2) **Run the analyzer against the actual model, don't reason about it from the docs alone.** This skill's whole premise is naming real numbers, not plausible-sounding guesses. Two separate things to get right:

   **Which JDK to run under.** This project targets JDK 25 (`maven.compiler.release` in `pom.xml`) -- an older default `java` throws `UnsupportedClassVersionError` on the jar's class files, not something wrong with the model. Prefer a packaged SpiceGrinder install's *bundled runtime* if one exists (macOS: `/Applications/SpiceGrinder-Pro.app/Contents/runtime/Contents/Home/bin/java` or `SpiceGrinder-Free.app`'s equivalent, or a local build's `dist-platform/jpackage-*/SpiceGrinder-*.app/...`; Windows/Linux installs follow the same jpackage convention under a different root -- search rather than assume a path) -- guaranteed the right version, no detection needed. Otherwise check `java -version` first; if older than 25, look for a newer JDK (macOS: `/usr/libexec/java_home -V`, or common install paths like Homebrew's `/opt/homebrew/opt/openjdk@25/bin/java`) before concluding anything about the model itself.

   **Which jar to run.** A packaged app's bundled jar is a point-in-time snapshot and can be *stale* relative to an active dev checkout (confirmed directly once already -- a `dist-platform/jpackage-pro` build sat 3 days behind a same-day `target/` rebuild, which would have silently reintroduced an already-fixed bug). Compare modification times between `target/spicegrinder-*.jar` (prefer a `-pro.jar` if present, else the plain jar) and the packaged app's own `Contents/app/spicegrinder-*.jar`, and use whichever is actually newer.

   Then run (see `docs/ModelAnalyzerApp.md` for the full CLI reference):
   ```
   <chosen java binary> -cp <chosen jar> com.obsvra.spicegrinder.tools.ModelAnalyzerApp --no-write <model file>
   ```
   `--no-write` keeps this a read-only report -- don't embed `analysis.*` attributes into the user's file as a side effect of a performance *review*.

3) Look for inefficient model structure that can be replaced by an equivalent structures that are more efficient.

4) Identify any nodes in the model that are performance bottlenecks (either directly or as a result of the node's sub-tree).

## Output Format

Indicate which (if any) components of a model are potential performance bottlenecks and offer any suggestions for performance improvement that can be determined.
