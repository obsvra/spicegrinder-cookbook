![spicegrinder-icon](assets/spicegrinder-icon.png)
# Reviewing a Fitted Model

> © 2026 Obsvra. This document describes SpiceGrinder and is provided to help you evaluate and use it. It is not a license to reproduce, adapt, or use this material to build a competing product or service. Full terms: the SpiceGrinder EULA.

A model fitted to real data, whether by hand or by an AI agent following the `fit-model-to-sample` skill, gets the measurable things right: each column's distribution, the spikes and popular values, how columns move together. Some things no fitting procedure can know from a sample alone, and they are where a person's review pays off. This guide lists them, in the order worth checking, with how to check each and what to do about it. The examples come from SpiceGrinder's own evaluation of the fit skill on real public datasets (taxi trips, flights, retail sales, earthquakes, Medicare billing).

## Start with `compare`

Run `compare` on the model and the sample it was fitted to (see [ModelCompareApp.md](ModelCompareApp.md)):

```
compare --seed 1 model.xml sample.csv
```

Fix every high-severity finding. Read the medium ones: most are judgment calls this guide covers. Then keep going: **a clean `compare` doesn't mean the output is indistinguishable from real data.** `compare` checks columns and pairs of columns. In the evaluation, a Medicare model passed `compare` with no findings on three seeds, and a classifier could still reliably tell its rows from real ones. The reasons are below.

## 1. Rows that share entities

**What to look for.** Real transactional data repeats its entities: a provider bills several services, a customer places several orders, a vehicle makes several trips. So an identifier or address column has far fewer distinct values than rows. A model that makes a new entity on every row gets every column's distribution right and still looks nothing like the real table: in the Medicare example, every generated provider ID was unique, against 23% in the real sample.

**How to check.** `compare` flags it as a `repetition` finding: a text or identifier column whose number of distinct values differs a lot from the sample's, over the same number of rows.

**What to do.** Decide whether the repetition matters for what the data is for. It does if anything downstream groups rows by entity: joins, per-customer totals, deduplication, fraud rules. If so, the `Pool` filter draws an entity once and repeats it on a fitted number of rows: an `entity` input for the entity's fixed columns, a `count` input (fitted from the sample's rows per identifier) for how many rows it gets, and `interleave` for whether an entity's rows come out together or spread out. `Switch` keyed on the entity attribute (for example specialty) makes per-row values depend on it. If entities of different kinds have different numbers of rows (a radiology practice bills far more services than a chiropractor), the count can depend on the entity: `countColumn` takes it from a column of the entity, such as a `Switch` on the kind. Otherwise, document that each row is independent.

## 2. The extreme tail

**What to look for.** The largest values: p95, p99 and the maximum. A distribution that fits the bulk well can still be far off at the top, and a few dozen real rows are all the evidence there is for the extreme. Every dataset in the evaluation fell short at p99 somewhere.

**How to check.** `compare`'s tail findings, and the maximum of a large generated sample (`grind --count 100000`) against what's physically or commercially possible.

**What to do.** For a heavy-tailed column (payments, claim sizes, counts), fit the body and the tail separately (the fit skill's spliced-tail recipe: a truncated body below a threshold, a `Pareto` above it, joined with `Mix`). Then decide on a cap: a generated taxi trip of 2,300 miles is a value no real table holds. `Truncate` enforces a cap. Where the cap should be is a domain decision the sample can't make.

## 3. Spikes and popular values

**What to look for.** Exact values that hold a notable share of rows: defaults (a duration recorded as 30 when nobody entered one), list prices, round amounts, a count's minimum. The fit skill models the ones it finds. Check two things it can't: whether each spike is real, and whether any is missing.

**How to check.** `compare`'s frequent-value findings. For a spike the model reproduces, ask whether it's a feature of the domain or of this one sample. For one it misses, look for a mechanism: in the taxi data, a tip of exactly $2.00 was on 5.5% of trips, and the model produced 1.6%, because nothing in the data explained it (a preset tip button would).

**What to do.** Keep or drop spikes with that knowledge. A popular value can be replayed into the model as long as the column is a numeric measurement and not personal data (see Privacy below).

## 4. Rules between columns

**What to look for.** Relationships that hold in every row, not just on average: cash trips never have a recorded tip, items shipped never exceed items ordered, a total equals its parts, a count never goes below a published minimum. Correlation reproduces a relationship most of the time; a rule has to hold every time.

**How to check.** Filter the generated output on the rule's condition and count violations. The fit skill looks for these and builds the ones it finds into the model (a branch per payment type, a `Calculate` that derives one column from another), and lists them in its notes.

**What to do.** Confirm each rule the model enforces is real, not a quirk of the sample, and add any the sample didn't show. Only someone who knows the domain can do either. A rule that depends on a category (cash trips never tip) can be built with `Switch` on that category.

## 5. Small groups

**What to look for.** Sub-populations too small to model with confidence from the sample: long-haul taxi fares (under 2% of trips), specialties with a handful of rows each. The fit skill won't split out a group under about 5% of rows, on purpose, because doing so fits noise.

**How to check.** The fit's notes list the splits it considered and why it stopped. `compare` won't flag a small group folded into a larger one.

**What to do.** If a small group matters to your use (edge-case testing often lives there), model it by hand: its own `Mix` branch with a weight from the sample, parameters from domain knowledge rather than a few dozen rows.

## 6. Formats and precision

**What to look for.** Values that must look exactly like the real ones to downstream code: ZIP codes with their leading zeros, whole numbers without `.0`, money to the cent, codes as text.

**How to check.** `compare`'s format findings catch most of these.

**What to do.** Round to the data's own precision (`Calculate`, `ToInteger`), and keep code columns as text (`FlatFile`'s `textColumns`). Check the output against whatever will consume it, not only against the sample.

## 7. Privacy

**What to look for.** Every column whose real values went into the model. The fit skill replays values only when the column is a numeric measurement and only for popular values (at least 0.2% of rows and 10 occurrences), or when it's a classification code shared by many records (a procedure code, a provider specialty). It never replays identifiers, names, addresses, dates, or free text, and its notes list every replayed column.

**How to check.** Read the replay list in the fit's notes, and look through the model file for value lists (`Empirical`, `Categorical`, tables read by `FlatFile`). Anything that points to one person, account or place shouldn't be there. Run the `pii-audit` skill if the sample may hold personal data.

**What to do.** Remove anything that fails that test. Expect synthetic identities to look less real than real ones: generated company names are generic, and generated addresses don't repeat the way a real provider list does. That's the price of not copying real ones.

**Known limitation: entity profiles shared by 10 or more.** When rows share entities (see section 1), the fit skill may reproduce whole entity profiles from the sample, such as a provider's specialty, number of rows and whether it's an organization, but only combinations that at least 10 of the sample's entities share. Any table or branch that depends on the entity follows the same rule, so a specialty with fewer than 10 providers gets no count distribution of its own. Row counts are grouped into ranges first. What this does and doesn't protect:
- **Protected:** a profile unique to one entity, or to a handful, never reaches the model. Rare specialties and unusual row counts are fitted in a pooled group instead of copied, and the identity columns (identifiers, names, addresses) are always synthetic.
- **Not protected:** a profile shared by 10 or more real entities is reproduced exactly, with its real frequency. Anyone who knows those 10 learns nothing new about any one of them from the model, but they can see that the profile exists in the source data and how common it is.
- **Not protected:** attributes that aren't identifying by themselves can narrow things down when combined with outside information, such as a public directory that lists every provider of a rare specialty in one small state. The 10-entity minimum limits this, but it can't rule out every combination with knowledge the model never saw.
- **Not checked automatically:** the minimum is a rule the fit skill follows and states in its notes (how many entities and rows came from replayed profiles). `compare` doesn't verify it, and a model written or edited by hand isn't held to it. Check the notes, and check any `FlatFile` table with a row per profile for a weight of at least 10 on each row.

**Why 10:** it's the same minimum the skill uses for replaying popular numeric values, and close to the 11 that CMS applies to its own published Medicare cells. It gives up accuracy on rare groups, the smallest specialties and the providers with unusually many rows, in exchange for never copying a profile that points to one entity. Raise it for more sensitive data, and ask for it in your prompt to the fit skill.

## 8. Model size and edition

A fitted model's size grows with the domain: every category that changes the shape of other columns (a payment type, a magnitude scale, a fare regime) adds a branch, and every branch adds nodes. SpiceGrinder Free allows 20 nodes, which covers a lot: single-table models with several correlated columns, spikes and mixtures fit comfortably. As the modeled domain grows in complexity and in the number of relationships that matter, the odds that the model needs SpiceGrinder Pro go up sharply, even when every component in it is a Free one and every column is numeric. In the evaluation, the simpler synthetic dataset fit in Free; the real-world ones, with their branches, needed Pro.

## Checklist

| Check | Where it shows up | Who decides |
|---|---|---|
| Rows that share entities | `compare` repetition findings | whether downstream code groups rows by entity |
| Extreme tail and caps | `compare` tail findings, a large `grind` | the realistic maximum |
| Spikes, real and missing | `compare` frequent-value findings | whether each has a mechanism |
| Rules between columns | the fit's notes; filtering the output | whether each rule is real |
| Small groups | the fit's notes | whether the group matters for your use |
| Formats and precision | `compare` format findings | the downstream consumer |
| Privacy | the fit's replay list; the model's value lists | anything pointing to one person, account or place |
| Size and edition | the model's node count | Free or Pro |
