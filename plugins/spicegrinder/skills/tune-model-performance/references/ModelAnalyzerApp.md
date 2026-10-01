![spicegrinder-icon](assets/spicegrinder-icon.png)

# ModelAnalyzerApp(1)

> © 2026 Obsvra. This document describes SpiceGrinder and is provided to help you evaluate and use it. It is not a license to reproduce, adapt, or use this material to build a competing product or service. Full terms: the SpiceGrinder EULA.

## NAME

ModelAnalyzerApp — standalone Model Analyzer: static complexity plus optional throughput and per-component benchmarking

## SYNOPSIS

```
java -cp spicegrinder.jar com.obsvra.spicegrinder.tools.ModelAnalyzerApp [options] model.xml|model.json ...
```

On a jpackage install:

```
analyzer [options] model.xml|model.json ...
```

## DESCRIPTION

For each model file given, `ModelAnalyzerApp`:

1. Loads the model (XML or JSON) via `ModelLoader`.
2. Computes static complexity (`ModelComplexityAnalyzer`).
3. By default, also runs a throughput sample (a warmup pass, then `--samples` observations timed for real).
4. Prints a report to **stdout**.
5. By default, embeds the results back onto the model file's dataset attributes (see EMBEDDED ATTRIBUTES), including `analysis.timestamp` — `--no-write` skips this.

Multiple files may be given on one invocation; each is analyzed independently. One of them may be `-` instead of a path, meaning "read this model from stdin" (used once per invocation, not repeated) — content-sniffed as XML or JSON, matching `Grind`/`ModelValidatorApp`; Compact (`.sgm`) needs a real file. Reading from stdin without `--no-write` is rejected (exit 2) rather than silently downgraded: writing results back is the default, and there is no file for stdin to write them onto. Pass `--no-write` explicitly when analyzing a model from stdin.

Edition comes from the artifact (`LicenseBuildEdition`) by default, same as `Grind`. `--pro`/`--free` exist to test the *other* edition's policy on a build where the classes are still physically present — not the normal way to select an edition.

## OPTIONS

| Option | Meaning |
|---|---|
| `--no-throughput` | Skip observation sampling — static analysis only. |
| `--samples N` | Observations to sample for throughput (default 5000). |
| `--warmup-ms N` | Generate for N milliseconds, untimed, before the throughput sample, so the JVM has finished optimizing the model's code (default 0). A fresh JVM takes a few seconds to reach full speed on a heavy model; without a warm-up the throughput shown can be several times slower than steady state. |
| `--no-write` | Print the report only; do not update the model file. |
| `--pro` | Force Pro edition policy for this run (testing; no-op on a Free artifact). |
| `--free` | Force Free edition policy for this run (testing), even on a Pro artifact. |
| `--isolate` | Also run the per-component isolated benchmark (see ISOLATED BENCHMARK). Opt-in — many more generator calls than `--samples` alone. |
| `--isolate-rounds N` | Interleaved measurement rounds for `--isolate` (default 10). |
| `--isolate-iterations N` | Measured calls per node per round for `--isolate` (default 50). |
| `--isolate-warmup-rounds N` | Discarded warmup rounds for `--isolate` (default 3). |
| `--isolate-threshold X` | "Problem node" relative-multiplier cutoff for `--isolate` (default 3.0). |
| `--isolate-raw` | Log raw per-node benchmark components via the diagnostic instrumentation stream. Needs `--diagnostic` (or the stream already enabled via persisted config) to actually produce output. No effect without `--isolate`. |
| `--diagnostic` | Enable the diagnostic instrumentation stream for this run. |
| `-h`, `--help` | Print usage and exit. |
| `--version` | Print the version (e.g. `1.0.0 Beta 2 (Build 1)`) and exit. |
| `--json` | Emit one JSON report to stdout instead of human-readable text. See OUTPUT (JSON) below. |

## HOW FAR TO TRUST THE COMPLEXITY SCORE

The score weighs each component by a cost measured on 11 machines of different sizes and makers (Intel and AMD x64, AWS Graviton and Apple Silicon ARM), 2026-09-26. Across 66 sample models it tracks real generation speed closely: on each machine, the score explains 96% to 99% of the difference in speed between models (R² 0.96-0.99), slightly better on x64 than on ARM. It measures generation only: writing the rows out (formatting, streaming, files) adds a cost per row that the score leaves out on purpose, since it depends on where the rows go, not on the model.

**ARM and x64 differ for some components, and the weights don't adjust for it yet.** Components that lean on `pow`, `log` and `exp` cost relatively more on ARM, and a few cost relatively less. Relative to other work, on ARM:
- `Pareto` costs about 2.5x as much as on x64, and `Weibull` about 1.9x, on both Graviton and Apple Silicon.
- `Lognormal` and the FHIR renderers cost about 1.9x as much on Graviton, but only about 1.0-1.3x on Apple Silicon: ARM chips aren't all alike either.
- `Mix` and `Triangular` cost about 0.6x as much.

So on ARM the score can underrate a model dominated by `Pareto` or `Weibull` and overrate one dominated by `Mix`. We've measured only three ARM machines (two sizes of one Graviton chip and one Mac), which isn't enough variety to build separate ARM weights we'd trust. We'll revisit it as we measure more. If the score matters for your own hardware, you can measure it and override any weight (see Customization, "component weights").

## ISOLATED BENCHMARK

`--isolate` runs `NodeBenchmarkHarness`, timing every component individually and deriving each one's own cost. The stdout report and the embedded `analysis.*` attributes stay compact (multiplier/confidence only) regardless of `--isolate-raw`. The full raw per-node components — subtree cost, weights, per-round samples, intended for collecting data across environments/model complexities to tune the costing methodology itself — are only surfaced via `--isolate-raw`, and only when the diagnostic stream is actually enabled. The safe
default stays safe; the extended data is opt-in.

## EMBEDDED ATTRIBUTES

Written onto the model's dataset attributes unless `--no-write` is given: on `<dataset>` in XML, as keys of the `dataset` object in JSON, as `analysis.<key> = <value>` lines in compact (`.sgm`). Prior `analysis.*` keys are replaced on each run, in place, and nothing else in the file changes: comments anywhere, attribute and key order, indentation, quoting and line endings stay exactly as written. New keys go where the old ones were; on a first run they go after the other `<dataset>` attributes (XML, on their own lines when the tag is already one attribute per line or would pass 100 columns), before `root` (JSON), or before the first node (compact). They're written in the order of the table below. The edited file is re-read and checked to be the same model with only `analysis.*` changed before it's saved; if it isn't, the file is left alone and the run fails for that file.

| Attribute | Meaning |
|-----------|---------|
| `analysis.version` | Schema version of the analysis block |
| `analysis.timestamp` | ISO-8601 time of this run (staleness check) |
| `analysis.mode` | `FULLY_COMPUTED` or `PARTIAL` |
| `analysis.node_count` | Nodes in the generator tree |
| `analysis.min_depth` / `max_depth` | Tree depth range |
| `analysis.predicted_avg_depth` | Mix-weighted expected depth when fully computed |
| `analysis.score` | Composite complexity score |
| `analysis.custom_component_count` | Non-core components |
| `analysis.obs_per_sec` | Measured throughput (if sampled) |
| `analysis.sample_count` / `sample_duration_ms` | Sample details |
| `analysis.summary` | Short human-readable line |

## OUTPUT (JSON)

With `--json`, every file given is analyzed exactly the same way, but the results are collected into one JSON document printed to stdout instead of per-file human-readable text:

```json
{
  "success": true,
  "results": [
    {
      "model": "/abs/path/model.xml",
      "rootName": "root",
      "timestamp": "2026-08-28T12:00:00Z",
      "complexity": {
        "mode": "FULLY_COMPUTED", "nodeCount": 12, "minDepth": 1, "maxDepth": 4,
        "predictedAverageDepth": 2.5, "score": 340,
        "customComponentCount": 0, "customComponentNames": [], "summary": "..."
      },
      "throughput": {"sampleCount": 5000, "sampleDurationMs": 812, "observationsPerSecond": 6157.0},
      "isolatedBenchmark": null,
      "written": true,
      "error": null
    }
  ]
}
```

`results[]` has one entry per file given, in order. `throughput` is `null` when `--no-throughput` was given. `isolatedBenchmark` is `null` unless `--isolate` was given, in which case it's a compact summary — `measuredAverageDepth`, `baselineNanosPerCall`, `problemNodeCount`, and a `problemNodes[]` array (`label`, `className`, `core`, `confidence`, `relativeMultiplier`) — mirroring the same compact section the stdout report shows; the full raw per-node components are still `--isolate-raw`-only, via the diagnostic stream, exactly as without `--json`. A file that fails to load or analyze gets a leaner entry instead: `{"model": "...", "error": "<message>"}`, with top-level `success` set to `false`.

`--json` only changes this payload — the diagnostic-stream logging `--isolate-raw` triggers still happens the same way, and embedded `analysis.*` attributes are still written unless `--no-write` is given. `-h`/`--help`/`--version` output and bad-argument errors (exit code 2) always stay plain text, unaffected by `--json`.

## EXIT STATUS

| Code | Meaning |
|---|---|
| 0 | Every file given was analyzed successfully. |
| 1 | At least one file was not a file, or failed to load/analyze. |
| 2 | Bad arguments — missing required value, unrecognized option, or no files given. |

## EXAMPLES

Analyze one model, static + throughput, embed results:

```
java -cp spicegrinder.jar com.obsvra.spicegrinder.tools.ModelAnalyzerApp model.xml
```

Static-only, print but don't modify the file:

```
analyzer --no-throughput --no-write model.json
```

Full isolated per-component benchmark with raw diagnostic output:

```
analyzer --isolate --isolate-raw --diagnostic model.xml
```

Get a machine-readable report for a script or agent to parse:

```
analyzer --json --no-write model.xml
```

## SEE ALSO

`Grind`(1), `ModelValidatorApp`(1), `ComponentLibraryApp`(1), `McpServerApp`(1)
