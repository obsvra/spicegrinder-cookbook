![spicegrinder-icon](assets/spicegrinder-icon.png)
# Model File Format Reference

See [Component-Library-Reference.md](Component-Library-Reference.md) for the full component/parameter list.

## Formats

Two interchangeable formats, same structure: **XML** and **JSON**. `ModelLoader` auto-detects format by content on load; save picks the format explicitly (GUI: Save dialog format selector; CLI: file extension).

## Top-level structure

| Field | XML | JSON | Required | Notes |
|---|---|---|---|---|
| Root pointer | `<root node="Name"/>` | `"root": "Name"` | yes | Name of the node that is the model's output |
| Seed | `<dataset seed="123">` | `"seed": 123` | no | Omitted/`<= 0` = no fixed seed (platform default RNG) |
| Custom type defs | `<definitions><custom .../></definitions>` | `"definitions": [...]` | no | Pro only — see below |
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

## Dimension

Every node has a **dimension** — the number of `DataPoint` objects per `Observation` it emits. Filters like `Redimension`/`Drop`/`Append` change dimension explicitly; most generators are fixed-dimension (often 1, multivariate ones like `MultivariateNormal`/`Dirichlet`/`Wishart` are k-dimensional based on their own parameters).

## Validation

`ModelValidator`/`IGenerator.validate()` runs structural checks (e.g. `Mix` needs 2+ inputs, `Truncate` needs sane bounds) — surfaced through Save/Save-Subtree/XML-view error handling in the GUI, or the standalone `ModelValidatorApp` CLI launcher.
