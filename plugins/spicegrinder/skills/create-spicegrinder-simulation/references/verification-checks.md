# Verification checks for a simulation

Used in step 5 of `create-spicegrinder-simulation`. These checks show that the model implements its specification. They cannot show that the specification describes the real system, and the report must say so.

Run what applies; record each check, the expected value, the measured value and the verdict. Expected values you worked out yourself are *expected*; only numbers from a run are *measured*. Without a reachable SpiceGrinder, none of these can be run: say so, give the commands, and do not report results.

## 1. Mechanics (always)

1. **Deterministic run.** Replace every random input with a constant (or a short `Sequence` or `Empirical` list) so that every row can be computed by hand. Compute the first 10 to 20 rows on paper (or in a script that does not share code with the model) and compare. This catches wrong indices, off-by-one rows and misplaced one-row delays more reliably than any statistics.
2. **Conservation.** What comes in equals what goes out plus what remains, in every row: stock end = stock start + received - sold; arrivals = exits + in system; cash end = cash start + inflow - outflow. Check it as a column computed from the output and look at the largest violation (it should be zero to rounding).
3. **Timing of each feedback.** For every loop through `SharedState`, find in the output the row where a cause occurs and the row where its effect appears, and confirm the gap is the delay stated in the design (one row, plus any pipeline cells).
4. **Bounds and signs.** Quantities that cannot be negative are not (stock, queue lengths, waits), quantities with a cap do not exceed it, a `Switch` never lands on an unlisted value.
5. **Reproducibility.** The same seed gives byte-identical output; `--no-seed` runs differ.
6. **Reordering and unrelated nodes.** Moving a node in the file, or adding an unconnected node, does not change a seeded run.

## 1b. Extra mechanics for queues with priority, classes or several resources (`ProcessFlow` with priority, and time-step slot models)

1. **Independent reference.** Write a small plain-code simulator (it must not share code with the model) and compare it with the model on the deterministic variant of check 1.1, every row: arrivals, starts, queue lengths, busy slots, remaining times. Run it again with the resource counts swapped or changed, so a pairing rule is exercised.
2. **Priority order.** In every row, no class starts a job while a more urgent class still has someone waiting.
3. **No interruption.** A job's remaining time only counts down; it is never reset or taken away before it reaches 0.
4. **Per-class conservation.** For each class, cumulative arrivals = cumulative starts + waiting, in every row.
5. **Per-job waits.** From counts, rebuild the k-th arrival and k-th start of each class (first come first served within a class) to get each job's wait; check it against the reference simulator's waits, then use it for the report. Counting people-minutes in the queue and dividing by arrivals is only the Little's-law average; say which one the numbers are.
6. **Redundant levers.** Swap two levers that are supposed to matter (physicians 3 and rooms 8 against 8 and 3). If waits are identical, one resource never binds in this model: report it as a modelling consequence, not a finding.
7. **Starvation.** At high load, look at the lowest class's wait against the highest; report it if it grows without limit.

### Resource sets and vehicles in `ProcessFlow`

- **A replay is cheap.** A `ProcessFlow` event log contains every start, finish, timeout and exit time, and the service and patience draws can be read from `output="entities"` or the event rows. Write a plain-code first come first served simulator (no shared code), feed it the arrival times, service draws and thresholds from the log, and compare every start, finish and escalation time: a model that disagrees has a mechanics bug; agreement proves the queue rules, not the distributions.
- **Queue lengths and utilization by station from the experiment tool:** one call with `--by station` and `--measure "queue=twmean(queue, time)" --measure "busy=twmean(busy, time)"` gives each station its own time-weighted queue length and busy servers, one summary row per station (event rows are unevenly spaced, so a plain mean of `queue` is wrong). Each group is exactly what `--keep "station==K"` would give for that station, so the two can be compared. `--keep` still selects rows first and takes `&&`, `||` and `!`: `--keep "c0 >= 24" --by station` drops a warm-up before the split.

- **Pools:** from the event log, rebuild each pool's units in use (entities between the start of a service that takes it and the finish or station that gives it back) and check free + in use = the pool's size on every row; the free-unit columns must never be negative. A station of unlimited servers needing a pool of c units must give the same rows as a station of c servers.
- **Vehicles:** a car's load never exceeds its capacity; nobody boards before their call or gets off before boarding; between two consecutive rows of one car the distance divided by its speed never exceeds the time between them (no teleporting); every call is boarded and every boarding ends (a call still waiting a long time after the run's busy period means a starved call: look at the longest wait, not only the mean); with one car, capacity 1 and calls far apart, a ride from the board row to the alight row takes exactly the travel time (the alight row is written when the stop begins, so the stop time at the destination comes after it, and the stop at the origin before the next move). An unlimited-cars, unlimited-capacity extreme does not give zero waits: idle cars rest where they last stopped, so a call can still wait for one to travel. Compare dispatch rules on the same seeds, and say when the difference is within the noise.

### Stocks with capacity and flow limits (a battery, a tank, a buffer)

- **Rebuild the recursion outside SpiceGrinder** (a few lines of plain code on the same inputs) and compare every row; a deterministic variant of the model (constants for the random inputs) makes this exact.
- **Conservation each step and over the run:** what came in = what went out + the change in the stock + the losses, with the losses computed from the efficiencies, not from the model's own columns.
- **Bounds and signs:** the stock stays in [0, capacity] and no flow is negative. Floating-point drift can leave a stock at -1e-16 and make the next flow negative: clamp the state, and test "empty" with a small tolerance.
- **Known extremes:** zero capacity or zero rate gives the no-store answer exactly; an unlimited store with no losses curtails nothing; a full store with no demand changes nothing.
- **Monotonicity by measure:** check which measures must improve as a lever improves (the energy bought, the energy wasted) and which need not (the number of hours at the empty bound can rise when a store is allowed to discharge faster); do not recommend by a measure that is not monotone on its own.

### Comparisons and probabilities

- **Run every reading the description allows** (a trigger on stock alone or on stock plus orders; a shelf life counted from receipt or from production) and report the spread between them next to the effect of the levers asked about; if the spread is larger, say so first.
- **Re-run the chosen setting on fresh seeds.** The best cell of a grid is selection-biased; the fresh-seed estimate is the one to quote.
- **A probability needs an interval:** a Wilson or exact binomial interval from the number of independent paths, and a check that the paths are independent (different seeds or `resetEvery` blocks, no shared state). For a rare event, state the number of paths and the number of events observed.
- **Compare with a closed form where the model reduces to one** (pure death, a branching-process extinction probability, the newsvendor loss), by setting the levers to the degenerate case.

## 1c. Checks a replay cannot give

A reference simulator that replays the model's own draws proves the model does what its design says; it cannot find a design that behaves badly. For any model with a dispatch or assignment rule:
1. **Liveness.** For every lever setting, report the maximum wait and the number of customers never served at the end, and trace the worst case row by row. A rule that dithers (assigning a call to a different car each step) passes the replay and shows up as a huge maximum.
2. **Hand scenarios with chosen events.** To test a hand-computed timeline with arrivals at chosen seconds, feed the model a table (`FlatFile` in sequential mode) in place of the random inputs, and compare the hand timeline row by row.
3. **Exact per-passenger waits.** Log the queue position (or the queue index at boarding) and the destination as output columns, so waits and journey times are exact first-come-first-served matches, not reconstructed.
4. **Isolated cases with a closed form.** One passenger, one car parked: the wait and ride must equal the closed-form value for every origin and destination pair tried.

### Controllers and stateful rules (autoscaling, staffing, reorder rules)

- **Hand timelines at the extremes of the signal:** load that is exactly 0 (the controller scales in), exactly saturating (it scales out), a delay of 0, 1 and a long one, a cooldown of 0 and a long one: write the expected action times by hand and compare the rows.
- **A replay of the rule outside SpiceGrinder** on the model's own echoed random inputs, row by row, over several lever settings, including the ones the comparison will use.
- **State plainly what the replay proves.** A replay or a second simulator written by the same author from the same specification proves that the model matches the specification, not that the specification describes the real system; and a replay that only reuses the model's draws proves the rules, not the distributions, so add a check of the distributions (a mean, a variance, a closed form for a simple case).
- **A start state that is not typical:** run a warm-up probe (the first stretch against the rest); a model that starts every machine new, or every stock full, can be biased for the whole horizon, and the report must say by how much.
- **Rank reversals between the user's own measures:** compare the settings on each measure the user asked for and say where they disagree (the setting with least unavailable time is not always the one with fewest missed customers).

## 2. Against theory (when part of the model reduces to a known system)

Strip the model down to a case with a closed form, check it, then restore the rest. On a time step, service times are whole numbers of steps: a time of mean m rounded up to whole steps has mean about m + step/2, so compare with the closed form at the discretized mean (and show both), not only the continuous one. Always report standard errors; successive rows of a queue or a stock are correlated, so use batch means (means of 20 to 100 long batches), not the row-to-row spread.

| Reduced case | Check |
|---|---|
| M/M/1: Poisson arrivals rate lambda, exponential service rate mu | Wq = rho / (mu - lambda), W = 1 / (mu - lambda), P(wait) = rho |
| M/M/c | Erlang C |
| M/D/1 | Wq = rho / (2 mu (1 - rho)) |
| Open Jackson network | Station arrival rates from the traffic equations; each station as M/M/c |
| Non-preemptive priority M/G/1 (Cobham) | `Wq_k = W0 / ((1 - sigma_{k-1})(1 - sigma_k))` with `W0 = sum(lambda_i E[S_i^2]) / 2` and `sigma_k` the load of the first k classes; without priority every class waits `W0 / (1 - rho)` |
| Little's law | Time-average number in system = arrival rate x mean time in system, on any path |
| One-period inventory (newsvendor) | Expected shortfall and fill rate from the demand distribution |
| Random walk with drift, no feedback | Mean and variance of the balance after n steps |
| Markov chain | Long-run state frequencies from the stationary distribution |

For `ProcessFlow`, the library's own validation covers M/M/1, M/M/2, M/D/1 and an open Jackson network; reproduce the one nearest your model with your parameters in place of trusting the component.

## 3. Behaviour (always, with replications)

1. **Replicate.** Run enough independent seeds (at least 30, more for tails) of the horizon the user cares about; quote each measure as a mean with an interval across replications. A single run is one trajectory.
2. **Warm-up.** For a long-run measure, plot or tabulate a measure by block of rows and check the early blocks against the later ones; drop the rows until they agree and say how many.
3. **Stability.** For a queue, utilization below 1 at every station (arrival rate x visit ratio x mean service / servers). A unstable system gives numbers that grow with the run length; say so rather than reporting them.
4. **Lever sanity.** Turn each lever the user will use one at a time and check the direction: more servers do not lengthen waits; a higher reorder point does not raise stock-outs; a higher price does not raise demand. A wrong direction is a bug (or a surprise to explain to the user).
5. **Extremes.** Run the lever at zero and at a very large value: no capacity (everything waits or is lost), unlimited capacity (no waits, no losses). The model should reproduce the trivial answer.
6. **Sensitivity of the assumptions.** Vary each placeholder by a plausible amount and report the ones that move a measure materially; those are the inputs worth the user's effort to pin down.
7. **Feedback stability.** For a loop with a response strength, scan it: does the system settle, oscillate or swing? Report the regime for the user's setting and where it changes.

## 3b. Scenario comparisons

Use the `experiment` command for the lever grid: a baseline, paired differences on the same seeds, a table of means with intervals, and a fresh-seed re-run of the setting you recommend. A comparison that cannot be run interactively (nobody to ask) records its questions with defaults in the specification and proceeds.

## 4. What to write down

For the report, one line per check: *what, expected, measured (rows and seed, or replications), pass/fail*. Say which checks were not run and why. End with the sentence the user needs: the model matches its specification to the extent shown; whether the specification is right is the user's judgement, and the placeholders, simplifications and omissions listed above are where it is most likely to differ from the real system.
