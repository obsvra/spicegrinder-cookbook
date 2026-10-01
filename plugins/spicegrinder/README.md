# SpiceGrinder skills

Six skills for working with [SpiceGrinder](https://obsvra.com), Obsvra's local, deterministic synthetic-data engine. SpiceGrinder turns a plain-text model (XML, JSON or the compact `.sgm` format) into as many rows of realistic fake data as you want, and the same model with the same seed gives the same rows on any machine. These skills help Claude write, read and check those models, grounded in SpiceGrinder's real component catalog instead of guessing at components that don't exist.

## The skills

| Skill | Use it to | Needs SpiceGrinder installed? |
|---|---|---|
| `build-spicegrinder-model` | Turn a description of the data you need into a model file | No. Without an install the model is an unvalidated draft, and the skill says so and tells you how to validate it |
| `explain-model` | Get a plain-language explanation of what a model produces | No |
| `pii-audit` | Check a model for personal-data risk, such as business objects left on real-looking values | No |
| `fit-model-to-sample` | Turn a sample of real data (a CSV export, say) into a matching model | For the final check only. The fitting is done from the data and the catalog; the `compare` check against your sample needs SpiceGrinder, and without it the skill says the fit is unchecked |
| `tune-model-performance` | Review a model's cost and find its bottleneck nodes | Yes, to measure. Without an install it gives a structural review clearly labeled as unmeasured and never quotes a number it didn't measure |
| `extend-spicegrinder` | Write custom generators, filters and business objects in Java | Pro, for custom components. The cost check needs an install; without one the skill says the component hasn't been profiled |

Each skill carries a snapshot of the documentation it needs (`references/`) so it works without an install. The snapshot is a point in time, and the skills say so when they fall back to it. SpiceGrinder Free is a free download at <https://obsvra.com/get-spicegrinder>; Free models are limited to 20 nodes and numeric output, and a few components are Pro-only. The skills tell you which tier a component needs.

## Install

In Claude Code:

```
/plugin marketplace add obsvra/spicegrinder-cookbook
/plugin install spicegrinder@spicegrinder
```

Or add it from the Claude directory once it is listed. Then ask Claude, for example, "build a SpiceGrinder model for insurance claims" or "audit this model for PII"; it picks the matching skill.

## What this plugin does with your data

Nothing leaves your machine because of this plugin. It contains instructions and reference documents only: no hooks, no scripts, no MCP servers and no network calls of its own. When a skill runs the SpiceGrinder tools (`validator`, `analyzer`, `compare`, `grind`) it runs them locally, in your session and under your permissions, on the files you point it at. SpiceGrinder itself collects no telemetry; see <https://obsvra.com/security> for what it does and doesn't do with data. The `pii-audit` and `fit-model-to-sample` skills read the model or the sample you give them and nothing else. `fit-model-to-sample` fits distributions to your sample's columns, and the skills are written never to copy identifying values (names, SSNs, emails) from a sample into a model.

## License

The skills, this README and the manifest are MIT-licensed ([LICENSE](LICENSE)). The documentation snapshots under `skills/*/references/` are SpiceGrinder product documentation, © Obsvra, and are not covered by the MIT license; see [NOTICE.md](NOTICE.md).

Questions or problems: [support@obsvra.com](mailto:support@obsvra.com).
