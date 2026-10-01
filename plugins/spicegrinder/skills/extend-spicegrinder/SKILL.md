---
name: extend-spicegrinder
description: Helps write, edit, or debug custom SpiceGrinder generators, filters, and business objects -- the IGenerator/IFilter interfaces, @ComponentInfo/@Parameter annotations, and the Create() factory pattern used throughout this codebase. Use this skill whenever the user wants to add a new custom component, extend or modify an existing custom generator/filter, asks about the annotation-based parameter system, wants their component to show up correctly in the GUI's property panel, or is debugging why a custom component isn't loading, registering, or behaving as expected -- even if they don't say "extend" or "custom component" explicitly (e.g. "how do I make my own distribution", "why isn't my filter showing up in the editor").
---

# Extend SpiceGrinder

## Overview

A user asks for assistance in writing or editing custom SpiceGrinder components. This is a Pro-only capability -- direct construction and custom-component registration both require a licensed Pro build (`ComponentFactory` is Pro-only per `docs/Customization.md`) -- and it's meant for people extending *their own* use of SpiceGrinder as a library, in *their own* project, not for modifying SpiceGrinder's own source tree.

## When to Use

On user request or when the user is working on custom SpiceGrinder extensions.

## Instructions

0) **Confirm Pro access before proceeding.** If the user hasn't confirmed they're on a Pro build, say so explicitly -- custom component authoring doesn't work on Free at all, so there's no Free-tier fallback to offer here the way other skills default to one.

1) **Ground yourself in the real component catalog before writing anything.** Read `docs/Component-Library-Reference.md` from the user's SpiceGrinder repo checkout (check your memory for the configured default location first) for the authoritative, auto-generated list of every existing generator, filter, and business object -- a new custom component should fit alongside these, not duplicate or contradict something that already exists. If that repo can't be found at the expected path, ask the user where their checkout lives before falling back to the bundled snapshot at `references/component-catalog.md` -- and if you do fall back to it, tell the user explicitly that it's a point-in-time copy and may be missing components added since. If no SpiceGrinder installation can be found at all -- no repo checkout, no packaged app, nothing on the classpath to compile or run against -- stop and point the user to https://obsvra.com/get-spicegrinder; unlike the docs-only fallback above, there's no bundled substitute for actually compiling and running a custom component, so this skill can't be completed without a real install.

2) **Refer to the Customization documentation.** Read `docs/Customization.md` from the user's SpiceGrinder repo checkout (check your memory for the configured default location first) for the real IGenerator/IFilter contract, the @ComponentInfo/@Parameter annotation system, the Create() factory pattern, and how custom components get registered and discovered. If that repo can't be found at the expected path, fall back to the bundled snapshot at `references/Customization.md`.

3) Use the provided samples as a pattern for how to write the classes. Annotate classes and parameters to be exposed so that the Model Editor can properly display them. **New components must live in the user's own package namespace** (e.g. `com.example.myproject.generators.MyThing`), never under `com.obsvra.spicegrinder.*` -- that namespace is reserved for SpiceGrinder's own built-in components and is explicitly not writable by custom code (enforced even in dev mode, per `docs/Organization-config.md`). A generated class that lands in `com.obsvra.spicegrinder.*` is wrong regardless of how correct its logic is.

4) **Refer to the Model Analyzer documentation for a cost check.** Read `docs/ModelAnalyzerApp.md` from the user's SpiceGrinder repo checkout for SpiceGrinder's performance profiling process and what the results mean. If that repo can't be found at the expected path, fall back to the bundled snapshot at `references/ModelAnalyzerApp.md`. Run it for real against a model that exercises the new custom component (`--isolate --isolate-raw` per `docs/Customization.md`'s own guidance for profiling a specific component). If the cost seems comparatively high in relation to other components, look at optimization techniques.

   If no SpiceGrinder install or jar can be found, skip the run rather than estimating: say that the new component hasn't been profiled, and give the user the command below to run once SpiceGrinder is installed. Don't guess a cost for it.

   This needs the user's own compiled custom-component classes on the classpath alongside SpiceGrinder's, which rules out the bundled `jpackage` launcher binaries directly (their classpath is fixed to just the SpiceGrinder jar, per `Contents/app/analyzer.cfg` in the app bundle). Instead, get the JDK-version safety of the bundled runtime without its fixed classpath: use the **bundled runtime's own `java` binary** with an explicit combined `-cp` (macOS: `/Applications/SpiceGrinder Pro.app/Contents/Resources/cli/Contents/runtime/Contents/Home/bin/java` inside the installed desktop app (or `SpiceGrinder Free.app`), or the command-line package's `SpiceGrinder-Pro.app/Contents/runtime/Contents/Home/bin/java` wherever it was unzipped, or a local build's `dist-platform/jpackage-*/SpiceGrinder-*.app/Contents/runtime/Contents/Home/bin/java`). **Only if no packaged app can be found**, fall back to a system `java` -- this project targets JDK 25 (`maven.compiler.release` in `pom.xml`), so check `java -version` first and look for a newer JDK (macOS: `/usr/libexec/java_home -V`, or paths like Homebrew's `/opt/homebrew/opt/openjdk@25/bin/java`) before assuming a failure here is about the component's own code.

   The SpiceGrinder jar itself has the same freshness caveat as the JDK question doesn't: a packaged app's bundled `Contents/app/spicegrinder-*.jar` is a point-in-time snapshot and can be *stale* relative to an active dev checkout of the SpiceGrinder repo itself. If a SpiceGrinder repo checkout with a `target/spicegrinder-*.jar` exists alongside the packaged app, compare modification times and use whichever is newer -- otherwise the packaged app's bundled jar is the only option and that's fine, it's the norm for this skill's actual audience (extending SpiceGrinder as a dependency in their own project, not working inside the SpiceGrinder repo itself).
   ```
   <chosen java binary> -cp <chosen spicegrinder jar>:<user-custom-classes> com.obsvra.spicegrinder.tools.ModelAnalyzerApp --isolate --isolate-raw --diagnostic --no-write <model file>
   ```
   (use `;` instead of `:` between classpath entries on Windows).

## Output Format

Developed classes, test files, and any related resources should be output to the appropriate places in **the user's own project** -- this skill is for people building against SpiceGrinder as a library from their own codebase, not for modifying SpiceGrinder's own source tree. Never write into the SpiceGrinder repo's own `com.obsvra.spicegrinder.*` source directories.