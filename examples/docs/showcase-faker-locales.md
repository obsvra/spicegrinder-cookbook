# Showcase: Multi-Market Order Data, on Faker-Built Customer Pools

*Pro-tier showcase. Uses `FlatFile` and string-typed `Constant`, both Pro; the order economics are Free-tier. Every row on this page was produced by running the commands shown.*

## The situation

You're testing an EU order pipeline. Customers come from Germany, France, and Spain, roughly 50/30/20 by volume, and you need their names and addresses to look right for each market — because a French name in a German postcode is exactly the kind of thing that makes a demo fall flat and lets encoding bugs hide.

Here's the honest problem: **SpiceGrinder's bundled business-object data is US-centric.** Given names come from SSA records, surnames from the 2010 US Census, and `city_state_zip.csv` is GeoNames' US postal file. There is no `de_DE` name data in the box.

Faker has dozens of locales. So use Faker for the vocabulary, and SpiceGrinder for everything that has to hold together.

## Why not just use Faker

Faker will happily give you a German name and a German city. What it won't do is make the market mix come out at 50/30/20, keep the postcode consistent with the customer who has it, or attach an order value distribution to the customer it belongs to. Each `fake.name()` and `fake.city()` call is independent — you'd write the loop that holds them together, and then write it again for the next schema.

That loop is the thing worth deleting.

## The pattern: Faker for vocabulary, SpiceGrinder for structure

Generate the pools **once** at build time, commit them, then generate orders against them.

```
Faker  ──(build time, once)──▶  customers-{de,fr,es}.csv  ──(generate time)──▶  SpiceGrinder
```

### Step 1 — build the pools

```python
import csv
from faker import Faker

LOCALES = {
    "de_DE": ("customers-de.csv", "DE"),
    "fr_FR": ("customers-fr.csv", "FR"),
    "es_ES": ("customers-es.csv", "ES"),
}

for locale, (path, cc) in LOCALES.items():
    fake = Faker(locale)
    Faker.seed(42)                       # reproducible pool
    seen, out = set(), []
    while len(out) < 200:
        name = fake.name()
        if name in seen:
            continue
        seen.add(name)
        # Country-prefix the postcode: a real European convention, and it keeps
        # the cell text. (A bare "09010" also works if the model lists the
        # column in FlatFile's textColumns.)
        out.append([name, fake.city(), f"{cc}-{fake.postcode()}"])
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["FULL_NAME", "CITY", "POSTCODE"])
        w.writerows(out)
```

Two hundred customers per market is plenty. A pool is a *vocabulary*, not a dataset — the volume comes later, from the model.

### Step 2 — the model

Same `Mix` → branch → `FlatFile` shape as the shipped `samples/pro/person-model.xml`. The market label and the customer are chosen inside the same branch, so they can never disagree:

```xml
<dataset seed="42">
    <root node="Order"/>
    <nodes>
        <Append name="Order">
            <input name="Customer"/>
            <input name="ItemCount"/>
            <input name="OrderValue"/>
        </Append>

        <Mix name="Customer">
            <input name="GermanBranch" weight="0.50"/>
            <input name="FrenchBranch" weight="0.30"/>
            <input name="SpanishBranch" weight="0.20"/>
        </Mix>

        <Append name="GermanBranch">
            <input name="DeLabel"/>
            <input name="GermanPool"/>
        </Append>
        <Constant name="DeLabel" value="DE" type="string"/>
        <FlatFile name="GermanPool" file="customers-de.csv"
                  mode="unweighted" skipHeader="true"/>

        <!-- FrenchBranch and SpanishBranch follow the same shape.
             Abridged here for reading; the model won't load until all three
             branches named by the Mix above actually exist. -->

        <Poisson name="ItemCount" lambda="2.2"/>
        <Lognormal name="OrderValue" mu="4.1" sigma="0.8"/>
    </nodes>
</dataset>
```

### Step 3 — run it

```bash
grind --count 10 orders-multi-locale.xml
```

```
FR,Hortense Diallo,Bertrandboeuf,FR-95584,3,29.534151471601852
ES,Nicodemo Cabello Barrera,Toledo,ES-23236,3,15.782629571402822
ES,Ruperta Castillo Barreda,Sevilla,ES-09010,4,109.64989566069686
FR,Pierre Teixeira,Saint Frédéric-les-Bains,FR-80263,2,88.14631181927025
DE,Edelgard Wulf-Langern,Hersbruck,DE-66270,1,140.59989142221843
```

Market, customer, and postcode always agree. Accented characters survive the round trip intact.

## Does the mix actually hold?

Worth checking rather than asserting. Over 100,000 rows, against the declared 50/30/20:

```
DE   50162   50.16%
FR   29807   29.81%
ES   20031   20.03%
```

That's the kind of claim you should make a tool prove. Generate a hundred thousand rows and count them yourself.

## What about Mockaroo?

Same pattern, and its free tier is a better fit here than it first looks. Mockaroo caps free downloads at 1,000 rows per file — useless for bulk generation, entirely sufficient for a *vocabulary*. Build a 1,000-row customer pool in its web UI, export CSV, commit it, and point `FlatFile` at it. Volume comes from the model, not from the pool, so the row cap never binds.

We haven't run that end to end here (it needs an account), so treat it as the documented equivalent rather than a measured result.

## Doing this on Free, without the pool

`FlatFile` is Pro, so the model above needs Pro. But the Free build can get you most of the way there, and it's worth knowing how before you decide you need to upgrade.

Free is numeric-only, which means it can't hand you a name — but it *can* hand you the **row number** of a name. Emit a market code and an index, and do the lookup yourself downstream:

```xml
<dataset seed="42">
    <root node="Order"/>
    <nodes>
        <Append name="Order">
            <input name="Market"/>
            <input name="CustomerRow"/>
            <input name="ItemCount"/>
            <input name="OrderValue"/>
        </Append>

        <!-- 0 = DE, 1 = FR, 2 = ES -->
        <Categorical name="Market" weights="0.50,0.30,0.20"/>

        <!-- row index into that market's 200-row pool -->
        <ToInteger name="CustomerRow" mode="floor">
            <input name="RowDraw"/>
        </ToInteger>
        <Uniform name="RowDraw" min="0" max="200"/>

        <Poisson name="ItemCount" lambda="2.2"/>
        <Lognormal name="OrderValue" mu="4.1" sigma="0.8"/>
    </nodes>
</dataset>
```

Six nodes, every component Free, and `Categorical` does the weighted market draw natively by emitting a 0-based index.

```
1,134,3,29.534151471601852
2,32,3,15.782629571402822
2,196,4,109.64989566069686
1,16,2,88.14631181927025
0,88,1,140.59989142221843
```

Join those against the pools — a SQL join, a pandas merge, ten lines of shell — and you have the same dataset.

**Literally the same dataset.** Market `1` row `134` is Hortense Diallo; row 1 of the Pro output is Hortense Diallo. Market `2` row `32` is Nicodemo Cabello Barrera; so is Pro's row 2. The item counts and order values are byte-identical between the two models. The Pro version isn't generating better data here — it's doing the join for you, inside the model, at generate time.

**Where this stops working**, which is the honest part: it works cleanly because the customer is *terminal* — nothing downstream in the model depends on who they are. The moment a looked-up value needs to participate in generation, the index trick collapses. You can't branch on a customer's country to pick a tax rule, derive an email from the name you drew, filter on an attribute you haven't resolved yet, or compose the row into a business object. The index is an opaque number until it leaves SpiceGrinder, and anything the model needs to *know* has to happen before that.

If your pool value is an identity you attach and carry, Free does this today. If it's an input to the rest of the model, that's what `FlatFile` is for.

## Gotchas

**Numeric-looking cells become numbers unless you say otherwise.** Faker produces `05130` in France and `09010` in Spain; read as numbers, they lose their leading zero (`9010.0`), and quoting the cell doesn't change that. Two fixes. List the column in `FlatFile`'s `textColumns` (a 0-based index, or a header name with `skipHeader="true"`), which keeps every cell in it as text. Or make the cell non-numeric, as the pools above do by country-prefixing it, which is a real European postal convention anyway. Verified: with the prefix, the same seed produces the identical customers and order values, with `ES-09010` intact. Only the representation changed.

**Seed Faker too.** `Faker.seed(42)` makes the pool reproducible. It matters less than you'd think — you commit the pool, so the artifact is fixed regardless — but it means a teammate regenerating the pool gets the same file rather than a confusing diff.

**Faker repeats.** Its name lists aren't large, so a 200-row pool needs deduplication or you'll get collisions. The script above tracks `seen` for exactly that reason.

**Pool cardinality is not row count.** 200 customers sampled a million times is still 200 distinct people. If your test needs a million *distinct* customers, build a bigger pool.

## Honest limits

- **`FlatFile` and string `Constant` are Pro.** The order economics are Free-tier; the customer spine isn't.
- **For US data, you probably don't need Faker.** SpiceGrinder's bundled pools are real weighted Census and SSA distributions, which is better than Faker's uniform sampling for that market. This pattern earns its keep on locales we don't ship, not as a general replacement.
- **Faker owns the vocabulary, and that's a dependency.** If Faker's `de_DE` city list is thin or quirky, your pool inherits that. Look at the pool before you commit it.

## Files

- `samples/pro/software/orders-multi-locale.xml` — the model
- `samples/pro/software/build-pools.py` — the Faker pool builder
- `samples/pro/software/customers-{de,fr,es}.csv` — the committed pools
- `samples/pro/software/orders-multi-locale.csv` — seed-tagged sample output

*Built with Faker 40.38.0, 2026-09-13.*
