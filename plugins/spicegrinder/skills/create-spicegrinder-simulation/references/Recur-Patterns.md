![spicegrinder-icon](assets/spicegrinder-icon.png)
# Queueing recursions with Recur

> © 2026 Obsvra. This document describes SpiceGrinder and is provided to help you evaluate and use it. It is not a license to reproduce, adapt, or use this material to build a competing product or service. Full terms: the SpiceGrinder EULA.

## WHAT THIS PAGE COVERS

A queue or a line of stations looks like it needs an event calendar, but for first-come-first-served systems the times at which customers start and finish service follow from a few lines of arithmetic over the previous customer. `Recur` ([Component-Library-Reference.md](Component-Library-Reference.md)) carries that state from one row to the next, so these systems run in the Free edition as an ordinary model. Each output row is one step, one customer. `Recur` has no clock, so any time in the output is a column you compute. The results are the ones a discrete-event simulation gives for the same arrival times and service times. Each result is that of a single run, so repeat a run with other seeds before relying on one. Three ready-made models are in `samples/simulation/recursions/`:

| Model | System | Recorded output |
|---|---|---|
| `fifo-queue.xml` | One server, one line (M/M/1) | `fifo-queue.csv` |
| `tandem-line.xml` | Three servers in a row, each with its own line | `tandem-line.csv` |
| `parallel-servers.xml` | Two identical servers sharing one line (M/M/2) | `parallel-servers.csv` |

Each model feeds `Recur` one row per customer: the time since the previous arrival, then one service time per station. `Recur`'s state holds times (when each server next becomes free) and the quantities worth reporting (waits). With `appendInput="true"` each row also carries the draws that produced it, so any row can be checked by hand. The first row starts from an empty system. Times are in whatever unit the interarrival and service distributions use.

Customers are numbered 1, 2, 3 in order of arrival. Write A for a customer's arrival time and S for its service time, and use the subscript n for the current customer and n-1 for the one before. Each arrival time is the previous one plus the time since the previous arrival: A(n) = A(n-1) + the new interarrival draw.

## ONE SERVER (fifo-queue.xml)

A customer starts service when it has arrived and the server has finished the previous customer, so

```
start(n)     = max(A(n), D(n-1))
D(n)         = start(n) + S(n)          departure time
wait(n)      = start(n) - A(n)          time in the queue
```

where D is the departure time and D(0) = 0. State: `s[0]` is the arrival time A, `s[1]` is the departure time D. Output columns: arrival time, departure time, wait in queue, time in system, then the two inputs. The wait alone is Lindley's recursion, wait(n) = max(0, wait(n-1) + S(n-1) - T(n)), with T(n) the time since the previous arrival; `samples/simulation/recur-lindley-queue.xml` uses that form. The departure-time form here also yields the clock times, which the tandem line needs.

## THREE STATIONS IN A ROW (tandem-line.xml)

Each station applies the same rule to the time the customer leaves the station before it. With D1, D2 and D3 the departure times from the three stations:

```
D1(n) = max(A(n),  D1(n-1)) + S1(n)
D2(n) = max(D1(n), D2(n-1)) + S2(n)
D3(n) = max(D2(n), D3(n-1)) + S3(n)
wait at station k = max(0, Dk(n-1) - Dk-1(n))        (D0 = A)
time in line      = D3(n) - A(n)
```

The state is A, D1, D2, D3, the three waits and the time in line (eight columns). `Recur` assignments all read the previous state, never each other, so the model writes D2 and D3 out in terms of the earlier `max` terms instead of reusing the new D1. There is unlimited room between stations, so no station ever blocks the one before it.

## TWO PARALLEL SERVERS (parallel-servers.xml)

The state is the arrival time A and the times the two servers next become free, kept in order as F1 <= F2. The next customer in line goes to the server that frees first, F1, and starts at the later of its arrival and F1:

```
start(n) = max(A(n), F1)
done     = start(n) + S(n)
(F1, F2) = (min(F2, done), max(F2, done))       the pair, back in order
wait(n)  = start(n) - A(n)
```

Because the pair is re-sorted after every customer, F1 is always the earlier-free server, and the start times never decrease, so customers start service in arrival order (first come, first served). The output columns are arrival time, F1, F2, wait, then the two inputs. The servers are interchangeable, so the model never says which server a customer used.

## CHECKED AGAINST THEORY

`src/test/java/com/obsvra/spicegrinder/test/RecursionPatternsCheck.java` runs each model for 2,020,000 customers with the seed in the model, drops the first 20,000 as warm-up, and compares with the exact formulas. Consecutive waits are strongly correlated, so the standard error comes from the means of 100 batches of 20,000 customers, not from treating the customers as independent. A result passes when it is within four standard errors of theory. The check also replays every customer through a plain Java simulation fed with the same inputs, and the departure times and waits agree to within 1e-6 in every row.

| Model | Quantity | Theory | Measured | Standard error |
|---|---|---|---|---|
| FIFO queue (arrivals 0.7, service 1.0) | Mean wait in queue, rho / (mu - lambda) | 2.3333 | 2.3473 | 0.0143 |
| | Mean time in system, 1 / (mu - lambda) | 3.3333 | 3.3489 | 0.0148 |
| | Probability of waiting, rho | 0.7000 | 0.7013 | 0.0009 |
| Tandem line (arrivals 0.6; service 1.0, 0.9, 1.2) | Mean wait, station 1 | 1.5000 | 1.5036 | 0.0057 |
| | Mean wait, station 2 | 2.2222 | 2.2265 | 0.0115 |
| | Mean wait, station 3 | 0.8333 | 0.8346 | 0.0030 |
| | Mean total time in line | 7.5000 | 7.5101 | 0.0162 |
| Two servers (arrivals 1.5, service 1.0 each) | Mean wait in queue, Erlang C / (2 mu - lambda) | 1.2857 | 1.2928 | 0.0095 |
| | Probability of waiting, Erlang C | 0.6429 | 0.6446 | 0.0012 |

The tandem line's theory is Burke's theorem: the departures of a stable M/M/1 queue are again Poisson at the arrival rate, so each station behaves as an M/M/1 queue with the line's arrival rate, and the mean waits and times add. The M/M/2 value is the Erlang C formula for two servers with offered load 1.5. These are long-run averages: a short run, or a run that starts empty, has lower waits on average, and the closer a system is to full utilization the longer the run it needs.

## WHAT THESE MODELS DO NOT DO

* They assume the line is served first come, first served. Priorities, shortest-job-first and other disciplines change which customer is next and need a different state.
* No balking (customers who refuse to join a long line), reneging (customers who leave while waiting) or jockeying (switching lines), and no limit on the waiting room.
* No breakdowns, shifts, set-up times or other changes in server availability. Every server is always available and every customer needs one server for one service time.
* The parallel servers are identical. Servers with different speeds, or a customer who has to pick a server, need a different rule than "the one that frees first".
* The two-server recursion is written for exactly two servers. More servers need a longer expression that keeps more free times in order; the samples do not cover that.
* Service times are drawn independently of each other and of the arrivals. Consecutive output rows are not independent, since each wait depends on the customers before it, so treat a run as one trajectory (see `Recur`'s note on `--count` and seeds).

A system that needs any of these is a case for a discrete-event model, not a recursion.

## SEE ALSO

[Component-Library-Reference.md](Component-Library-Reference.md) (`Recur`), [Grind.md](Grind.md), [Model-File-Format-Reference.md](Model-File-Format-Reference.md)
