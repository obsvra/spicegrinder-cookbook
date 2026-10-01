![spicegrinder-icon](assets/spicegrinder-icon.png)
# SpiceGrinder Customization Guide

> © 2026 Obsvra. This document describes SpiceGrinder and is provided to help you evaluate and use it. It is not a license to reproduce, adapt, or use this material to build a competing product or service. Full terms: the SpiceGrinder EULA.

This document explains how to **extend and customize** SpiceGrinder without modifying its core source code.

The system is deliberately designed around:

- **Interfaces** as the public contract
- **Package scanning + reflection** for discovery
- **Annotations** that declare metadata the loader and GUI can use
- **Runtime registration** of additional packages

Anyone with a compiled SpiceGrinder library on the classpath can add new generators, filters, and random sources by following the patterns below.

> **This entire document describes a Pro feature.** Dynamic extension — loading any generator or filter that isn't one of SpiceGrinder's own built-in `core.defaults.generators`/ `core.defaults.filters` classes — requires SpiceGrinder Pro and is enforced at model-load time, whether you register it via package scanning (Option A below), explicit registration (Option B), or a fully-qualified class name in XML/`<definitions>` (Option C).

> A Free build rejects all three with a clear `LicenseException`. If you're writing tooling, documentation, or an AI-assisted workflow that walks someone through this guide, make that requirement explicit up front rather than letting a Free user discover it only after writing and compiling a custom component.

> **A related but different Pro feature**: this guide is about writing and registering your *own* generator/filter classes, loaded the normal way through `ModelLoader`. If instead you want to construct one of SpiceGrinder's own *built-in* classes (`Uniform`, `Append`, etc.) directly from your own Java code — bypassing a model file entirely — that's `com.obsvra.spicegrinder.core.factories.ComponentFactory`, also Pro-only. Built-in generator/filter constructors are package-private on purpose; `new Uniform(...)` from outside their package won't compile on either edition. `ComponentFactory.construct(...)` is the sanctioned path, and throws a clear `LicenseException` on Free. **If your app is multithreaded, read [§8.1](#81-concurrent-generation-is-not-safe--you-must-serialize-it-yourself) before you call generation from more than one thread** — SpiceGrinder is single-threaded by default and using it in a multi-threaded environment requires adding a layer of thread-safety yourself.

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

    // Default: reflectively binds every @Parameter-annotated scalar field this class
    // declares (registering it with ComponentRegistry first if needed) -- override for
    // anything beyond simple scalar binding.
    default void configure(Collection<Pair<String,String>> settings, NodeMap registry)
            throws Exception { ... }
}
```

**`configure(...)` is part of `IGenerator` itself**, with a default implementation — `ModelLoader`'s Pass 2 calls it directly on the `IGenerator` reference (`gen.configure(settings, registry)`), no downcast to `Generator`/`Filter` needed. The default reflectively binds every `@Parameter`-annotated scalar field via `ReflectiveConfigurer.apply(...)`, so a class that implements `IGenerator` directly — without extending `Generator`/`Filter`, and without writing a `configure()` override at all — still gets simple scalar parameters "just working" for free. Extending `Generator`/`Filter` (see §3) is still recommended for the bookkeeping they provide (name/dimension/synchronous flag, input list, `<input name="..."/>` wiring), but it's not a requirement for basic configuration to work.

Override `configure(...)` yourself for anything the default can't do: resolving `<input name="..."/>` references from `registry` (per §9, `Filter`'s own `configure()` already does this for you), multi-occurrence/complex parameters (a `multiple = true` `@Parameter` — see §4.2 — is a GUI-discovery-only carrier over a non-scalar field; the default skips it and leaves real wiring to your own `configure()`), or validation that should fail the whole load immediately.

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
    hidden      = false,                  // true = do not show in normal discovery
    input       = "",                     // filters with one plain input: what it must supply
    details     = ""                      // longer Markdown reference text (a text block reads well)
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
    category     = "Distribution",
    order        = 0              // first positional argument in .sgm shorthand; see table below
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
| `order` | Position of this parameter in the compact (`.sgm`) format's `Component(arg1, arg2, ...)` shorthand, and its row in property panels. Set it on every parameter: 0, 1, 2, ..., unique within the component. `-1` (the default) falls back to the order fields are declared in, which Java doesn't guarantee, and an unset parameter sorts *before* 0, so adding one to an ordered component shifts every positional argument after it. Add new parameters at the end with the next number. |

**Enumerated parameters** (a fixed set of accepted values):

```java
@Parameter(
    name          = "mode",
    defaultValue  = "standard",
    description   = "standard | large-lambda",
    allowedValues = {"standard", "large-lambda"}
)
private String modeText = "standard";
```

`allowedValues` lists the canonical choices for UIs (a GUI dropdown instead of a free-text field), docs, and agents — it shows up as `"allowedValues": [...]` in `ComponentLibraryApp --json`/`GET /v1/components`/`list_components` (see [ComponentLibraryApp.md](ComponentLibraryApp.md#output-json)), `[]` when unset. **It's descriptive, not enforced** — your own `configure()`/parsing logic is still the sole source of truth for what the parameter actually accepts, and may accept more than this list documents (extra aliases, case variants, etc.). Only set it when your own code really does restrict the parameter to that finite set; leave it off for free-form or numeric parameters, even if the description mentions example values.

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
        // Manual parsing, shown here to illustrate the escape hatch. It's the less
        // common pattern in Core: a handful of generators (Constant, MultivariateNormal)
        // parse this way because they check several fields together; most, including
        // the real Skellam, call ReflectiveConfigurer.apply(...) instead.
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

### Using custom components with `ModelServiceApp`

Options A/B above assume you control the `ModelLoader` call directly (embedding SpiceGrinder in your own app, or the CLI/GUI). The Service is a separately-launched, long-running process you don't call into that way — but the underlying requirement is identical: your class has to be on **that process's** classpath, set once at launch. Two ways to do it, matching however you're running the Service:

- **Raw jar**: add your jar to `-cp` alongside SpiceGrinder's own, same as you would for any other Java process — `java -cp spicegrinder.jar:my-plugin.jar com.obsvra.spicegrinder.pro.service.ModelServiceApp`.
- **jpackage install**: the native `service`/`service.exe` launcher reads its classpath from a generated config file (`service.cfg`, next to the launcher — `Contents/app/service.cfg` on macOS) rather than a command-line flag. Add your jar to its `app.classpath` line (`:`-separated on macOS/Linux, `;`-separated on Windows) and the launcher picks it up on the next start.

Either way, reference the class the same way you would locally: its fully-qualified name directly as an XML tag (Option C above), or via a `<definitions><custom .../></definitions>` alias in the model you register with the Service. There's no separate plugin directory and no hot-reload — a classpath change only takes effect on the next process start, exactly like any other JVM's classpath. That's a deliberate simplification, not a missing feature: the Service's classpath being fixed at launch (no dynamic loading mid-run) is part of what keeps its trust model simple, and restarting to pick up a new component is the same cost as restarting to pick up any other code change during development.

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

`Randoms` is process-wide static state (`Randoms.get()` returns whatever was last set, or the default source if `set(...)` was never called). Generators read it **once, at construction time** — every default distribution's `(String name)` constructor calls `Randoms.get()` and keeps the result (see `Skellam` in §5) — so `Randoms.set(...)` only affects generators built *after* the call. There's no per-generator reseed-in-place; to change the random source for an already-built model, rebuild it (e.g. reload via `ModelLoader`) after calling `Randoms.set(...)`. For reproducible-but-different-per-dataset seeding rather than a different `IRandom` implementation entirely, see `Randoms.applyDatasetSeed(Long)` instead, which is what the embedded-seed and `--seed`/`--no-seed` CLI handling in `Grind` uses.

### 8.1 Concurrent generation is not safe — you must serialize it yourself

**If you're embedding SpiceGrinder in your own multithreaded application** (direct construction via `ComponentFactory`, or any other path that ends up calling `getNextObservation()` from more than one thread), this is the one thing in this whole guide most likely to fail silently: two threads calling `getNextObservation()` concurrently on generators sharing the same `IRandom`/`RandomGenerator` — which, per the paragraph above, is the *normal* case, since every generator built in one `Randoms.set(...)` window shares one instance — is not safe. `Randoms.current` itself is `volatile`, so swapping which source is active (`Randoms.set(...)`) is safe to do from another thread; that's a different guarantee from concurrent *draws* being safe, and it isn't one. The JDK's modern `RandomGenerator` algorithms this project targets are not documented as thread-safe for concurrent use by a single instance, and nothing in `IRandom`/`Randoms`/the default generators adds locking on top of that.

This is exactly why `ModelServiceApp` runs every `/generate`/`/stream` call through a single background worker per process, one job at a time — a deliberate design choice, not an oversight (see [Service API Reference](Service-API-Reference.md#concurrency-model)). If you're using the Service API, this is already handled for you. **If you're using direct construction in your own app, it isn't** — nothing stops you from calling generation from multiple threads yourself, and nothing will warn you if you do. Serialize calls into any given generator graph yourself (a single worker thread/executor per graph is the simplest correct shape, mirroring what the Service API already does internally) if your application is multithreaded.

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

**In most cases you don't need to do anything.** `Filter`'s default `configure()` already resolves this correctly for the common shape — a filter whose inputs are all structurally equivalent (always read on every call, like `Append`/`Arrange`/`Redimension`/`Calculate`, or all
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

### 9.2 Multi-Input Filters with Roles (complete example)

Some filters need more than a flat, homogeneous list of inputs (like `Append`, where every input plays the same part) — they need specific, *named* inputs, the way a join needs a left side and a right side. `PersonAssembler` (`com.obsvra.spicegrinder.business.filters`, Pro) is a real, shipped, fully-tested example: it combines a `[gender, givenName]` source and a `surname` source into one `Person` value, and the two inputs are not interchangeable — swapping them would silently produce nonsense, not just a different but valid result.

```java
package com.obsvra.spicegrinder.business.filters;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.obsvra.spicegrinder.core.annotations.ComponentInfo;
import com.obsvra.spicegrinder.core.annotations.Parameter;
import com.obsvra.spicegrinder.core.defaults.Filter;
import com.obsvra.spicegrinder.core.defaults.Observation;
import com.obsvra.spicegrinder.business.datapoints.PersonDataPoint;
import com.obsvra.spicegrinder.core.interfaces.IGenerator;
import com.obsvra.spicegrinder.core.interfaces.IObservation;
import com.obsvra.spicegrinder.core.exceptions.SpiceGrinderException;
import com.obsvra.spicegrinder.core.utilities.NodeMap;
import com.obsvra.spicegrinder.core.utilities.Pair;

@ComponentInfo(
        name        = "PersonAssembler",
        description = "Assembles a [gender, givenName] source and a surname source into a Person",
        category    = "filter")
public class PersonAssembler extends Filter {

    @Parameter(
            name          = "input",
            multiple      = true,
            required      = true,
            minOccurrences = 2,
            maxOccurrences = 2,
            attributes    = {"name", "role"},
            category      = "Inputs",
            description   = "Inputs: genderGiven (dimension-2: [gender, givenName]), surname (dimension-1)")
    // Reflection/GUI discovery slot only -- wiring below uses the role attributes directly.
    private final List<String> inputSlot = new ArrayList<>();

    private IGenerator genderGivenGen;
    private IGenerator surnameGen;

    public PersonAssembler(String name) {
        super(name, 1);
        this.inputs = new ArrayList<>();
    }

    @Override
    public void configure(Collection<Pair<String, String>> settings, NodeMap registry) throws Exception {
        super.configure(settings, registry);   // scalar @Parameter binding + populates this.inputs

        Map<String, IGenerator> byRole = new HashMap<>();
        for (Pair<String, String> p : settings) {
            String key = p.getKey();
            if (key != null && key.startsWith("input.") && key.endsWith(".role")) {
                String refName = key.substring("input.".length(), key.length() - ".role".length());
                IGenerator g = registry.getNode(refName);
                if (g != null) {
                    byRole.put(p.getValue().toLowerCase(), g);
                }
            }
        }

        if (byRole.containsKey("gendergiven") && byRole.containsKey("surname")) {
            genderGivenGen = byRole.get("gendergiven");
            surnameGen = byRole.get("surname");
        } else if (inputs.size() >= 2) {
            // Fallback: fixed order (genderGiven, surname) if roles weren't given explicitly
            genderGivenGen = inputs.get(0);
            surnameGen = inputs.get(1);
        } else {
            throw new Exception("PersonAssembler '" + getName()
                    + "' requires two inputs (genderGiven, surname)");
        }

        this.dimension = 1;
    }

    @Override
    public IObservation getNextObservation() throws SpiceGrinderException {
        IObservation genderGivenObs = genderGivenGen.getNextObservation();
        String gender = genderGivenObs.getAt(0).stringValue();
        String given = genderGivenObs.getAt(1).stringValue();
        String surname = surnameGen.getNextObservation().getAt(0).stringValue();

        IObservation obs = new Observation();
        obs.add(new PersonDataPoint(gender, given, surname));
        return obs;
    }
}
```

### Using it from XML

```xml
<PersonAssembler name="Person">
  <input name="GenderGiven" role="genderGiven"/>
  <input name="Surname" role="surname"/>
</PersonAssembler>
```

**Why `inputSlot` is `multiple = true`, and why that matters for `configure()`.** A parameter declared `multiple = true` is a GUI/discovery-only carrier — it exists so the registry and GUI know this component takes repeatable `<input name="..." role="..."/>` children, not so `IGenerator`'s default `configure()` can bind it. Multi-occurrence values don't reduce to one string the way a scalar `@Parameter` does, so the default reflective binding **skips** any `multiple = true` field rather than attempting to (and failing to) stuff a list of inputs into it. That's exactly why `PersonAssembler` still needs its own `configure()` override even though its scalar binding is free: the *role wiring* — matching `role="genderGiven"`/`role="surname"` to the right resolved generator — is real logic no annotation can express, so it's still your job, same as resolving `<input name="..."/>` references is `Filter`'s job for the simple case. The pattern in general: `multiple = true` gets you correct GUI/discovery metadata for free; it never gets you automatic wiring, for any filter, built-in or your own.

### 9.3 Importing External Objects via `ISerializable` and `Convert`

The filters above compose values that already live inside SpiceGrinder's own component graph. `Convert` (`com.obsvra.spicegrinder.pro.filters.Convert`, Pro) solves a different problem: bringing in a whole *object* from outside the system — the likely sources are `ServiceCall` (a backend you don't control, possibly not even written in Java), `FlatFile`, and `Database` (a persisted value written by something else entirely) — without flattening it into individual `DataPoint` fields and hand-reassembling them on the way back in, which breaks the moment the object's shape changes.

The contract your object implements is `com.obsvra.spicegrinder.core.interfaces.ISerializable`: `serialize()` (render to a string), `deserialize(Map<String,Object> fields)` (populate from already-parsed data — called once, immediately after construction, not a live mutation API), and `get(String key)` (read a field back out generically). You can implement all three by hand, or extend `com.obsvra.spicegrinder.core.interfaces.AbstractSerializable` for the common case — it backs `serialize()`/`get()` with a plain accumulated map, so you only call `add(key, value)` for each field rather than touch JSON directly:

```java
package com.example.grind;

import java.util.Map;

import com.obsvra.spicegrinder.core.interfaces.AbstractSerializable;

public class Product extends AbstractSerializable {

    private String sku = "";
    private double price = 0.0;
    private boolean inStock = false;

    /** Required -- Convert reflectively constructs this via a no-arg constructor. */
    public Product() {
    }

    public String getSku() { return sku; }
    public double getPrice() { return price; }
    public boolean isInStock() { return inStock; }

    @Override
    protected void populate() {
        add("sku", sku);
        add("price", price);
        add("inStock", inStock);
    }

    @Override
    public void deserialize(Map<String, Object> fields) throws Exception {
        super.deserialize(fields);
        Object skuObj = fields.get("sku");
        Object priceObj = fields.get("price");
        Object stockObj = fields.get("inStock");
        if (!(skuObj instanceof String) || !(priceObj instanceof Double) || !(stockObj instanceof Boolean)) {
            throw new IllegalArgumentException("Product requires string 'sku', numeric 'price', "
                    + "boolean 'inStock'");
        }
        this.sku = (String) skuObj;
        this.price = (Double) priceObj; // MiniJson always parses numbers as Double -- narrow here
        this.inStock = (Boolean) stockObj;
    }
}
```

### Using it from XML

```xml
<ServiceCall name="ProductLookup" url="http://localhost:9000/products" outputs="string"/>

<Convert name="Product1" class="com.example.grind.Product">
    <input name="ProductLookup"/>
</Convert>
```

`FlatFile`/`Database` work identically — point `Convert`'s `<input>` at whichever node produces the serialized string column, e.g. `<FlatFile file="products.csv"/>` with a text column holding one JSON object per row. See `Convert`'s own javadoc for the full expected wire format (exactly what JSON shape the upstream string needs to be, aimed at whoever is producing it — very often someone who will never read this file or any Java source at all) rather than repeating it here.

A downstream custom filter reads the reconstructed object back out via `ObjectDataPoint.getObject()`:

```java
Product p = ((ObjectDataPoint<Product>) input.getNextObservation().getAt(0)).getObject();
```

Two constraints worth knowing before reaching for this: `Convert`'s single `<input>` must be single-dimension (a raw string column, not a raw multi-column row — project down first if your source is naturally multi-column), and the target type needs a genuinely accessible no-arg constructor, since that's what `Convert` reflectively invokes before calling `deserialize()`.

### 9.4 Composite Values with Named Fields (Pro)

The built-in business objects that build a whole value from parts (`Address`, `PersonAssembler`, `Email`, `Phone`, `CreditCard`) output one data point per value. It prints whole (`2607 Chestnut St, Woodville, VA 22749`), and a model can still reach each part: `Extract` replaces it with the fields you name, one column each. A custom component gets the same behavior by producing an `IStructuredDataPoint` (`com.obsvra.spicegrinder.core.interfaces`), which has three parts:

- `fieldNames()`: the field names, in a fixed order. `Extract` checks against this list and prints it in its error messages.
- `get(name)`: one field as its own data point, or `null` for an unknown name. Pick each field's type once and keep it: text for anything whose digits are an identifier (a postal code, an account number), numeric only for real quantities. An empty optional field is an empty string, not `null`.
- `stringValue()`: the canonical, real-world rendering of the whole value.

Two optional extras:

- **Format templates.** Extend `AbstractStructuredDataPoint` (`com.obsvra.spicegrinder.business.datapoints`) instead of implementing the interface directly, and `stringValue()` is rendered from a template such as `{givenName} {surname}`. In `configure()`, call `FormatConfig.getInstance().resolve(owner, type, formatParam, locale, fields)` (`com.obsvra.spicegrinder.core.config`) with your node's own `format` and `locale` parameters. Users can then set or override `format.<type>.<locale>` in `~/.spicegrinder/formats.properties`, or per node with `format`, the same as for the built-ins. In a template, `{field}` inserts a field, and a `[...]` segment is dropped when every field inside it is empty.
- **Load-time field checks.** Implement `IStructuredSource` on the producing generator or filter, returning the field list for the output position that holds the composite. Then a misspelled field in a downstream `Extract` fails when the model loads, not on the first row.

**Reusing a built-in type.** Often you don't need a new data point at all: produce an existing one. `AddressDataPoint` is international in shape (street number, street, unit, city, region, postal code as text, country), even though the bundled `Address` filter only generates US and Canadian data. A custom generator that builds `new AddressDataPoint(10, "Downing St", "", "London", "", "SW1A 2AA", "GB")` works with `Extract` and with templates as-is. An address picks its locale from its country, so these two lines in `~/.spicegrinder/formats.properties` make it print as `10 Downing St, London, SW1A 2AA`:

```properties
format.locale.GB=en_GB
format.address.en_GB={number} {street}[, {unit}], {city}, {postalCode}
```

US addresses keep the bundled US format.

---

## 10. Checklist for a New Component

1. Implement `IGenerator` (or `IFilter`) — or extend the convenient base class.
2. Provide a public constructor that takes a single `String name`.
3. Annotate the class with `@ComponentInfo` (optional but recommended).
4. Annotate configurable fields with `@Parameter`, giving each an explicit `order` (0, 1, 2, ...) so its position in the compact `.sgm` format stays fixed.
5. If your fields are simple scalars, you don't need to write `configure(...)` at all — `IGenerator`'s default reflectively binds every `@Parameter`-annotated field for you. Override `configure` only when you need something beyond that: manual parsing (loop over the `Collection<Pair<String,String>>` and match keys/aliases yourself; see `Skellam` in §5 — the less common pattern in Core, used when a component wants a single combined validation check across multiple fields rather than one), explicit `ReflectiveConfigurer.apply(this, descriptor, settings)` calls if you want the binding to happen at a specific point relative to other logic, input wiring (§9), or extra validation.
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

Once you've profiled it — `ModelAnalyzerApp --isolate --isolate-raw --diagnostic` against a model that exercises it (`--isolate-raw` records nothing unless the diagnostic stream is on, via `--diagnostic` or `instrumentation.properties`) (see the perf-models/README.md pattern this project uses for its own built-ins) — add its weight to `~/.spicegrinder/component-weights.properties`:

```properties
# Fully-qualified class name, not the short/XML name -- unambiguous even if someone else's
# extension package happens to use the same short name for something unrelated.
com.acme.spice.extensions.MyExpensiveGenerator=6.8
```

Note that the `--isolate` functionality has a tendency to significantly overweigh very simple components. If you have every reason to believe your component is simple, just leave it at the default `1.0` weight.

See `docs/component-weights.properties.example` for the full format (this file is also how you'd override a *bundled* weight for your own measured hardware, not just add new ones — the two use cases share the same mechanism). No code change or SpiceGrinder rebuild needed either way; the file is read at first use and merged on top of the bundled default.
