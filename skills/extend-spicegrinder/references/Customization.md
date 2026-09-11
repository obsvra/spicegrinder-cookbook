![spicegrinder-icon](assets/spicegrinder-icon.png)
# SpiceGrinder Customization Guide

This document explains how to **extend and customize** SpiceGrinder without modifying its core source code.

The system is deliberately designed around:

- **Interfaces** as the public contract
- **Package scanning + reflection** for discovery
- **Annotations** that declare metadata the loader and GUI can use
- **Runtime registration** of additional packages

Anyone with a compiled SpiceGrinder library on the classpath can add new generators, filters, and random sources by following the patterns below.

> **This entire document describes a Pro feature.** Dynamic extension — loading any generator or filter that isn't one of SpiceGrinder's own built-in `core.defaults.generators`/ `core.defaults.filters` classes — requires SpiceGrinder Pro and is enforced at model-load time, whether you register it via package scanning (Option A below), explicit registration (Option B), or a fully-qualified class name in XML/`<definitions>` (Option C).

> A Free build rejects all three with a clear `LicenseException`. If you're writing tooling, documentation, or an AI-assisted workflow that walks someone through this guide, make that requirement explicit up front rather than letting a Free user discover it only after writing and compiling a custom component — this was verified against a real exploit attempt and fixed for (internal record, not bundled with this reference copy).

> **A related but different Pro feature**: this guide is about writing and registering your *own* generator/filter classes, loaded the normal way through `ModelLoader`. If instead you want to construct one of SpiceGrinder's own *built-in* classes (`Uniform`, `Append`, etc.) directly from your own Java code — bypassing a model file entirely — that's `com.obsvra.spicegrinder.core.factories.ComponentFactory`, also Pro-only. Built-in generator/filter constructors are package-private on purpose; `new Uniform(...)` from outside their package won't compile on either edition. `ComponentFactory.construct(...)` is the sanctioned path, and throws a clear `LicenseException` on Free.

---

## 1. Core Principles

1. **Interfaces are the contract**  
   You never need to subclass a concrete default class unless you want to. Implementing the interface is enough.

2. **Discovery is automatic**  
   Classes that implement the right interfaces and live in a scanned package are found at runtime. No central registry file needs to be edited.

3. **Metadata is declarative**  
   Use annotations so the loader (and future GUI) know the component’s short name, category, and configurable parameters.

4. **Override is first-class**  
   If two components claim the same short name, the last one registered wins. You can therefore replace a built-in component by supplying your own implementation under the same name.

---

## 2. Key Interfaces

| Interface | Package | Purpose |
|-----------|---------|---------|
| `IGenerator` | `com.obsvra.spicegrinder.core.interfaces` | Produces an `IObservation` on each call to `getNextObservation()` |
| `IFilter` | `com.obsvra.spicegrinder.core.interfaces` | A generator that also accepts one or more input generators |
| `IRandom` | `com.obsvra.spicegrinder.core.interfaces` | Abstraction over random-number generation |
| `IObservation` | `com.obsvra.spicegrinder.core.interfaces` | Collection of `IDataPoint`s returned by a generator |
| `IDataPoint` / `INumericDataPoint` | `com.obsvra.spicegrinder.core.interfaces` | Single discrete value inside an observation |

### Minimal Generator Contract

```java
public interface IGenerator {
    String getName();
    int getDimension();
    boolean isSynchronous();
    IObservation getNextObservation() throws SpiceGrinderException;

    // Legacy hook (still supported)
    void loadSettings(Collection<Pair<String,String>> keyValuePairs)
            throws NotImplementedException;
}
```

**`configure(...)` is not part of `IGenerator` itself** — it lives on the concrete `Generator`/`Filter` base classes (see §3), which is what `ModelLoader`'s Pass 2 actually calls (`if (gen instanceof Generator generator) generator.configure(settings, registry)`). A class that implements `IGenerator` directly, without extending `Generator`/`Filter`, has no `configure()` hook at all and would need to rely on `loadSettings(...)` or its own constructor for configuration — extending the base classes is the practical path for anything that needs XML-supplied settings, which is nearly everything.

### Minimal Filter Contract

`IFilter` extends `IGenerator` and adds:

```java
Collection<IGenerator> getInputs();
void addInput(IGenerator input) throws NotImplementedException;
void addInputs(Collection<IGenerator> inputs) throws NotImplementedException;
```

---

## 3. Recommended Base Classes (optional but convenient)

SpiceGrinder ships convenience abstract classes you may extend:

- `com.obsvra.spicegrinder.core.defaults.Generator`
- `com.obsvra.spicegrinder.core.defaults.Filter`

These already implement the common bookkeeping (name, dimension, synchronous flag, input list, etc.). You are free to ignore them and implement the interfaces directly.

---

## 4. Annotation Scheme

### 4.1 `@ComponentInfo` (class-level)

```java
@ComponentInfo(
    name        = "MyGenerator",          // XML element name (defaults to simple class name)
    description = "Short human description",
    category    = "generator",            // "generator" | "filter" | custom
    hidden      = false                   // true = do not show in normal discovery
)
public class MyGenerator extends Generator { ... }
```

### 4.2 `@Parameter` (field-level)

```java
@Parameter(
    name         = "rate",
    aliases      = {"lambda", "intensity"},
    description  = "Event rate (must be > 0)",
    required     = true,
    defaultValue = "1.0",
    category     = "Distribution"
)
private double rate = 1.0;
```

**Multiple / repeating parameters** (e.g. filter inputs):

```java
@Parameter(
    name            = "input",
    multiple        = true,
    required        = true,
    minOccurrences  = 1,
    maxOccurrences  = 0,          // 0 = unlimited
    attributes      = {"name", "weight"},
    category        = "Inputs",
    description     = "Weighted input generator reference"
)
private List<String> inputSlot;   // carrier for discovery; wiring may live elsewhere
```

| Attribute | Meaning |
|-----------|---------|
| `multiple` | Parameter may appear more than once |
| `minOccurrences` | Minimum count when multiple (0 = none unless `required`) |
| `maxOccurrences` | Maximum count (0 = unlimited) |
| `attributes` | Child attribute names for each occurrence (GUI table columns) |

Supported field types for automatic conversion (scalar path):

- `String`, `int` / `Integer`, `long` / `Long`, `double` / `Double`, `float` / `Float`, `boolean` / `Boolean`
- `double[]` / `int[]` (comma- or space-separated)

The reflective configurator sets scalar fields from XML attributes (or GUI property sheets). Multiple/complex slots (like Mix inputs) are documented for the GUI and loader; wiring is still handled in `configure()`.

---

## 5. Writing a Custom Generator (complete example)

`Skellam` is an actual distribution generator in the core SpiceGrinder library. Its source code is reproduced here as a practical, fully-worked, fully-tested example of how to write a custom Generator on your own. (The package name has been changed so that you could literally copy-and-paste the example and be able to load it as an override of the core library version.)

```java
package com.acme.spice.extensions;

import java.util.Collection;
import com.obsvra.spicegrinder.core.annotations.ComponentInfo;
import com.obsvra.spicegrinder.core.annotations.Parameter;
import com.obsvra.spicegrinder.core.defaults.Generator;
import com.obsvra.spicegrinder.core.defaults.Observation;
import com.obsvra.spicegrinder.core.defaults.datapoints.IntDataPoint;
import com.obsvra.spicegrinder.core.interfaces.IObservation;
import com.obsvra.spicegrinder.core.exceptions.SpiceGrinderException;
import com.obsvra.spicegrinder.core.interfaces.IRandom;
import com.obsvra.spicegrinder.core.random.Randoms;
import com.obsvra.spicegrinder.core.utilities.NodeMap;
import com.obsvra.spicegrinder.core.utilities.Pair;

// Difference of two independent Poisson variables (P1 - P2); can be negative, unlike a
// plain Poisson -- the natural distribution for "net signed events between two independent
// count processes."
@ComponentInfo(
    name        = "Skellam",
    description = "Difference of two independent Poisson variables (P1 - P2)",
    category    = "generator"
)
public class Skellam extends Generator {

    private IRandom random;

    @Parameter(name = "lambda1", aliases = {"rate1"},
               description = "Rate of the first Poisson term (>= 0)", defaultValue = "1.0")
    private double lambda1 = 1.0;

    @Parameter(name = "lambda2", aliases = {"rate2"},
               description = "Rate of the second Poisson term (>= 0)", defaultValue = "1.0")
    private double lambda2 = 1.0;

    // Required by the loader (Pass 1) -- every generator needs this constructor shape.
    public Skellam(String name) {
        super(name);
        this.random = Randoms.get();   // the real process-wide RNG handle -- see §8
    }

    @Override
    public void configure(Collection<Pair<String,String>> settings, NodeMap registry)
            throws Exception {
        // Manual parsing -- the pattern most of Core's own distributions actually use.
        // ReflectiveConfigurer.apply(...) (see Uniform/Normal/Exponential in Core) is a
        // real, valid alternative for simple scalar-only fields; this shows the more
        // common style since it's what you'll see reading most of the codebase.
        for (Pair<String, String> pair : settings) {
            String key = pair.getKey().toLowerCase();
            String val = pair.getValue();
            if ("lambda1".equals(key) || "rate1".equals(key)) {
                lambda1 = Double.parseDouble(val);
            } else if ("lambda2".equals(key) || "rate2".equals(key)) {
                lambda2 = Double.parseDouble(val);
            }
        }
        if (lambda1 < 0.0 || lambda2 < 0.0) {
            throw new Exception("Skellam '" + getName() + "': lambda1 and lambda2 must both be >= 0");
        }
    }

    @Override
    public IObservation getNextObservation() throws SpiceGrinderException {
        int value = samplePoisson(lambda1) - samplePoisson(lambda2);

        IObservation obs = new Observation();     // the real constructor -- see below
        obs.add(new IntDataPoint(value));
        return obs;
    }

    // Knuth's algorithm -- same as Core's own Poisson. Every distribution in this codebase
    // keeps its own sampling algorithm self-contained rather than sharing a utility class
    // for it; see the README's MatrixOps entry for the one deliberate, narrow exception.
    private int samplePoisson(double lambda) {
        double L = Math.exp(-lambda);
        int k = 0;
        double p = 1.0;
        do {
            k++;
            p *= random.getNextUniform();
        } while (p > L);
        return k - 1;
    }
}
```

### Using it from XML

```xml
<dataset>
  <root node="NetSignups"/>
  <nodes>
    <Skellam name="NetSignups" lambda1="12" lambda2="9"/>
  </nodes>
</dataset>
```

---

## 6. Making Your Components Visible

### Option A – Put them in a scanned package (recommended)

```java
ModelLoader loader = new ModelLoader();
loader.addScanPackage("com.acme.spice.extensions");   // your package
IGenerator root = loader.load(new File("model.xml"));
```

Default packages that are always scanned:
- `com.obsvra.spicegrinder.core.defaults.generators`
- `com.obsvra.spicegrinder.core.defaults.filters`

Under a **Pro** build, additional packages are automatically scanned:
`pro.generators`, `pro.filters`, `business.generators`, `business.filters`, `examples.generators`, `examples.filters`

### Option B – Explicit registration

```java
ComponentRegistry.getInstance().register(Skellam.class);
```

### Option C – Fully-qualified class name in XML

You can always write:

```xml
<com.acme.spice.extensions.MyGenerator name="MyInstance" xm="2.0" alpha="3.0"/>
```

No scanning required. The identical rule applies to a model's own
`<definitions><custom name="..." class="..."/></definitions>` block, which gives a class an XML short alias — it's the same check either way, since both resolve to a class name that `ModelLoader` has to instantiate.

---

## 7. Overriding a Built-in Component

Because short-name lookup is a simple map, the **last registration wins**. Since the built-in SpiceGrinder components are registered first, that allows you to override them with your own components.

```java
// After the defaults have been scanned:
ComponentRegistry.getInstance().register(MyImprovedUniform.class);
// MyImprovedUniform is annotated with @ComponentInfo(name = "Uniform")
```

Any XML that asks for `<Uniform .../>` will now receive your implementation.

---

## 8. Custom Random Sources

Implement `IRandom` and install it via `Randoms`
(`com.obsvra.spicegrinder.core.random.Randoms`) — a simple static holder, not a factory class:

```java
public class MySecureRandom implements IRandom {
    // ... implement IRandom's methods ...
}

// At startup, before any generators are constructed:
Randoms.set(new MySecureRandom());
```

`Randoms` is process-wide static state (`Randoms.get()` returns whatever was last set, or the default source if `set(...)` was never called). Generators read it **once, at construction time** — every default distribution's `(String name)` constructor calls `Randoms.get()` and keeps the result (see `Skellam` in §5) — so `Randoms.set(...)` only affects generators built *after* the call. There's no per-generator reseed-in-place; to change the random source for an already-built model, rebuild it (e.g. reload via `ModelLoader`) after calling `Randoms.set(...)`. For reproducible-but-different-per-dataset seeding rather than a different `IRandom` implementation entirely, see `Randoms.applyDatasetSeed(Long)` instead, which is what the embedded-seed and `--seed`/`--no-seed` CLI handling in `ModelRunner` uses.

---

## 9. Filters

Filters follow the same annotation and discovery rules. They should implement `IFilter` (or extend `com.obsvra.spicegrinder.core.defaults.Filter`).

Typical responsibilities:

- Accept one or more input generators (`addInput` / `addInputs`)
- In `configure`, resolve input references from the `NodeMap` registry
- Produce a new observation that is a function of the inputs

The base `Filter` class already provides a default `configure` that wires `<input name="..."/>` children for you.

### 9.1 Handling `synchronous` — read this before overriding `configure()` yourself

Every generator reports `isSynchronous()`: whether it needs to stay "in lock-step" with sibling generators even on cycles where its own output isn't the one actually used (a `Sequence`/counter-style generator hidden behind a selector is the classic case — if it only
advances when selected, its value silently desyncs from wall-clock/draw-count expectations the moment something else is chosen instead).

**In most cases you don't need to do anything.** `Filter`'s default `configure()` already resolves this correctly for the common shape — a filter whose inputs are all structurally equivalent (always read on every call, like `Append`/`Drop`/`Redimension`/`Calculate`, or all
equally "candidate branches," like `Mix`'s inputs): if the model writes an explicit `synchronous="true"`/`"false"` (or `sync="..."`) attribute on your filter's XML element, that wins outright; otherwise your filter automatically inherits `isSynchronous() == true` if *any*
of its resolved inputs is itself synchronous. This means a synchronous generator's need to keep advancing propagates transparently through however many wrapper filters sit between it
and the selector that actually decides whether to call it — the model author never has to manually re-flag every intermediate node in the chain.

```
Sequence(synchronous="true") -> Append (no explicit synchronous) -> Mix (no explicit synchronous)
```

Here, `Append` inherits `synchronous == true` from the `Sequence`, and `Mix` in turn inherits it from `Append` — so `Mix`'s own existing "force-advance synchronous-but-unselected inputs" logic correctly keeps the `Sequence` ticking even on cycles where `Mix` picks its other branch, with zero attributes written anywhere except on the original `Sequence`.

**When you *do* need to think about it**: only when your filter has *heterogeneous* input roles — some inputs are genuine "branches" whose synchronicity should matter, others are meta/parameter-like inputs (a schedule, a count, a threshold generator) whose synchronicity is irrelevant to whether the branches stay in lock-step. The built-in `Perturb` filter is the concrete example: it takes four inputs (`normal`, `disturbance`, `wait`, `duration`), but only
`normal`/`disturbance` are branches in the relevant sense — an unusual model that happened to plug a synchronous generator in as the `wait` schedule shouldn't silently flip `Perturb` itself into synchronous mode. `Perturb` handles this by overriding
`synchronousInheritanceInputs()`:

```java
@Override
protected Collection<IGenerator> synchronousInheritanceInputs() {
    return List.of(normal, disturbance);   // NOT waitGen/durationGen
}
```

If your filter resolves input *roles* itself (rather than relying purely on `Filter`'s generic `<input name="..."/>` wiring), there's one ordering subtlety: the default `configure()` resolves inputs *and* applies the synchronous default in one pass, but your override needs those role fields (like `normal`/`disturbance` above) already populated before it runs. Split the two steps yourself instead of calling `super.configure(settings, registry)` in one shot:

```java
@Override
public void configure(Collection<Pair<String, String>> settings, NodeMap registry) throws Exception {
    resolveInputs(settings, registry);   // populates this.inputs; does NOT touch isSynchronous
    // ... your own role resolution here, using this.inputs and/or registry.getNode(...) ...
    applySynchronousDefault(settings);   // now synchronousInheritanceInputs() sees your resolved roles
}
```

`hasExplicitSynchronous(settings)` (a protected static helper on `Filter`) is also available if you need to check for an explicit override yourself outside this flow.

---

## 10. Checklist for a New Component

1. Implement `IGenerator` (or `IFilter`) — or extend the convenient base class.
2. Provide a public constructor that takes a single `String name`.
3. Annotate the class with `@ComponentInfo` (optional but recommended).
4. Annotate configurable fields with `@Parameter`.
5. In `configure`, populate your fields from `settings` — either manually (loop over the `Collection<Pair<String,String>>` and match keys/aliases yourself; see `Skellam` in §5, the pattern most of Core's own distributions use), or via `ReflectiveConfigurer.apply(this, descriptor, settings)` for simple scalar-only fields (see `Uniform`/`Normal`/`Exponential` in Core) — then perform any extra validation or wiring. Neither is mandatory; pick whichever fits your field types.
6. Place the class on the classpath in a package that will be scanned, **or** register it explicitly, **or** refer to it by fully-qualified name in XML.
7. (Optional) Ship a small sample XML snippet so users know the attribute names.

---

## 11. What You Do *Not* Need

- You do **not** need to edit any central registry file inside SpiceGrinder.
- You do **not** need to recompile the core library.
- You do **not** need source access to the built-in generators (you only need the published interfaces and annotations on the classpath).

---

## 12. GUI Considerations

The same `ComponentRegistry` and `@Parameter` metadata will drive:

- The palette of available node types
- Automatically generated property sheets
- Validation of required parameters
- Grouping by category

Keeping your custom components well-annotated therefore pays off both for XML users and for visual-model users.

---

## 13. Giving Your Component a Complexity-Scoring Weight

`ModelComplexity`'s score formula weights every node by a per-class cost multiplier — how expensive that component type is, relative to baseline, measured from real isolated-benchmark runs. Every component not explicitly weighted defaults to `1.0`, so your custom generator/filter works fine with no extra steps — it just won't be distinguished from a cheap one in complexity scores until you tell SpiceGrinder otherwise.

Once you've profiled it — `ModelAnalyzerApp --isolate --isolate-raw` against a model that exercises it (see the perf-models/README.md pattern this project uses for its own built-ins) — add its weight to `~/.spicegrinder/component-weights.properties`:

```properties
# Fully-qualified class name, not the short/XML name -- unambiguous even if someone else's
# extension package happens to use the same short name for something unrelated.
com.acme.spice.extensions.MyExpensiveGenerator=6.8
```

Note that the `--isolate` functionality has a tendency to significantly overweigh very simple components. If you have every reason to believe your component is simple, just leave it at the default `1.0` weight.

See `docs/component-weights.properties.example` for the full format (this file is also how you'd override a *bundled* weight for your own measured hardware, not just add new ones — the two use cases share the same mechanism). No code change or SpiceGrinder rebuild needed either way; the file is read at first use and merged on top of the bundled default.
