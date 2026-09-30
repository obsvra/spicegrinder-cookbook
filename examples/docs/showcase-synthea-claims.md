# Showcase: Claims at Volume, on a Synthea Population

*Pro-tier showcase. Uses `FlatFile`, which is a Pro component; the claim economics are Free-tier. Every number and every row on this page was produced by running the commands shown.*

## The situation

You're testing a claims pipeline — adjudication, pricing, an 837 ingest, a reserving model. You need members who look real, and you need a lot of claims about them.

Synthea already solves the first half, better than you could. It's an open-source synthetic patient generator from The MITRE Corporation, with disease modules built by clinicians and calibrated against CDC and NIH statistics. If you work in healthcare data, you probably already have it installed.

So use it. This showcase is about what to do with its output, not about replacing it.

## Why not just use Synthea's claims

Synthea *does* export claims — `claims.csv` and `claims_transactions.csv`. If those fit your test, you're done, and you don't need us. Here's what we actually measured on a 45-patient Massachusetts run, which will tell you whether they fit:

**Volume is a function of population, not a knob.** 45 patients produced 4,687 claims — about 104 each. A separate 10-patient run averaged 63 each; the ratio moves with the age mix of the population, because older patients have more history to simulate. Either way it isn't a setting you control: claims exist because Synthea simulated the encounters that generated them. A million claims means somewhere in the neighborhood of ten to sixteen thousand patients, and you wait for every one of those lifetimes.

Measured on this machine: **10 patients took 7.34 seconds and produced 630 claims — about 86 claims/second.** A million claims is therefore around three hours.

That is not a criticism of Synthea. It's simulating decades of medical history per person, which is an enormously harder computation than emitting a row. It's simply a different operation from the one you need when you want volume.

**The schema is Synthea's.** Its `claims.csv` carries `DIAGNOSIS1`–`DIAGNOSIS8`, `STATUS1`, `STATUSP`, `OUTSTANDING1`, `LASTBILLEDDATE1` — an athenahealth-flavored billing shape. Useful, and probably not your payer's schema.

**The distributions aren't yours.** Synthea's costs come from its care model. You can't tell it "make severity log-normal with mu=8" or "put 30% of claims in the high-cost band so the stop-loss logic gets exercised." Epidemiological realism is the right goal for research and the wrong one for testing, where you often need edge cases at rates that would never occur naturally.

## The pattern: Synthea for the spine, SpiceGrinder for the volume

Generate the population **once**, commit it, then generate claims against it as often as you like.

```
Synthea  ──(build time, once)──▶  member-pool.csv  ──(generate time, always)──▶  SpiceGrinder
```

The committed pool is the important part. It makes the member population a reviewable, diffable repo artifact, and it means reproducibility doesn't depend on re-running Synthea or trusting it to be deterministic — the file is fixed.

### Step 1 — generate a population

```bash
java -jar synthea-with-dependencies.jar -p 40 -s 42 \
  --exporter.csv.export=true --exporter.fhir.export=false \
  --exporter.baseDirectory=./synthea-out Massachusetts
```

### Step 2 — project it down to what a claim actually needs

`patients.csv` has 28 columns. A claim line needs four.

```python
import csv
rows = list(csv.DictReader(open("synthea-out/csv/patients.csv")))
alive = [r for r in rows if not r["DEATHDATE"]]
with open("member-pool.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["MEMBER_ID", "BIRTHDATE", "GENDER", "STATE"])
    for r in alive:
        w.writerow([r["Id"], r["BIRTHDATE"], r["GENDER"], r["STATE"]])
```

Do this even if you think you might want the other columns later. Two reasons, one obvious and one not: carrying 28 dimensions to use 4 costs you on every single row, and several of Synthea's columns are numeric-looking strings that will not survive the trip. See **Gotchas** below.

### Step 3 — the model

```xml
<dataset seed="42">
    <root node="ClaimLine"/>
    <nodes>
        <Append name="ClaimLine">
            <input name="Member"/>
            <input name="ServiceUnits"/>
            <input name="BilledAmount"/>
        </Append>

        <FlatFile name="Member" file="member-pool.csv"
                  mode="unweighted" skipHeader="true"/>

        <Poisson name="ServiceUnits" lambda="2.5"/>
        <Lognormal name="BilledAmount" mu="6.4" sigma="0.9"/>
    </nodes>
</dataset>
```

`FlatFile` draws a **whole row atomically**, which is the mechanic that makes this work: the member id, birthdate, gender, and state on any given claim line always belong to the same person. There's no join to get wrong and no post-hoc consistency pass.

### Step 4 — run it

```bash
grind --count 10 claims-from-synthea.xml
```

```
4aaa0001-3832-cc52-e2f3-47aad08f4284,2006-01-17,M,Massachusetts,4,269.411696423658
6f45f2e9-a617-570a-8867-dec1260088bb,2013-06-07,M,Massachusetts,2,393.7695537208169
ba419d35-0dfe-8af7-347c-eebf02485a56,1925-08-30,F,Massachusetts,7,1178.44857884471
f32a088b-988b-d7d5-008b-89ea4ed1fc48,2006-07-27,M,Massachusetts,1,207.4297691008044
46976cf7-b0bf-be20-39a5-9f425a52886d,2007-08-25,F,Massachusetts,1,1510.9624542853426
```

Real Synthea member ids. Claim economics you control. Members recur across claim lines the way they do in a real book of business, because the pool is sampled with replacement.

## What this buys you

**Volume decoupled from population.** One million claim lines against the 40-member pool:

```
Emitted 1000000 observation(s) in 1.558s (641848.5 obs/s)
```

**1.6 seconds, against roughly three hours** for the same claim count out of Synthea alone — and the SpiceGrinder run needs no additional patients, because volume and population are now independent knobs.

**Distributions you set.** `lambda` and `mu`/`sigma` are yours. Want a catastrophe year? Change `mu`. Want the high-cost band exercised at 30% instead of its natural rate? That's a `Mix`.

**Reproducibility end to end.** Same model, same seed, same pool, same bytes — on your laptop, in CI, on a colleague's machine. Run it twice and diff it.

**No PHI at any point.** Synthea's output is synthetic. SpiceGrinder never ingests anything else. There is no step in this pipeline where real patient data exists.

## Doing this on Free, without the pool

`FlatFile` is Pro. The claim economics in this showcase were always Free — so the only Pro-gated part is resolving the member. Free can still give you the **row number**:

```xml
<dataset seed="42">
    <root node="ClaimLine"/>
    <nodes>
        <Append name="ClaimLine">
            <input name="MemberRow"/>
            <input name="ServiceUnits"/>
            <input name="BilledAmount"/>
        </Append>

        <ToInteger name="MemberRow" mode="floor">
            <input name="RowDraw"/>
        </ToInteger>
        <Uniform name="RowDraw" min="0" max="40"/>

        <Poisson name="ServiceUnits" lambda="2.5"/>
        <Lognormal name="BilledAmount" mu="6.4" sigma="0.9"/>
    </nodes>
</dataset>
```

Five nodes, all Free:

```
27,4,269.411696423658
35,2,393.7695537208169
12,7,1178.44857884471
```

Row 27 of `member-pool.csv` is `4aaa0001-3832-cc52-e2f3-47aad08f4284` — the member the Pro model drew first, with the same 4 service units and the same $269.41. Row 35 is the Pro model's second member. The two models produce the same claims; one of them makes you do the join.

Match the `Uniform` max to your pool size, and re-check it whenever you regenerate the population — a 40-row pool with `max="45"` will silently emit indices that don't exist, and nothing in SpiceGrinder can catch that because it never sees the file.

**Where this stops working:** the member is terminal here — no part of the model depends on who they are. If you wanted claim severity to vary by the member's age, or the diagnosis mix to depend on their sex, the index can't do it. Those values have to be inside the model for the model to use them, which is `FlatFile`.

## Gotchas

Found while building this, all real:

**Numeric-looking cells become numbers unless you say otherwise.** This bites Synthea data hard. `ZIP` and `FIPS` are the offenders: read as numbers, `01109` becomes `1109.0`, and a Massachusetts run that emits `00000` gives you `0.0`. Quoting the field doesn't change that. If you need these columns, list them in `FlatFile`'s `textColumns` (0-based indexes, or header names with `skipHeader="true"`) and they stay text, leading zeros intact. This showcase drops them during projection because the claim lines don't need them.

**`Database` needs an explicit `ORDER BY`.** If you feed from a database rather than a file, note that `SELECT * FROM t` has no guaranteed row order in SQL. A frozen table can still hand back rows in a different order across runs or engines, which quietly breaks reproducibility under `mode="sequential"`.

**`ServiceCall` against a live endpoint is not reproducible**, unless the service itself is deterministic. Calling a data-generation API at generate time feels natural and costs you the determinism guarantee. Generate at build time, commit the artifact, read the file.

**XML comments can't contain `--`.** Documenting the Synthea command line inside the model file fails to parse, because the flags are double-hyphenated. Put the command in your README.

**Poisson draws zeros.** `lambda="2.5"` will produce claim lines with 0 service units, which may or may not be valid in your schema. That's a modeling decision, not a bug — shift the distribution or filter if your pipeline rejects them.

## Honest limits

- **`FlatFile` is Pro.** The claim economics here are Free-tier, but the member spine isn't. Free is numeric-only and capped at 20 nodes, so this specific pattern needs Pro.
- **The pool is finite.** 40 members sampled a million times is 40 distinct people. Size the population to the cardinality your test actually needs.
- **Synthea still owns clinical realism.** Nothing here generates conditions, medications, or encounters. If you need those, take them from Synthea too — this pattern extends to any of its exports, not just `patients.csv`.

## Files

- `samples/pro/health/claims-from-synthea.xml` — the model
- `samples/pro/health/member-pool.csv` — the projected 40-member pool
- `samples/pro/health/claims-from-synthea.csv` — seed-tagged sample output

*Synthea run with `synthea-with-dependencies.jar` (master-branch-latest), 2026-09-13. Timings measured on an Apple Silicon laptop; your numbers will differ, and the reproduce commands are above so you can get your own.*
