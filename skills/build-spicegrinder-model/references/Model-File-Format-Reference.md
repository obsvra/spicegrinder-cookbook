![spicegrinder-icon](assets/spicegrinder-icon.png)
# Model File Format Reference

> © 2026 Obsvra. This document describes SpiceGrinder and is provided to help you evaluate and use it. It is not a license to reproduce, adapt, or use this material to build a competing product or service. Full terms: the SpiceGrinder EULA.

See [Component-Library-Reference.md](Component-Library-Reference.md) for the full component/parameter list.

## Formats

Three interchangeable formats, same underlying structure: **XML**, **JSON**, and a dense, hand-authoring-friendly **compact format** (`.sgm` — see [Same model, compact format](#same-model-compact-format-sgm) below). `ModelLoader` auto-detects format by content or extension on load; save picks the format explicitly by file extension — the GUI's Open/Save dialogs, and any other caller that writes to a `.sgm`-named file (a CLI tool, or a direct `ModelIO.write()` call), all produce real compact-format output.

## Top-level structure

| Field | XML | JSON | Required | Notes |
|---|---|---|---|---|
| Root pointer | `<root node="Name"/>` | `"root": "Name"` | yes | Name of the node that is the model's output |
| Seed | `<dataset seed="123">` | `"seed": 123` | no | Omitted/`<= 0` = no fixed seed (platform default RNG) |
| Random override | `<dataset random="com.example.MyRNG">` | `"random": "com.example.MyRNG"` | no | Classpath class implementing `IRandom`, replacing the built-in default. Requires Pro unless the class is in `core.defaults` (the built-in default itself) — see below |
| Custom type defs | `<definitions><custom .../></definitions>` | `"definitions": [...]` | no | Pro only — see below |
| Declared parameters | `<definitions><declare .../></definitions>` | `"declarations": [...]` | no | Pro only — see below |
| Node list | `<nodes>...</nodes>` | `"nodes": [...]` | yes | Flat list, not nested |

## Node spec fields

| Field | Meaning |
|---|---|
| `type` | Component short name (e.g. `Normal`, `Mix`) — matches [Component-Library-Reference.md](Component-Library-Reference.md), or a `definitions`-registered custom type name |
| `name` | Unique identifier for this node, referenced by other nodes' `input` entries |
| attributes | Component-specific parameters (see per-component tables in the library reference) |
| `input` entries | For filters only — references to other nodes by `name`, in order; some filters accept per-input attributes (e.g. `weight`, `role`) |

Node category is implicit in whether a component has inputs: **generators** are leaves (no inputs); **filters** take one or more `input` entries.

**Unidirectional tree:** a node may be referenced as an `input` by only one other node, total, across the whole model — not twice by the same filter, and not once each by two different filters. `ModelValidator` rejects any model that violates this (Save, XML view, and the standalone `ModelValidatorApp` CLI all run it). This isn't just a naming rule: nothing shares state between consumers — a filter pulls its input by calling `getNextObservation()` on it directly, so a node referenced twice would silently be drawn/advanced twice per top-level observation, not shared, if the loader didn't catch it. Reuse the same sub-model by wiring it once and building the shared portion into that one path rather than fanning one node out to two consumers.

## Parameter aliases

Many parameters accept alternate attribute names ("aliases") alongside their canonical name — e.g. `Database`'s `user` also accepts `username`; `Weibull`'s `scale` also accepts `lambda`/`theta`. Aliases are documented per-parameter in [Component-Library-Reference.md](Component-Library-Reference.md).

**Tag precedence:** if a tag supplies both a parameter's canonical name and one of its aliases, **the canonical name always wins**, regardless of which attribute appears first in the tag. `<Database user="a" username="b"/>` and `<Database username="b" user="a"/>`
both resolve to `user="a"` — order-independent, canonical-always-wins. Alias matching is also case-insensitive throughout (`User`/`user`/`USER` are the same key).

This is implemented once, centrally, in `ReflectiveConfigurer` (used by every `@Parameter`-annotated field across every generator/filter), not re-implemented per component. A handful of components with genuinely custom parsing (dynamic type dispatch, richer value syntax, mode-branching logic) apply the same rule by hand instead of going through `ReflectiveConfigurer`, for the same observable result.

**A parameter's declared aliases must never collide with each other or with its own canonical name** (case-insensitively) — this is a convention, not something the loader enforces, so two fields declaring the same alias would make one of them permanently unreachable.

## Free-tier limit

20 nodes per model (`Edition.FREE_NODE_LIMIT`). Pro: unlimited.

## Minimal example (XML)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<dataset>
	<root node="SixStats"/>
	<nodes>
		<Uniform name="Die" min="1" max="7"/>

		<ToInteger name="D6" mode="floor">
			<input name="Die"/>
		</ToInteger>

		<Redimension name="ThreeDice" dimension="3">
			<input name="D6"/>
		</Redimension>

		<Calculate name="Sum" expression="y[0] = x[0] + x[1] + x[2]">
			<input name="ThreeDice"/>
		</Calculate>

		<Drop name="DropCopies" excludes="1,2">
			<input name="Sum"/>
		</Drop>

		<Redimension name="SixStats" dimension="6">
			<input name="DropCopies"/>
		</Redimension>
	</nodes>
</dataset>
```

## Same model, JSON

```json
{
  "dataset": {
    "root": "SixStats",
    "nodes": [
      {"type": "Uniform", "name": "Die", "attributes": {"max": "7", "min": "1"}},
      {"type": "ToInteger", "name": "D6", "attributes": {"mode": "floor"},
        "inputs": [{"name": "Die"}]},
      {"type": "Redimension", "name": "ThreeDice", "attributes": {"dimension": "3"},
        "inputs": [{"name": "D6"}]},
      {"type": "Calculate", "name": "Sum",
        "attributes": {"expression": "y[0] = x[0] + x[1] + x[2]"},
        "inputs": [{"name": "ThreeDice"}]},
      {"type": "Drop", "name": "DropCopies", "attributes": {"excludes": "1,2"},
        "inputs": [{"name": "Sum"}]},
      {"type": "Redimension", "name": "SixStats", "attributes": {"dimension": "6"},
        "inputs": [{"name": "DropCopies"}]}
    ]
  }
}
```

## Same model, compact format (.sgm)

A third, denser syntax for the exact same model — one line per node, positional arguments where a component's parameters allow it, `#` comments. Meant for hand-authoring and quick iteration (sketch a model, glance at it, tweak a value) — the GUI can open and save `.sgm` files like any other format.

```
dataset.root = SixStats

Die = Uniform(1, 7)
D6 = ToInteger(Die, "floor")
ThreeDice = Redimension(D6, 3)
Sum = Calculate(ThreeDice, "y[0] = x[0] + x[1] + x[2]")
DropCopies = Drop(Sum, (1, 2))
SixStats = Redimension(DropCopies, 6)
```

Key rules:
- `NodeName = Component(args)` is a node assignment. A filter's input is always its first argument (`ToInteger(Die, "floor")`); a component's other parameters follow, positionally where possible — each component's parameters have a defined order (matching their order in [Component-Library-Reference.md](Component-Library-Reference.md)) — or by `name=value` once one argument in the call is named, the same positional-then-keyword rule Python uses for function calls.
- `dataset.seed = 123` / `dataset.root = Name` / `dataset.random = com.example.MyRNG` replace XML's `<dataset seed="..." random="...">` / `<root node="...">` (see [Random number generator override](#random-number-generator-override-pro--dynamic-extension) above).
- Array/matrix-typed parameters use a tuple literal instead of a delimited string: `means=(72, 118, 98)` for a vector, `covariance=((144, 67.2), (67.2, 64))` for a matrix — the same values a `"144,67.2;67.2,64"`-style quoted string holds in XML/JSON, just structured instead of flattened.
- `# comment` — a comment line, start-of-line only (no trailing end-of-line comments).
- `define.declare`/`define.custom` and `Import` map onto `<declare>`/`<custom>` and `<Import>` (see [Parameterized sub-models](#parameterized-sub-models-pro--declare--import-overrides) and [Custom type definitions](#custom-type-definitions-pro--dynamic-extension) above) with identical semantics and identical Pro licensing — nothing about using this format changes what's Free vs. Pro:

  ```
  define.declare hrMean = "72"
  define.declare hrStdDev = "8"

  Normal = Import("vitals.xml", hrMean="140", hrStdDev="15")
  ```

## Per-input attributes (weight / role)

Some filters read extra attributes on individual `input` entries, not just the node's own attributes. `Mix` uses `weight`; `Perturb`/`PersonAssembler` use `role`.

```xml
<Mix name="GenderBranch">
	<input name="MaleBranch" weight="0.5"/>
	<input name="FemaleBranch" weight="0.5"/>
</Mix>
```

```xml
<PersonAssembler name="Person">
	<input name="GenderGiven" role="genderGiven"/>
	<input name="Surname" role="surname"/>
</PersonAssembler>
```

## Collaborate references (Pro)

`collaborate.<role>="TargetNodeName"` — a node-tag attribute (not an `<input>` child) naming another node this component exchanges data with out-of-band, via `ICollaborationTarget`. Distinct from and invisible to the `<Input>` tree: the referenced node is not added as an input, is not subject to the unidirectional single-consumer rule `ModelValidator` enforces for `<input>` edges, and is not visited by `ModelValidator`'s structural checks at all — an unresolvable or non-`ICollaborationTarget` reference fails at the consuming component's own `configure()` time instead, with a descriptive exception (same as any other named-reference resolution in this codebase). Zero-to-many named roles are supported per node.

```xml
<CollaborationWatcher name="Watcher" collaborate.primary="BeaconA" collaborate.secondary="BeaconB">
	<input name="Source"/>
</CollaborationWatcher>
<Constant name="Source" value="1" type="double"/>

<CollaborationBeacon name="BeaconA" initial="100"/>
<CollaborationBeacon name="BeaconB" initial="500"/>
```

## Custom type definitions (Pro — dynamic extension)

Registers a fully-qualified Java class under a short tag name usable as a node `type`, without it being one of the built-in registered components. Requires Pro (`LicenseFeatures.requireDynamicExtension`).

```xml
<definitions>
	<custom name="MyType" class="com.example.MyGeneratorClass"/>
</definitions>
```

## Random number generator override (Pro — dynamic extension)

Replaces the built-in default RNG for the whole process with a classpath class implementing `IRandom` (`getNextUniform()`, `getNextUniform(min, max)`, `getNextUniformInt(min, max)`, `getNextNormal()`, `getNextNormal(mean, sigma)`). Same caveats as `<custom>` above: the class must be on the classpath, and naming a class outside a recognized free package requires Pro — naming `com.obsvra.spicegrinder.core.defaults.Random` itself (the built-in default) is the one exception, since it's not really an extension at all.

```xml
<dataset random="com.example.MyRNG">
```
```json
{"dataset": {"random": "com.example.MyRNG", ...}}
```
```
dataset.random = com.example.MyRNG
```

The class needs a no-arg constructor for unseeded use, and (if the model also sets a seed) a `(long seed)` constructor — naming a class with no `(long)` constructor alongside a `seed` is a load-time error, not a silent unseeded fallback, since the seed request can't otherwise be honored.

## Parameterized sub-models (Pro — declare + Import overrides)

`<declare name="foo" value="bar"/>` inside `<definitions>` registers a named default value. Anywhere in `<nodes>` — a node attribute, an `<input>` attribute, or a child-element's text — a value that is *exactly* `$foo` (the whole attribute value, not part of a larger string) resolves to `bar` at load time. This turns a library file into a reusable, parameterized sub-model instead of a fixed one: import it as-is for the defaults, or override specific declared values per call site without duplicating the file.

`<Import>` accepts arbitrary extra key/value attributes beyond its required `file` (and optional `name`/`prefix`) — each overrides the matching `<declare>` in the imported file for that one import. An override key with no matching `<declare>` in the target file is a load-time error, same as an unresolved `$foo` reference — both are meant to catch a typo immediately rather than silently doing nothing.

```xml
<!-- vitals.xml — a shared library with declared, overridable defaults -->
<definitions>
	<declare name="hrMean" value="72"/>
	<declare name="hrStdDev" value="8"/>
</definitions>
<nodes>
	<Normal name="HeartRate" mean="$hrMean" stddev="$hrStdDev"/>
	<!-- ... blood pressure, temperature, etc. ... -->
</nodes>
```

```xml
<!-- normal vitals: defaults as declared -->
<Import name="Normal" file="vitals.xml"/>

<!-- abnormal vitals: override just what needs to shift -->
<Import name="Tachycardic" file="vitals.xml" hrMean="140" hrStdDev="15"/>
```

A `<declare>`'s own `value` is always a literal — it is never itself re-substituted, so `<declare name="x" value="$y"/>` is rejected at load time rather than silently landing `"$y"` as `x`'s literal value. Chaining a value through multiple levels of nested imports still works, just expressed as forwarded overrides instead of declare-to-declare references: an outer file's `<Import file="middle.xml" someParam="$myDeclare"/>` resolves `$myDeclare` from the outer file's own scope before handing the literal down, and if `middle.xml` in turn has its own `<Import file="inner.xml" innerParam="$someParam"/>`, that resolves from `middle.xml`'s scope (including whatever it was just handed) the same way.

## Dimension

Every node has a **dimension** — the number of `DataPoint` objects per `Observation` it emits. Filters like `Redimension`/`Drop`/`Append` change dimension explicitly; most generators are fixed-dimension (often 1, multivariate ones like `MultivariateNormal`/`Dirichlet`/`Wishart` are k-dimensional based on their own parameters).

## Validation

`ModelValidator`/`IGenerator.validate()` runs structural checks (e.g. `Mix` needs 2+ inputs, `Truncate` needs sane bounds) — surfaced through Save/Save-Subtree/XML-view error handling in the GUI, or the standalone `ModelValidatorApp` CLI launcher.
