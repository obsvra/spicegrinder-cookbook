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
| Seed | `<dataset seed="123">` | `"seed": 123` | no | Omitted/`<= 0` = no fixed seed (platform default RNG). What a seed does and doesn't guarantee: [Determinism and reproducibility](Determinism.md) |
| Random override | `<dataset random="com.example.MyRNG">` | `"random": "com.example.MyRNG"` | no | Classpath class implementing `IRandom`, replacing the built-in default. Requires Pro unless the class is in `core.defaults` (the built-in default itself) — see below |
| Random streams | `<dataset streams="per-node">` | `"streams": "per-node"` | no | `per-node` (default): each node draws from its own stream, derived from the seed and the node's name. `shared`: all nodes share one stream in pull order, as in Beta releases. See [Random streams](#random-streams) below |
| Notes | `<dataset meta.note="...">` | `"meta.note": "..."` | no | Your own metadata. Any attribute whose name starts with `meta.` is kept and never interpreted. In the compact format: `meta.note = "..."` |
| Custom type defs | `<definitions><custom .../></definitions>` | `"definitions": [...]` | no | Pro only — see below |
| Declared parameters | `<definitions><declare .../></definitions>` | `"declarations": [...]` | no | Pro only — see below |
| Node list | `<nodes>...</nodes>` | `"nodes": [...]` | yes | Flat list, not nested |

**Unknown `<dataset>` attributes are a load error.** A `<dataset>` takes `seed`, `random`, `streams`, the `analysis.*` attributes the Model Analyzer writes, and your own `meta.*` notes, and nothing else. A misspelled or unsupported name (`sead`, or an attribute from a later version) fails when the model loads, names the attribute and any close match, and lists what is allowed, instead of being ignored while the model runs on its defaults. The compact format has always worked this way for its `dataset.*` directives.

The `analysis.*` attributes are written by tools, kept when a model is saved, and never affect what a model generates. `meta.*` notes are yours: also kept, also never interpreted. The same list applies to JSON's top-level keys.

## Format stability

From 1.0, every 1.x release loads any model that loads in 1.0, with the same meaning, in **XML and JSON**. New elements, attributes and components may be added; nothing listed here is removed, renamed or reinterpreted.

- **Structure:** the `<dataset>` root; its `seed`, `random` and `streams` attributes, the `analysis.*` and `meta.*` namespaces; `<root node="...">`; `<definitions>` with `<custom>` and `<declare>` (and `$name` substitution of a whole attribute value); the flat `<nodes>` list; a node's component short name (or a fully qualified class name), `name`, attributes and child elements; `<input>` entries, in order, with their per-component attributes; `synchronous`/`sync`; `collaborate.<role>`; and `<Import>` with its overriding attributes. JSON uses the same keys.
- **Rules:** an unknown node attribute is a load error; a canonical parameter name wins over an alias; names are case-insensitive; a node has one consumer in the `<input>` tree. The 20-node Free limit is a licensing rule and is not part of the format promise.
- **Built-in components:** for every component in [Component-Library-Reference.md](Component-Library-Reference.md) at the 1.0 release, its short name, each parameter's canonical name, aliases and `order`, its default value, its documented allowed values, the meaning of its `<input>` attributes and roles, and its output layout (dimension and column order) are frozen. A default is part of the promise because changing it changes the output of every model that relies on it. New parameters are appended with the next `order`. Components marked as examples (`CollaborationBeacon`, `CollaborationWatcher`, `Mixture`) are excluded.
- **Not part of this promise:** output bytes (see [Determinism and reproducibility](Determinism.md)), command-line flags, the Service HTTP API (versioned by its `/v1/` prefix) and the desktop app.
- **Reserved for later 1.x releases:** the node attributes `stream` and `seed`. `Recur`, `Markov`, `SharedState` and `ProcessFlow` are built-in components; avoid their names for custom components.
- **Compact format (`.sgm`):** Experimental, but readable across 1.x as described above.

## Node spec fields

| Field | Meaning |
|---|---|
| `type` | Component short name (e.g. `Normal`, `Mix`) — matches [Component-Library-Reference.md](Component-Library-Reference.md), or a `definitions`-registered custom type name |
| `name` | Unique identifier for this node, referenced by other nodes' `input` entries |
| attributes | Component-specific parameters (see per-component tables in the library reference). A name that matches none of the component's parameters or aliases is an error when the model loads, naming the valid ones and the closest match (`stdev` → did you mean `stddev`?) |
| `input` entries | For filters only — references to other nodes by `name`, in order; some filters accept per-input attributes (e.g. `weight`, `role`), and an unknown one is also a load error |

**Dataset attribute `columns`.** `<dataset columns="stock, lost, expired">` names the root's output columns (letters, digits and `_`, no repeats, as many as the root has columns; checked when the model is loaded). `grind --header` writes the names instead of `dim0,dim1,...`, and the `experiment` tool accepts them in measures. In JSON it is `"columns"`, in the compact format `dataset.columns = "stock, lost, expired"`.

**Attributes every node accepts, and names no component may use:** `name`, `synchronous` (alias `sync`; filters read it themselves and `ModelLoader` applies it to generators), and, on a collaboration consumer, `collaborate.<role>`. The names `stream` and `seed` are reserved for per-node random streams in a later 1.x release; today they are rejected on every built-in component as unknown attributes, and a component that declares a parameter by one of these names (or by a `collaborate.` name) is refused by the registry. A built-in component that has no parameters at all (`ISBN`, `IBAN`, `VIN`, ...) takes no attributes beyond these, so `<ISBN name="x" fo="1"/>` is an error, not silently ignored.

Node category is implicit in whether a component has inputs: **generators** are leaves (no inputs); **filters** take one or more `input` entries.

**Unidirectional tree:** a node may be referenced as an `input` by only one other node, total, across the whole model: not twice by the same filter, and not once each by two different filters. The loader enforces this, so every way of running a model (the desktop app, `Grind`, the Service, the MCP server, the Lambda handler, `compare`) refuses a model that breaks it, with an error that names the node and its consumers (`S [Sequence]: used as an input 2 times (by A, B)`). `ModelValidator` and the standalone `validate` report the same failure. This isn't just a naming rule: nothing shares state between consumers. A filter pulls its input by calling `getNextObservation()` on it directly, so a node with two consumers would be advanced twice per top-level observation, not shared. To reuse the same values in two places, wire the node once and copy the column with `Arrange`, or build the shared portion into that one path.

## How a model runs

This section is the execution contract: what one output row is, and when a model's state moves and its random numbers are drawn.

A node that is finite by nature can end the run: it raises an end of data, every filter above it passes it on, and the driver (`Grind`, the Service, the MCP server) keeps the rows produced and reports that the model ended; it is not an error and nothing is rolled back. **One row is one pull of the root.** Running a model builds every node once, then asks the root node for an observation once per output row. A filter asks its inputs for observations as it needs them, in the order its `<input>` entries are written, all the way down to the generators. Nothing is cached between rows, nothing runs that the root's row doesn't ask for, and there is no begin-row step. The one end-of-row step belongs to `SharedState` (Pro): when a model contains one, it is told after each successful row so it can make that row's writes visible to the next row (see [Shared state](#shared-state-pro)). (`Grind --node NAME` runs the same loop with another node as the root.)

**When state advances.** A node advances each time it is pulled. `Sequence` adds its step, `Recur` computes its next state, `Pool` uses up one of an entity's rows, `Perturb` counts down its current phase, `Redimension` consumes a column of its buffered input, and a random generator draws. Most filters pull each input exactly once per row: `Append`, `Arrange`, `Calculate`, `Recur`, `ToInteger`, and `Truncate` in censor mode. These don't:

| Component | Pulls |
|---|---|
| `Mix` | Only the chosen input. With `synchronous="true"`, also every other input that is itself synchronous, discarding its value. |
| `Switch` | The `role="input"` input, then only the chosen branch. Other branches don't advance. |
| `Pool` | The entity and count inputs only when it opens a new entity. |
| `ProcessFlow` | The `arrival` input once per external arrival and a station's `service` input once per service that starts there: a variable number of pulls per row, none on a row that only moves a customer on. Its routing choices use its own random stream. |
| `Perturb` | The active branch, and the `wait`/`duration` input at each phase change. The first `wait` is read on the first pull, not when the model loads. With `synchronous="true"`, also the inactive branch if it is synchronous. With `mode="add"` (the disturbance is added to the normal value instead of replacing it), the normal input advances on every row, episodes included, and the disturbance advances during an episode. |
| `Truncate` | Its input again until a value is in bounds (truncate mode), so a counter upstream skips the rejected values. |
| `Redimension` | Its input only when it has used up the previous observation's columns. Leftover columns carry into the next row. |
| `Copula` | Never. It uses its inputs' distributions, not their draws. |

A filter that picks between inputs advances only the one it picks, so a `Sequence`, `Recur` or other stateful node under an unchosen branch stands still on those rows. `synchronous="true"` is how a model keeps such a node in step. It is honored on every filter and on `Sequence` and every generator that extends `Generator`, so a synchronous `Sequence` behind a synchronous `Mix` ticks on every row. A filter without an explicit attribute inherits `true` if any of its inputs is synchronous. Of the filters that choose between inputs, `Mix`, `Perturb` and `Address` act on it; `Switch` and `Pool` ignore it.

**Randomness.** A run is seeded by `--seed`, the request's `seed`, or the model's `seed`, in that order. A seed must be 0 or greater: a negative seed, on the command line, in a request or in the model, is an error. A seed of 0 means no seed everywhere: in the model it means no fixed seed, and on the command line or in a request the run draws a fresh seed (and logs it), ignoring the model's own (see [Determinism](Determinism.md)). By default each node draws from its own random stream, derived from the seed and the node's name, and draws in the order the node is pulled. The same model with the same seed produces the same rows. Adding, removing or reordering other nodes doesn't change what a node draws, but a node that is pulled a different number of times does: a `Truncate` that rejects values, or a `Mix` that picks a different branch, changes what nodes under it draw. With `streams="shared"` all nodes share one stream in pull order, so any node that draws a different number of values shifts every later draw. See [Random streams](#random-streams). Loading a model draws nothing.

**Runs and replications.** Every run builds the model fresh, so separate runs never share state. A replication is a run with a different seed. There is no reset: to start a model over, run it again. Through the Service API, a `/generate` or `/stream` call without `seed` or `noSeed` continues the previous call's rows, as if both were one run; a call with `seed` or `noSeed` builds a new graph. A call that fails or is interrupted drops the cached graph, so the next call without a seed starts a new run instead of continuing from rows that nobody received. A client that disconnects from a `/stream` doesn't drop it, and the rows generated but not delivered are skipped over by the next call.

**The end of a run.** A run stops after the last row, and nothing tells the nodes. Anything in progress is cut short: an open `Pool` entity has emitted fewer rows than it drew, a `Perturb` episode ends early, and `Redimension`'s unused columns are dropped. Leave the last partial run or entity out of run-length statistics.

**When a row fails.** If a component can't produce a value (a `Switch` value with no branch, a `Truncate` that runs out of attempts, a `Pool` count below 1, a data source that runs out with `onExhaustion="error"`), the run stops at that row and nothing is rolled back. What you get depends on how you ran it:

| Run | Rows before the failing one | Signal |
|---|---|---|
| `Grind` | Kept: every complete row is written before the error | `ERROR:` on stderr, exit status 1 |
| Service `/generate` | Discarded | HTTP 500 `generation failed: ...` and no rows |
| Service `/stream` | Rows already sent stay sent, but the batch being generated is lost | The stream just ends early with HTTP 200. Compare the rows you received with the `count` you asked for |
| MCP `generate` | Discarded | An error result |

A failed run can't be resumed. Start a new one.

**Collaborate reads.** A `collaborate.<role>` read (see [Collaborate references](#collaborate-references-pro)) happens when the reading node is pulled. It sees the target node as it was after the target's most recent pull. If the target comes earlier in the row's pull order, that is this row's value. If it comes later, it is the previous row's. If the target is never pulled, the read sees its starting state. Some targets change on every read: `FhirIdRegistry` hands out a new id each time. The rules a target and consumer follow are in [Customization, section 9.5](Customization.md#95-collaborating-components-pro).

**Pulls you don't control.** A `ServiceCall` filter lets an external service choose which inputs to pull and in what order, so a model containing one is reproducible only if the service is deterministic for the same sequence of requests. `Date` and `BusinessDay` pull their `year` input again for each rejected candidate, and samplers such as `Poisson` and `Gamma` use a variable number of draws; both are covered by the same pull-order rule.

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

		<Arrange name="KeepSum" columns="0">
			<input name="Sum"/>
		</Arrange>

		<Redimension name="SixStats" dimension="6">
			<input name="KeepSum"/>
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
      {"type": "Arrange", "name": "KeepSum", "attributes": {"columns": "0"},
        "inputs": [{"name": "Sum"}]},
      {"type": "Redimension", "name": "SixStats", "attributes": {"dimension": "6"},
        "inputs": [{"name": "KeepSum"}]}
    ]
  }
}
```

## Same model, compact format (.sgm)

A third, denser syntax for the exact same model — one line per node, positional arguments where a component's parameters allow it, `#` comments. Meant for hand-authoring and quick iteration (sketch a model, glance at it, tweak a value) — the GUI can open and save `.sgm` files like any other format.

**Status: Experimental in 1.0.** Its syntax may still grow in a 1.x release. One promise holds: every 1.x release reads, with the same meaning, any `.sgm` file that 1.0 wrote. XML and JSON are the frozen interchange formats (see [Format stability](#format-stability)).

```
dataset.root = SixStats

Die = Uniform(1, 7)
D6 = ToInteger(Die, "floor")
ThreeDice = Redimension(D6, 3)
Sum = Calculate(ThreeDice, "y[0] = x[0] + x[1] + x[2]")
KeepSum = Arrange(Sum, (0))
SixStats = Redimension(KeepSum, 6)
```

Key rules:
- `NodeName = Component(args)` is a node assignment. A filter's input is always its first argument (`ToInteger(Die, "floor")`); a component's other parameters follow, positionally where possible — each component's parameters have a defined order (matching their order in [Component-Library-Reference.md](Component-Library-Reference.md)) (for a custom component, a Pro feature, that order comes from `@Parameter(order = ...)`, described in the Pro Customization Guide) — or by `name=value` once one argument in the call is named, the same positional-then-keyword rule Python uses for function calls.
- `dataset.seed = 123` / `dataset.root = Name` / `dataset.random = com.example.MyRNG` / `dataset.streams = shared` replace XML's `<dataset seed="..." random="..." streams="...">` / `<root node="...">` (see [Random number generator override](#random-number-generator-override-pro--dynamic-extension) and [Random streams](#random-streams) above). `meta.<key> = "..."` is the same notes namespace as XML's `meta.*` attributes.
- Array/matrix-typed parameters use a tuple literal instead of a delimited string: `means=(72, 118, 98)` for a vector, `covariance=((144, 67.2), (67.2, 64))` for a matrix — the same values a `"144,67.2;67.2,64"`-style quoted string holds in XML/JSON, just structured instead of flattened.
- `# comment` — a comment line, start-of-line only (no trailing end-of-line comments).
- `define.declare`/`define.custom` and `Import` map onto `<declare>`/`<custom>` and `<Import>` (see [Parameterized sub-models](#parameterized-sub-models-pro--declare--import-overrides) and [Custom type definitions](#custom-type-definitions-pro--dynamic-extension) above) with identical semantics and identical Pro licensing — nothing about using this format changes what's Free vs. Pro:

  ```
  define.declare hrMean = "72"
  define.declare hrStdDev = "8"

  Normal = Import("vitals.xml", hrMean="140", hrStdDev="15")
  ```

## Per-input attributes (weight / role)

Some filters read extra attributes on individual `input` entries, not just the node's own attributes. `Mix` uses `weight`; `Perturb`, `PersonAssembler`, `Pool` and `ProcessFlow` use `role`.

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

`collaborate.<role>="TargetNodeName"` — a node-tag attribute (not an `<input>` child) naming another node this component exchanges data with out-of-band, via `ICollaborationTarget`. Distinct from and invisible to the `<Input>` tree: the referenced node is not added as an input, is not subject to the single-consumer rule for `<input>` edges, and is not visited by `ModelValidator`'s structural checks at all — an unresolvable or non-`ICollaborationTarget` reference fails at the consuming component's own `configure()` time instead, with a descriptive exception (same as any other named-reference resolution in this codebase). Zero-to-many named roles are supported per node.

Only a component that implements `ICollaborationConsumer` accepts `collaborate.*` attributes; on any other component they are rejected as unknown parameters. Writing your own target and consumer, and the rules that keep them deterministic, are in the [Customization Guide](Customization.md#95-collaborating-components-pro). The Beacon and Watcher below are small worked examples, not part of the 1.0 compatibility promise.

```xml
<CollaborationWatcher name="Watcher" collaborate.primary="BeaconA" collaborate.secondary="BeaconB">
	<input name="Source"/>
</CollaborationWatcher>
<Constant name="Source" value="1" type="double"/>

<CollaborationBeacon name="BeaconA" initial="100"/>
<CollaborationBeacon name="BeaconB" initial="500"/>
```

## Shared state (Pro)

Three components let separate parts of one model read and write named numbers, which is how a model holds a feedback loop (reorder when stock is low, throttle when a queue is long):

```xml
<SharedState name="Warehouse" cells="stock=100, backlog=0"/>
<StateRead name="Level" collaborate.state="Warehouse" cells="stock"/>
<StateWrite name="Apply" collaborate.state="Warehouse" cells="stock" mode="add">
	<input name="Net"/>
</StateWrite>
```

`SharedState` holds the cells (`name=initial`, comma-separated). `StateRead` is a generator that emits chosen cells. `StateWrite` is a filter that passes its input through and writes its columns into cells, with `mode="set"` (replace, the default) or `mode="add"`. The store is named with `collaborate.state="StoreName"` and is not an `<input>`.

**A read is one row behind.** A read in row *n* returns the value as of the end of row *n*-1 (the initial value in row 0); writes made in row *n* are visible from row *n*+1. So results never depend on where the readers and writers sit in the model. A cell may have at most one `set` writer and any number of `add` writers; the `add` amounts are summed in writer-name order, then added to the cell's base value. Cell names are checked when the model is validated or on the first row, before any output row. Worked sample: `samples/pro/shared-state-inventory.xml`.

## Process flow (Pro)

`ProcessFlow` runs a queueing network as one filter and emits its event log, one event per row:

```xml
<Exponential name="Gap" lambda="1.6"/>
<Exponential name="Service" lambda="1.0"/>
<ProcessFlow name="Desk" stations="Agent:2" entry="Agent">
	<input name="Gap" role="arrival"/>
	<input name="Service" role="service.Agent"/>
</ProcessFlow>
```

`stations` lists `Name:servers` pairs (`Lane[3]:1` is a group of three one-server stations; using the group name as `entry` or as the target of a routing edge sends each entity to the member with the fewest entities present, with `ties` and `join` options; `Name:inf` is a delay station: unlimited servers, nobody waits, and entities leave in the order their delays end); `entry` is where arrivals join; `routing` lists edges `From>To:prob` (`To` may be `exit`). The arrival gaps and the service times are ordinary input nodes tagged with `role="arrival"` and `role="service.<Station>"`, so any distribution or fitted source can drive them; the `role` is written as an attribute of the `<input>` entry in every format (in the compact format, as `role = arrival` inside the input's tuple, as for `Perturb`). Queues are first come first served. `output="events"` (default) gives 7 columns (`time`, `entity`, `station`, `type`, `queue`, `busy`, `inSystem`); `output="entities"` gives one row per departed entity (`exitTime`, `entity`, `sojourn`, `wait`, `service`, `visits`). Event rows are unevenly spaced in time, so average a column such as `queue` weighted by how long each value lasted. `until="840"` ends the run at a clock time and `closes="840"` stops external arrivals then and ends the run when the last customer has left; both end the run with an end of data (the rows produced are kept; the run needs no matching `--count`). With `until` and `output="entities"`, `censored="true"` adds a row at the horizon for each entity still inside (its age and totals so far) and a last column `censored` (1 for those rows, 0 for departed entities). A station's service time can be scaled by an expression of the attributes (`serviceScale="Lane: 0.9 + 0.1 * items"`: the service input's draw times the expression, in the `Calculate` language, over the attribute names). Entities can carry numeric attributes (`attributes="class"` with an input `role="entity"`), and the attributes can set the order a station serves its waiting entities (`priority="ED:class"`: lowest first, first come first served among equals, no interruption), the service time (`serviceBy="ED:class"` with inputs `role="service.ED@1"`, `role="service.ED@2"`, and `role="service.ED"` for the rest) and the routing (`routing="A[class=0]>exit:1; A>B:1"`); the attributes are appended to every output row. Arrivals can follow the clock: `rate="7:0.4, 8.5:6, 10:2"` (with `rateMode="linear"`, `ratePeriod`, `rateScale`, `rateStart`) gives the arrival rate as `time:rate` points, and the `arrival` input is then read in operational time (an `Exponential` of rate 1 makes a Poisson stream at that rate; see `RateSchedule` in the library reference for the same profile as a count per step in time-step models). A network of transit lines (`network="Metro: walk=3; Red = A B C back hop=2 stop=0.5 turn=2 headway=6; ..."`) gives the least-expected-time route between every pair of its places, computed when the model loads, readable in the attribute expressions through `routetime(o, d)` and the other route functions; `transit="Gate>exit: Metro from=o to=d"` makes a routing edge a ride over the network at rider level (a wait drawn from the headway at each boarding, the ride, the walk at each change), with `call`, `board` and `alight` rows; a line with `trains=N capacity=C load=L hold=on` instead runs real trains (riders board in order up to capacity, are left behind with a `denied` row, trains never overtake and so bunch, `depart` rows carry each train's load; see the library reference). Worked samples: `samples/pro/process-flow-subway.xml` (ten places on three lines, riders routed by least expected time), `samples/pro/process-flow-subway-trains.xml` (the same subway with trains: loads, riders denied, bunching), `samples/pro/process-flow-checkout.xml` (a grocery store in one node: a shopping delay station, a group of lanes joined by queue length, checkout time scaled by the basket), `samples/pro/process-flow-triage.xml` (an emergency department with five triage classes, priority and class-dependent treatment times in one node), `samples/pro/process-flow-day.xml` (a service desk over a day with two peaks), `samples/pro/process-flow-mmc.xml` (an M/M/2 desk with the time-weighted queue length computed by a `Recur`) and `samples/pro/process-flow-clinic.xml` (a three-station network with routing).

## Custom type definitions (Pro — dynamic extension)

Registers a fully-qualified Java class under a short tag name usable as a node `type`, without it being one of the built-in registered components. Requires Pro (`LicenseFeatures.requireDynamicExtension`).

```xml
<definitions>
	<custom name="MyType" class="com.example.MyGeneratorClass"/>
</definitions>
```

## Random number generator override (Pro — dynamic extension)

Replaces the built-in default RNG with a classpath class implementing `IRandom` (`getNextUniform()`, `getNextUniform(min, max)`, `getNextUniformInt(min, max)`, `getNextNormal()`, `getNextNormal(mean, sigma)`). Same caveats as `<custom>` above: the class must be on the classpath, and naming a class outside a recognized free package requires Pro — naming `com.obsvra.spicegrinder.core.defaults.Random` itself (the built-in default) is the one exception, since it's not really an extension at all.

```xml
<dataset random="com.example.MyRNG">
```
```json
{"dataset": {"random": "com.example.MyRNG", ...}}
```
```
dataset.random = com.example.MyRNG
```

With the default `streams="per-node"`, the class is constructed once for each node that draws random values, with its `(long seed)` constructor and that node's derived seed, which can be any `long` including a negative one. A class without a `(long seed)` constructor can't be given a separate stream per node, so the model fails to load with an error that names the fix: add the constructor, or set `streams="shared"`. With `streams="shared"` the class is constructed once for the whole model: with its `(long seed)` constructor when a seed applies, else its no-arg constructor — naming a class with no `(long)` constructor alongside a `seed` is a load-time error, not a silent unseeded fallback, since the seed request can't otherwise be honored.

Every way of running a model honors `random`: the desktop app, `Grind`, `compare`, the Service, the MCP server and the Lambda handler.

For what a pinned generator guarantees, including exact replay across Java versions, see [Determinism and reproducibility](Determinism.md#upgrading-java).

## Random streams

Every node that draws random values has its own random stream, derived from the dataset's seed and the node's name. Inside an `<Import>`, the name includes the import's prefix, e.g. `lib.HeartRate`. So with the same seed, adding, removing or reordering nodes doesn't change what any other node draws, and two runs that differ in one node's parameters differ only where that node's values flow. That makes same-seed scenario comparisons meaningful.

A node's stream follows its name. Renaming a node, or changing an `<Import>`'s `name` or `prefix`, gives the affected nodes new streams, as if they were new nodes; nothing else changes. A node's values are drawn in the order the node is pulled, not by row: when a `Mix` or `Switch` picks a branch, that branch's next value goes to the current row, so changing which rows pick a branch changes which values those rows see.

The Java `Import` generator, used when you build a graph from code (`ComponentFactory`), names its library's nodes' streams under the `Import` node's own name, as `<Import name="..."/>` does in a model file, so two Java `Import`s of the same library under one seed draw different values. The library's own seed is applied only if the process has no seed yet. See [Determinism](Determinism.md#seeds-custom-generators-and-code).

`streams="shared"` makes every node draw from one stream in pull order, the stream layout of SpiceGrinder Beta releases. Use it to reproduce output generated before 1.0. With a custom `random` class, `per-node` constructs one instance per random node with its `(long seed)` constructor, which may receive any `long` value; a class without that constructor needs `streams="shared"`.

```xml
<dataset seed="42" streams="shared">
```
```json
{"dataset": {"seed": 42, "streams": "shared", ...}}
```
```
dataset.streams = shared
```

Any value other than `per-node` and `shared` is a load error that lists the two. In the compact format the value may be quoted or, for `shared`, bare (`per-node` has a hyphen, so it needs quotes). `per-node` is the default and isn't written back when you save. An imported file's own `streams` is ignored, as its `seed` is: the importing model decides. How the streams are derived, with known answers you can check an implementation against, is in [Determinism and reproducibility](Determinism.md#random-streams).

## Parameterized sub-models (Pro — declare + Import overrides)

`<declare name="foo" value="bar"/>` inside `<definitions>` registers a named default value. Anywhere in `<nodes>` — a node attribute, an `<input>` attribute, or a child-element's text — a value that is *exactly* `$foo` (the whole attribute value) resolves to `bar` at load time, and `${foo}` anywhere inside a value is replaced by `bar`, text as written, before the component sees it: `expression="y[0] = x[0] * ${scale} + ${offset}"` puts a declared lever inside an expression. The replacement is not scanned again, is not parenthesized (write `(${a})` where the declared text may be an expression), and a `<declare>` value cannot itself contain `$name` or `${...}`. An unclosed `${` or an undeclared name is a load error. To run a model with other values without editing it, use `grind --declare NAME=VALUE` (repeatable), the `declares` argument of the MCP `generate` tool, or `?declare=NAME=VALUE` when registering a model with the Service. This turns a library file into a reusable, parameterized sub-model instead of a fixed one: import it as-is for the defaults, or override specific declared values per call site without duplicating the file.

A relative `file`, `../` included, must land inside a root: the importing top-level model's own folder, its project root, or a library folder (the organization's `libraries/`, or the user's `library.paths` when policy allows them). The project root (local root) of a model loaded from a file is the first of: `--local-root DIR` given to the command (the desktop app passes its Local root setting this way); `project.root` in `~/.spicegrinder/preferences.properties` (an absolute path; empty by default); the nearest folder at or above the model that contains a `.spicegrinder-root` file (its content is ignored; a staged release's top folder has one); the top of the Git work tree the model is in. With none of these, only the model's own folder counts. A relative import is looked for beside the model, then in the project root, then in the library folders. `FlatFile` data files and `Email` word lists use the same local root (see the Component Library Reference). A model sent as text with no folder of its own (the Service API, the MCP tools) has `project.root` as its project root when that is set (so a server's owner can narrow it), else the working directory, unless that is the filesystem root. Real paths are compared whole segment by segment, symlinks resolved, and every file an import pulls in is held to the top-level model's roots. So with `~/sg/.spicegrinder-root`, a model in `~/sg/models/myOrg` can import `../businessObj/person.xml`, while a `../` chain or a symlink that leaves every root is refused with `Import path leaves its root: <path as written>`. Absolute paths are unchanged: allowed in solo mode, governed by the organization's policy otherwise. If an imported file does not parse, the error names the file and the line/column, not its content.

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

A declare may carry a **type, a range and a check**, all optional: `<declare name="K" value="100" type="int" min="1" max="1000"/>` (`type` is `int`, `number` or `text`), and `check="N0 <= K"` (written `&lt;=` in XML), an expression over the numeric declares by name that must not come out 0. They are checked when the model is loaded, on the value in force (the default or any override: `--declare`, the MCP `declares`, `?declare=`, an `<Import>` attribute), and a failure names the declare and the value (`declare 'N0' = "150" fails its check 'N0 <= K' (N0 = 150, K = 100)`). In JSON the same keys sit beside `"name"` and `"value"`; in the compact format they follow the value: `define.declare K = "100" type=int min=1 max=1000 check="N0 <= K"`.

A `<declare>`'s own `value` is always a literal — it is never itself re-substituted, so `<declare name="x" value="$y"/>` is rejected at load time rather than silently landing `"$y"` as `x`'s literal value. Chaining a value through multiple levels of nested imports still works, just expressed as forwarded overrides instead of declare-to-declare references: an outer file's `<Import file="middle.xml" someParam="$myDeclare"/>` resolves `$myDeclare` from the outer file's own scope before handing the literal down, and if `middle.xml` in turn has its own `<Import file="inner.xml" innerParam="$someParam"/>`, that resolves from `middle.xml`'s scope (including whatever it was just handed) the same way.

## Repeated nodes (`foreach`)

A node, or an `<input>`, with `foreach="i=1..N"` is expanded when the model is loaded into one copy for each value of `i`, in order; in the copy `${i}` is the value, and `${i+1}`, `${i-1}` and `${i*2}` (one whole number after `+`, `-` or `*`) are allowed. It works in the node's name, its attribute values, its input names and attributes and its element text. Bounds are whole numbers, inclusive, and may use a declare (`foreach="i=1..${floors}"`); a range whose first value is above the last is an error. Several variables multiply out, the last varying fastest: `foreach="i=1..3, j=1..2"` is six copies. The name of a repeated node must contain its variables, or the copies collide.

```xml
<Constant name="Queue${i}" foreach="i=1..20" value="0"/>
<Append name="AllQueues"><input name="Queue${i}" foreach="i=1..20"/></Append>
```

A multi-line value (an `expression`) may repeat lines: a line `@foreach k=0..2` and a line `@end` surround the lines to repeat, with `${k}` and the arithmetic above in them; they nest. In an XML attribute a line break is written `&#10;`; in an element body or in the JSON and compact formats it is an ordinary line break.

The document keeps the unexpanded form, so a file read and written back keeps its `foreach`; the loader, the validator and the analyzer see ordinary nodes (and the Free node limit counts the copies). At most 100,000 nodes, or 16 MB of repeated text, come out of one expansion. Random streams follow node names as always, so `Draw1` and `Draw2` are separate streams.

## Dimension

Every node has a **dimension** — the number of `DataPoint` objects per `Observation` it emits. Filters like `Redimension`/`Arrange`/`Append` change dimension explicitly; most generators are fixed-dimension (often 1, multivariate ones like `MultivariateNormal`/`Dirichlet`/`Wishart` are k-dimensional based on their own parameters).

## Validation

`ModelValidator`/`IGenerator.validate()` runs structural checks (e.g. `Mix` needs 2+ inputs, `Truncate` needs sane bounds) — surfaced through Save/Save-Subtree/XML-view error handling in the GUI, or the standalone `ModelValidatorApp` CLI launcher. `ModelValidatorApp` also does a smoke run (up to 1,000 rows, discarded) after the structural checks, which catches run-time errors such as a `choose` index past its list; it can catch such errors but not prove there are none (see ModelValidatorApp.md).
