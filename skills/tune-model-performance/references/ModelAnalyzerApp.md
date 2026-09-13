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

Multiple files may be given on one invocation; each is analyzed independently.

Edition comes from the artifact (`LicenseBuildEdition`) by default, same as `Grind`. `--pro`/`--free` exist to test the *other* edition's policy on a build where the classes are still physically present — not the normal way to select an edition.

## OPTIONS

| Option | Meaning |
|---|---|
| `--no-throughput` | Skip observation sampling — static analysis only. |
| `--samples N` | Observations to sample for throughput (default 5000). |
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
| `--version` | Print the version (e.g. `1.0.0 Alpha 1 (Build 1)`) and exit. |
| `--json` | Emit one JSON report to stdout instead of human-readable text. See OUTPUT (JSON) below. |

## ISOLATED BENCHMARK

`--isolate` runs `NodeBenchmarkHarness`, timing every component individually and deriving each one's own cost. The stdout report and the embedded `analysis.*` attributes stay compact (multiplier/confidence only) regardless of `--isolate-raw`. The full raw per-node components — subtree cost, weights, per-round samples, intended for collecting data across environments/model complexities to tune the costing methodology itself — are only surfaced via `--isolate-raw`, and only when the diagnostic stream is actually enabled. The safe
default stays safe; the extended data is opt-in.

## EMBEDDED ATTRIBUTES

Written onto the model's dataset attributes unless `--no-write` is given. Prior `analysis.*` keys are replaced on each run.

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
