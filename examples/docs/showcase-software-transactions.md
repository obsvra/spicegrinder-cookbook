![spicegrinder-icon](../../docs/assets/spicegrinder-icon.png)
# Showcase: Transaction volume by customer profile

**Model file:** `samples/software/transaction-volume-profiles.xml`  
**Tier:** Free  
**Root:** `Transaction` → `[count, amount]` from retail or corporate profile

## Problem statement

Load tests and fraud rules need realistic **mixes** of retail vs corporate behavior. Production logs may contain account identifiers and only describe yesterday’s traffic. Launch planning and “10× peak” tests require synthetic volume that is not bound to historical seasonality or production access.

## Modeling steps

1. **Retail profile** — `Append(Poisson(λ=12), Lognormal(...))` for count + amount.
2. **Corporate profile** — lower count, higher amount.
3. **Mix** — weights 4:1 retail:corporate for portfolio traffic shape.

## Results (how to reproduce)

```bash
java -cp target/spicegrinder-*-free.jar com.obsvra.spicegrinder.tools.Grind --count 10 samples/software/transaction-volume-profiles.xml
```

Observations alternate profiles by weight; retail dominates count, corporate dominates large amounts when selected.

## How Pro-tier can go further

| Feature | What it models |
|------|-----------------|
| **Perturb** on Corporate | Fraud rings / outage bursts |
| **Custom DataPoint** | `TransactionEvent` for downstream services |
| **Import** | Separate retail/corporate library models |
