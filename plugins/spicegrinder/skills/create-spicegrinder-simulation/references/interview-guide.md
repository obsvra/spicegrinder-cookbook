# Interview guide and specification template

Used in step 2 of `create-spicegrinder-simulation`. The specification is the product of the interview; the question bank is for filling it in with as few questions as possible.

## The specification

Fill in every field. Mark each as **user** (stated), **inferred** (you concluded it; say from what) or **open** (needs an answer or a placeholder).

| # | Field | What to write |
|---|---|---|
| 1 | Purpose | The decision or question the simulation serves, in the user's words ("how many lanes do we need for waits under five minutes"). Everything else is judged by whether it matters to this. |
| 2 | Measures | The numbers the user will read off: averages, percentiles, probabilities (of running out, of waiting), time series. Say whether averages over time, per customer or at the end of the run. |
| 3 | Entities | What moves through the system (customers, orders, patients, units), and any attributes that change what happens to them (type, size, priority). |
| 4 | Resources | What is limited and shared (servers, rooms, stock, cash, capacity), how many, and whether they differ. |
| 5 | State | Every quantity that carries from one moment to the next, with its starting value. |
| 6 | Events and time | What happens, in what order, and the real time unit. Whether time is naturally a fixed step (a day, a month) or irregular (events). |
| 7 | Row definition | What one output row is: a time step, a customer, or an event. Chosen with the user, from 6 and 2. |
| 8 | Inputs | Each exogenous random quantity (arrival gaps, demand, service times, failures): its distribution and parameters, and where the numbers came from (data, estimate, placeholder). |
| 9 | Rules | Every decision the system makes: reorder, route, assign, throttle, reprice. State the trigger and the action, and what the rule is allowed to see (and how old that information is). |
| 10 | Loops | Where an output feeds back into an input or rule; the real delay around each loop. |
| 11 | Horizon | Run length, whether the system starts empty or in a steady state, and warm-up to discard. |
| 12 | Replications | How many independent runs, since one run is one trajectory. |
| 13 | Levers | The inputs the user will change in what-if runs. They become `declare`s. |
| 14 | Out of scope | Mechanisms the user accepts leaving out, in their words. |

## Question bank, in priority order

Ask in this order, stopping when the answers stop changing the design. Give each question a recommended default.

**A. Purpose and measures (always, unless already clear)**
- What decision will this inform, and what number would you look at to make it? *Default: the average and the 95th percentile of the thing you named, plus the probability of it going wrong.*
- Is it the long-run average that matters, or a particular day or period (a rush hour, a launch week)?

**B. Structure (each answer can change the component)**
- *Time:* is it natural to think in steps of fixed length (days, months) or in individual events (a customer arrives, a job finishes)? *Default: steps for stock and cash systems, events for queueing systems.*
- *Queues:* is service first come first served? Can anyone be served ahead of others (priority by a class), interrupted, or skipped? *Priority by a class is in `ProcessFlow` (no interruption, no ageing); interruption, ageing and skipping are outside it: say so and offer options.*
- *Stocks (a battery, a tank, a buffer, cash):* the capacity and the flow limits in and out, losses on the way in and out, what "empty" and "full" mean (a threshold, and whether to count the hours or the energy), what happens to a surplus or a shortfall (curtail, export, buy, lose a sale), the time step against the fastest flow, and what the user will vary. Ask which measure decides, since some (hours empty) do not improve as a lever improves.
- *Perishable or ordered stock:* is the reorder trigger on-hand stock or on-hand plus on-order (inventory position)? When in the day are orders placed, delivered and sold against each other? How is shelf life counted (days since receipt, or since production; can a shipment arrive partly spoiled)? Is a short shipment known when the order is placed? What does the total cost include (holding, ordering, expiry, lost sale)? State back that the trigger reading can matter more than the levers.
- *Populations and other counts of individuals:* is it right to track individuals, or is a rate on an aggregate enough? Is there an absorbing state (extinction, ruin) and is the answer a probability (which needs many replications)? What happens first in a step (deaths, events, births, the cap), since the order changes the result?
- *Vehicles (elevators, shuttles, porters):* how are calls assigned (nearest, least loaded, zones, destination dispatch), where do idle vehicles wait (parking), door or stop time and time per person, capacity, speeds, and whether the traffic mix changes with the clock (up-peak, lunch, down-peak). Dispatch rules are the biggest unknown and usually the thing being compared: ask which ones the user wants to compare and what each means.
- *Feedback controllers (autoscaling, a thermostat, a staffing rule):* which signal is measured, over what window, and how many consecutive windows before acting; the size of each step (a count or a fraction); the cooldown after an action; how many actions may be in flight and whether the delay applies to removals; the minimum and maximum; and what the user wants compared (thresholds, delays, step sizes). The controller is usually the thing being compared, so make every one of these a lever.
- *Percentiles and per-entity measures:* if the answer needs a 95th or 99th percentile of a time per entity (a request, a passenger, an aircraft), say so before choosing the row: a model that keeps counts by bucket, or a fluid queue, cannot give per-entity percentiles, and an event model can. Ask whether a mean and a share over a limit are enough.
- *Queues:* do customers give up, switch lines, or get turned away when the line is long? Is there a limit to the waiting room? Do stations block each other?
- *Resources:* are the servers identical and always available, or do they have shifts, breaks, breakdowns, different speeds?
- *Resources together:* does one job need more than one kind of resource at the same time (a room and a physician, a machine and an operator, a bed and a nurse)? If so, how are they held (each for the whole job, or one for part of it)? The answer changes the result a great deal (a physician present for a quarter of the stay and a room held for all of it gives far shorter waits than both held for all of it), so do not default silently: if each is held for the whole job, only the scarcer one limits waiting and the other's count stops mattering, and the user may expect both to count; say so back. *Default when the user does not know: ask what fraction of the stay the scarcer-in-time resource is needed, and show the result at two values.*
- *Routing:* after a step, does everyone go to the same place next, or does it depend on chance, or on something about the entity?
- *Classes:* are there kinds of entities that need different treatment (a routine and an urgent case)?
- *Rules:* what does the decision maker see when they decide, and how old is it (today's stock, yesterday's)? What do they do about it?
- *Feedback:* does the system's own state change what arrives or what it costs (price follows stock, demand follows price, a long queue puts people off)?
- *Shared things:* do several parts draw on the same stock, cash or capacity? How is a shortfall shared out?
- *Shortfall:* when demand cannot be met, is it lost, backordered, or served late?
- *Priority:* if some customers go first, do waiting low-priority customers ever move up (ageing), and can a job already in progress be interrupted? *Default: strict priority, first come first served within a class, no ageing, no interruption; say that low classes can starve under load.*
- *Step:* if the model runs on a time step, how fine must it be against the shortest service time? *Default: about a fiftieth of the typical service time; the step is a stated simplification.*

**C. Inputs**
- Do you have data for arrivals, durations, demand? *If yes, `fit-model-to-sample` can fit the distribution (step 6).* If not: what is a typical value, a plausible low and a plausible high? *Default: a distribution that fits those three numbers, marked as an assumption.*
- Does the arrival or demand rate change over the day, week or year? *Default: constant, flagged as a simplification.*
- Are arrivals independent of each other, or do they come in bursts or clusters? Are two inputs related (two stores' demand on the same weather)?

**D. Run**
- How long should the run be, and does it start empty? *Default: start empty, drop a warm-up, and say how it was chosen.*
- Which settings will you want to compare? *They become levers.*

## How to put a question

Say what it decides, give a default, make "yes, the default" a one-word answer:

> **Do customers ever leave the line before being served?** If they can, the model has to count them as lost and a queueing-network component no longer applies as is. *Default: no one leaves (stated as a simplification).*

## What to do with "I don't know"

Take the default, mark it **inferred** or **placeholder**, add it to the list of assumptions that go back to the user in the final report, and, where it moves the answer, include it in the lever list so the user can see how much it matters.

## Stopping

If the model will be run so that its measures can be compared (a step of 1/50 of the shortest time is the usual rule), say what the step costs: a finer step multiplies a lever grid by the same factor, so state the cost and agree a coarser step with a stated bias if the grid would take hours.

Stop interviewing when every remaining **open** field is a parameter value. A model built with placeholders that the user can change is better than a second round of questions the user cannot answer.
