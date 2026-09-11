![spicegrinder-icon](assets/spicegrinder-icon.png)

# ModelAnalyzerApp(1)

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

Edition comes from the artifact (`LicenseBuildEdition`) by default, same as `ModelRunner`. `--pro`/`--free` exist to test the *other* edition's policy on a build where the classes are still physically present — not the normal way to select an edition.

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

## SEE ALSO

`ModelRunner`(1), `ModelValidatorApp`(1)
