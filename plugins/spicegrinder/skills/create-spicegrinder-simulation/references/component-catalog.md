# Component Library Reference

> © 2026 Obsvra. This document describes SpiceGrinder and is provided to help you evaluate and use it. It is not a license to reproduce, adapt, or use this material to build a competing product or service. Full terms: the SpiceGrinder EULA.

Generated from the components' `@ComponentInfo`/`@Parameter` annotations by `list --markdown docs/Component-Library-Reference.md --write`, which keeps the explanatory text written under each component; a test fails if this file and the annotations disagree. For a live, always-current view straight from the registry, use `ComponentLibraryApp`(1) instead — see [ComponentLibraryApp.md](ComponentLibraryApp.md).

Including all Pro components, there are 94 components: 53 generators, 41 filters.


## Generators

### Bernoulli  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Bernoulli`

Single trial with success probability p (1 = success, 0 = failure)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| p | double | false | 0.5 | probability,prob | Success probability, in [0, 1] |

### Beta  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Beta`

Beta distribution on (0, 1) with shape parameters alpha, beta

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| alpha | double | false | 1.0 | shape1,a | Shape parameter 1 (> 0) |
| beta | double | false | 1.0 | shape2,b | Shape parameter 2 (> 0) |

### Binomial  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Binomial`

Number of successes in n independent trials with success probability p

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| n | int | false | 1 | trials | — | Number of trials (>= 0) |
| p | double | false | 0.5 | probability,prob | — | Success probability, in [0, 1] |
| mode | String | false | standard | algorithm | standard, fast | standard \| fast -- fast gives the same distribution in O(log n) per draw, from a table built once, instead of one trial per draw; for the same seed it draws different values than standard |

### Categorical  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Categorical`

Single weighted draw over k discrete categories, emitting the drawn 0-based index

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| weights | double[] | true | — | probabilities,probs | Comma/space-separated non-negative weights, one per category (need not sum to 1 — normalized automatically) |

### ChiSquared  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.ChiSquared`

Chi-squared distribution with df degrees of freedom

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| df | double | false | 1.0 | degreesoffreedom | Degrees of freedom (> 0) |

### Constant  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Constant`

Emits the same fixed value on every observation

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| value | String | true | — | — | — | The constant value, as text |
| type | String | false | double | datatype | int, double, string | int \| double \| string (Pro only) — how 'value' is parsed |

### Dirichlet  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Dirichlet`

k-dimensional random point on the probability simplex (each component in [0,1], summing to 1)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| alpha | double[] | true | — | concentration | Comma/space-separated concentration parameters, one per category (each > 0); larger values pull that category's share up |

### Empirical  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Empirical`

Samples from an explicit list of values, optionally weighted

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| values | double[] | true | — | data,samples | Comma/space-separated values, or 'value:weight' pairs (e.g. '5:1, 10:3, 15:1'); unweighted entries default to weight 1 |

### Exponential  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Exponential`

Exponential distribution (waiting times / inter-arrival)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| lambda | double | false | 1.0 | rate | Rate parameter (mean = 1/lambda) |
| mean | Double | false | — | mu | Mean (= 1/lambda), the alternative to lambda; used only when lambda (rate) is not given. 'mu' is a synonym |

### FDistribution  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.FDistribution`

F distribution (d1 numerator, d2 denominator degrees of freedom)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| d1 | double | false | 1.0 | numeratordf,df1 | Numerator degrees of freedom (> 0) |
| d2 | double | false | 1.0 | denominatordf,df2 | Denominator degrees of freedom (> 0) |

### Gamma  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Gamma`

Gamma distribution (shape, scale)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| shape | double | false | 1.0 | alpha,k | Shape parameter (> 0) |
| scale | double | false | 1.0 | theta | Scale parameter (> 0); the 'rate' parameter (or its synonym 'beta') is the alternative, as 1/scale |
| rate | Double | false | — | beta | Rate parameter (> 0), the alternative to scale: scale = 1/rate. Used only when scale (theta) is not given; 'beta' is a synonym |

### Geometric  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Geometric`

Number of trials until the first success (support starts at 1)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| p | double | false | 0.5 | probability,prob | Success probability, in (0, 1] |

### Gumbel  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Gumbel`

Gumbel (Type I extreme value) distribution (location mu, scale beta) — models the distribution of a maximum

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| mu | double | false | 0.0 | location | Location parameter |
| beta | double | false | 1.0 | scale | Scale parameter (> 0) |

### Hypergeometric  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Hypergeometric`

Successes drawn sampling `draws` items without replacement from a finite population

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| population | int | false | 1 | — | — | Total population size (>= 0) |
| successStates | int | false | 0 | k,successes | — | Number of success items in the population (0 &lt;= successStates &lt;= population) |
| draws | int | false | 0 | n,samplesize | — | Number of items drawn without replacement (0 &lt;= draws &lt;= population) |
| mode | String | false | standard | algorithm | standard, fast | standard \| fast -- fast gives the same distribution in O(log n) per draw, from a table built once, instead of one item per draw; for the same seed it draws different values than standard |

### InverseGaussian  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.InverseGaussian`

Inverse Gaussian (Wald) distribution (mean mu, shape lambda) — positive, right-skewed

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| mu | double | false | 1.0 | mean | Mean parameter (> 0) |
| lambda | double | false | 1.0 | shape | Shape parameter (> 0) |

### InverseWishart  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.InverseWishart`

Random k x k covariance matrix, the standard conjugate prior for MultivariateNormal's covariance

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| df | double | false | 2.0 | degreesoffreedom | Degrees of freedom (> k - 1, where k is the matrix dimension) |
| scale | double[] | true | — | psi | Flat, row-major k x k scale matrix (comma/space-separated, k*k entries, symmetric positive-definite) |

### Laplace  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Laplace`

Laplace (double-exponential) distribution (location mu, scale b) — sharper peak, heavier tails than Normal

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| mu | double | false | 0.0 | location,mean | Location parameter |
| b | double | false | 1.0 | scale | Scale parameter (> 0) |

### Logistic  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Logistic`

Logistic distribution (location mu, scale s) — smooth, bounded-tail noise

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| mu | double | false | 0.0 | location,mean | Location parameter |
| s | double | false | 1.0 | scale | Scale parameter (> 0) |

### Lognormal  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Lognormal`

Lognormal distribution (mu, sigma of the underlying normal)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| mu | double | false | 0.0 | meanlog,mean | Mean of the underlying normal (log scale) |
| sigma | double | false | 1.0 | sdlog,sd,stddev | Standard deviation of the underlying normal (log scale), >= 0 |

### Markov  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Markov`

Discrete-state Markov chain from a transition matrix, emitting the state index each row

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| matrix | double[][] | true | — | transitions,transitionmatrix | Square transition matrix: rows separated by ';' or a newline, values comma/space-separated; matrix[i][j] = P(next = j \| now = i), each row summing to 1 |
| initial | int | false | 0 | initialstate,start | State index emitted on the first row (0-based) |
| normalize | boolean | false | false | — | Scale each row to sum to 1 (for counts or weights) instead of requiring it to |

`matrix` is the transition matrix: one row per state, rows separated by `;` or a new line, values separated by commas or spaces, and `matrix[i][j]` is the probability of moving from state `i` to state `j` on the next row. It must be square, with no negative values, and every row must sum to 1 (within 1e-6); set `normalize` to true to scale rows of counts or weights instead. The first row emits `initial` (a state index, default 0) with no random draw; every later row draws once from the current state's row. The output is the state's 0-based index as a whole number. A state whose row has a 1 on its own diagonal is absorbing: the chain stays there. For time spent in a state that is not geometric (semi-Markov), pair `Markov` with `Pool` durations. Example, two-state weather: `matrix="0.8,0.2; 0.4,0.6"`.

### Multinomial  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Multinomial`

trials draws across k weighted categories, emitting a k-dimension vector of per-category counts

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| weights | double[] | true | — | probabilities,probs | Comma/space-separated non-negative weights, one per category (need not sum to 1) |
| trials | int | false | 1 | n | Total number of draws spread across categories (>= 0) |

### MultivariateNormal  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.MultivariateNormal`

Multivariate Normal: independent (diagonal) or fully-correlated (covariance/Cholesky)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| means | double[] | false | — | mean | Mean vector, comma/space-separated |
| sigmas | double[] | false | — | sigma,stddevs,sds | Per-dimension standard deviations (DIAGONAL/independent mode only) |
| covariance | double[][] | false | — | cov,covmatrix | Full covariance matrix (FULL/correlated mode only): rows separated by ';' or a newline, values within a row comma/space-separated, e.g. "1.0,0.5; 0.5,1.0" for a 2x2 matrix. Row count determines the dimension (no separate 'dimension' attribute needed for this mode). |
| dimension | Integer | false | — | dim,d | Optional: the number of dimensions. Normally inferred from means, sigmas or covariance; if given, it must agree with them |

### NegativeBinomial  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.NegativeBinomial`

Over-dispersed count distribution (dispersion r, success probability p) for when Poisson is too tight

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| r | double | false | 1.0 | size,dispersion | — | Dispersion parameter (target successes, > 0, real-valued) |
| p | double | false | 0.5 | probability,prob | — | Success probability, in (0, 1) |
| mode | String | false | standard | algorithm | standard, fast | standard \| fast -- fast gives the same distribution with a Poisson step whose cost doesn't grow with the mean (standard's grows linearly); for the same seed it draws different values than standard |

### Normal  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Normal`

Normal (Gaussian) distribution

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| mean | double | false | 0.0 | — | Mean of the distribution |
| sigma | double | false | 1.0 | stddev,sd,std | Standard deviation |

### Pareto  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Pareto`

Type I Pareto distribution (scale xm, shape alpha) for severity/long-tail modeling

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| scale | double | false | 1.0 | xm,minimum | Scale parameter xm, the minimum value (> 0) |
| shape | double | false | 1.0 | alpha | Shape parameter alpha, tail heaviness (> 0) |

### Poisson  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Poisson`

Poisson distribution with rate lambda

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| lambda | double | false | 1.0 | rate,mean | — | Rate parameter (>= 0) |
| mode | String | false | standard | algorithm | standard, large-lambda | standard \| large-lambda -- large-lambda is an exact, faster algorithm recommended above lambda~10000 (see class docs); requires lambda >= 30 |

Two algorithms, same distribution — the choice is a performance tradeoff, not a correctness one. `standard` (Knuth's algorithm) is correct at any lambda but expected-O(lambda) per draw — fine well past lambda in the thousands, measurably slow (tens of microseconds or more per draw) once lambda exceeds roughly 10,000. `large-lambda` (rejection sampling against a Cauchy/logistic envelope) is expected-O(1) per draw regardless of lambda, verified against `standard` via a chi-squared goodness-of-fit comparison against the true Poisson PMF, not just matching moments — but its log-factorial term relies on an approximation only accurate once accepted candidates sit well away from zero, so it's refused below lambda=30 rather than silently trusted there.

### Polynomial  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Polynomial`

Evaluate a polynomial at x (constant, sequence, or uniform)

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| coefficients | String | true | — | coeffs,c | — | Comma-separated coefficients a0,a1,a2,... (lowest degree first) |
| xMode | String | false | constant | mode | constant, sequence, uniform | constant \| sequence \| uniform |
| x | double | false | 0 | x0,start | — | Constant x, or sequence start |
| xStep | double | false | 1 | step | — | Sequence step when xMode=sequence |
| xMin | double | false | 0 | — | — | Uniform lower bound |
| xMax | double | false | 1 | — | — | Uniform upper bound |

### Profile  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Profile`

The value of a profile that follows the clock at each step (solar output by hour, a load shape, a price by month, a temperature), step or linear, repeating, optionally times a second profile

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| values | String | true | — | — | — | The profile as time:value points, comma-separated, times increasing: "0:2, 6:10, 12:30" |
| mode | String | false | step | — | step, linear | step: constant from each point to the next. linear: interpolated between points |
| period | double | false | 0 | — | — | 0 for none; otherwise the profile repeats every period (point times in [0, period)) |
| values2 | String | false | — | — | — | An optional second profile (time:value points) that multiplies the first, for example a yearly shape |
| mode2 | String | false | step | — | step, linear | step or linear, for the second profile |
| period2 | double | false | 0 | — | — | The period of the second profile (0 for none) |
| scale | double | false | 1 | — | — | A multiplier on the result |
| offset | double | false | 0 | — | — | Added to the result (after the scale) |
| start | double | false | 0 | — | — | The clock value at the start of the run (row 0) |
| step | double | false | 1 | — | — | The length of one row, in the time unit of the points |

One row is one step of `step` time units, the n-th at the clock time `start + n * step`, and the value is the profile there, times `scale`, plus `offset`. The profile is given as `time:value` points, `values="0:2, 6:10, 12:30, 18:10"`. With `mode="step"` (the default) the value is constant from each point to the next; with `mode="linear"` it is interpolated between points. Before the first point the value is the first point's value, and after the last point it stays at the last point's value. `period` makes the profile repeat (a 24-hour day: `period="24"`, every point time in `[0, 24)`); with `step` the last value holds until the period ends, and with `linear` the last point is joined to the first point of the next period. Values may be negative (a temperature). The value is the profile's value at the start of the step (it is not averaged over the step; use a small step, or the `RateSchedule` generator for a count of events).

A second profile multiplies the first: `values2`, `mode2` and `period2` work as above. A day shape and a year shape together (`period="24"`, `period2="8760"`) give a load that peaks by day and by season. For a random level on top (a day of cloud, a random demand multiplier), feed this generator and a distribution to a `Calculate` that multiplies them; for a value read at an arbitrary clock column of the model, the expression functions `interp` and `lookup` do the same job without a generator.

Example, solar output through a day in half-hour steps: `values="0:0, 6:0, 12:1, 18:0" mode="linear" period="24" step="0.5"`.

### RateSchedule  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.RateSchedule`

The number of events in each step of a rate that follows the clock (a day with a morning and an evening peak): a Poisson count whose mean is the integral of the rate over the step

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| schedule | String | true | — | — | — | The rate as time:rate points, comma-separated, times increasing: "7:0.4, 8.5:6, 10:2" |
| mode | String | false | step | — | step, linear | step: constant from each point to the next. linear: interpolated between points |
| period | double | false | 0 | — | — | 0 for none; otherwise the profile repeats every period (point times in [0, period)) |
| scale | double | false | 1 | — | — | A multiplier on every rate |
| start | double | false | 0 | — | — | The clock value at the start of the run (row 0) |
| step | double | false | 1 | — | — | The length of one row, in the time unit of the points |

One row is one step of `step` time units, the n-th starting at `start + n * step`, and the value is how many events fall in it: a Poisson draw with mean `scale` times the integral of the rate over the step. The rate is given as `time:rate` points, `schedule="7:0.4, 8.5:6, 10:2"`. With `mode="step"` (the default) the rate is constant from each point to the next; with `mode="linear"` it is interpolated between points, so a ramp up to a peak and down again is three points. Before the first point the rate is the first point's rate, and after the last point it stays at the last point's rate. `period` makes the profile repeat (a 24-hour day: `period="24"`, every point time in `[0, 24)`); with `step` the last rate holds until the period ends, and with `linear` the last point is joined to the first point of the next period. Times and rates are in whatever units the model uses; the step is in the time unit of the points. The integral is worked out exactly, not by sampling, so a step that straddles a change of rate gets the right mean. Counts in different steps are independent. `scale` multiplies every rate and is the lever for "20% more arrivals". The counts are whole numbers already.

Example, a day in one-minute steps with a morning and an evening peak (times in hours): `schedule="0:0.2, 7:0.2, 8.5:6, 10:1, 16:1, 17.25:6, 19:0.2" mode="linear" period="24" step="0.016666666666666666"`. The model needs one row per step, so a day is 1440 rows. In a `ProcessFlow`, give the node the same points as its `rate` attribute instead; the arrivals then follow the profile without counting steps.

### Sequence  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Sequence`

Simple arithmetic sequence (start, step)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| start | double | false | 0.0 | startvalue | Initial value |
| step | double | false | 1.0 | stepvalue | Amount added after each observation |

### Skellam  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Skellam`

Difference of two independent Poisson variables (P1 - P2); can be negative

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| lambda1 | double | false | 1.0 | rate1 | — | Rate of the first Poisson term (>= 0) |
| lambda2 | double | false | 1.0 | rate2 | — | Rate of the second Poisson term (>= 0) |
| mode | String | false | standard | algorithm | standard, fast | standard \| fast -- fast gives the same distribution in O(log n) per draw, from a table built once for each Poisson term, instead of a cost that grows with the rates; for the same seed it draws different values than standard |

### StudentT  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.StudentT`

Student's t distribution with df degrees of freedom (heavier-tailed than Normal)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| df | double | false | 1.0 | nu,degreesoffreedom | Degrees of freedom (> 0) |

### Triangular  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Triangular`

Triangular distribution (min, mode, max)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| min | double | false | 0.0 | a,lower | Lower bound |
| mode | double | false | 0.5 | c,peak,mostlikely | Most likely value |
| max | double | false | 1.0 | b,upper | Upper bound |

### Uniform  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Uniform`

Uniform random doubles in [min, max)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| min | double | false | 0.0 | — | Lower bound (inclusive) |
| max | double | false | 1.0 | — | Upper bound (exclusive) |

### VonMises  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.VonMises`

von Mises distribution (mean angle mu, concentration kappa) — circular analog of Normal

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| mu | double | false | 0.0 | mean | Mean angle in radians |
| kappa | double | false | 1.0 | concentration | Concentration (>= 0; 0 = uniform around the circle) |

### Weibull  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Weibull`

Weibull distribution (shape k, scale lambda)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| shape | double | false | 1.0 | k,alpha | Shape parameter k (> 0) |
| scale | double | false | 1.0 | lambda,theta | Scale parameter lambda (> 0) |

### Wishart  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Wishart`

Random k x k covariance matrix (df degrees of freedom, k x k scale matrix), row-major output

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| df | double | false | 2.0 | degreesoffreedom | Degrees of freedom (> k - 1, where k is the matrix dimension) |
| scale | double[] | true | — | v | Flat, row-major k x k scale matrix (comma/space-separated, k*k entries, symmetric positive-definite) |

### Zipf  (Free)
`com.obsvra.spicegrinder.core.defaults.generators.Zipf`

Finite Zipf distribution over ranks 1..n, probability proportional to rank^-s

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| n | int | false | 10 | population | Number of ranks (>= 1) |
| s | double | false | 1.0 | exponent | Skew exponent (> 0; larger = more skewed toward rank 1) |

### CollaborationBeacon  (Pro)
`com.obsvra.spicegrinder.examples.generators.CollaborationBeacon`

Example component (not covered by the 1.0 compatibility promise): mutable counter usable as a normal generator or a Collaborate target -- collaborate() reads current state without advancing it

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| initial | double | false | 0 | — | Starting counter value |

**Example component** — a worked example of a Collaborate target, not covered by the 1.0 compatibility promise. See the Collaborating Components section of the [Customization guide](Customization.md) to write your own.

Each pull adds 1 and returns the new value, so with `initial=0` the first pull returns 1 (and with `initial=10` it returns 11). `collaborate` returns the current value without adding to it and ignores its input, so a collaborator never changes what the beacon's own consumers see. Before the first pull, `collaborate` returns `initial`. The output is one column.

### Database  (Pro)
`com.obsvra.spicegrinder.pro.generators.Database`

Sample rows from a database table/query

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| url | String | true | — | jdbcurl,connection | — | JDBC connection URL (e.g. jdbc:h2:~/test). Must match an entry on database.url.allowlist (at a path boundary, with no '..' segment; options such as ;INIT= are refused unless the URL is listed exactly) -- disabled by default (empty allowlist), see UserPreferences. |
| user | String | false | — | username | — | Optional database username. If set, connects with explicit user/password credentials; if omitted, connects using the URL alone (e.g. for URLs that embed credentials or a database that needs none). |
| password | String | false | — | pass | — | Optional database password, paired with 'user' (treated as an empty string if 'user' is set but this isn't). Ignored if 'user' isn't set. |
| driver | String | false | — | driverclass | — | Optional JDBC driver class to explicitly load via Class.forName() before connecting. Usually unnecessary -- modern drivers self-register from the URL alone -- but useful for older jars that don't, or to be explicit when multiple DB drivers share the classpath. |
| table | String | false | — | — | — | Table name to read via SELECT * FROM &lt;table>; ignored if 'query' is supplied |
| query | String | false | — | sql | — | SQL query to run against the connected database; if omitted, 'table' is used instead |
| mode | String | false | unweighted | — | sequential, unweighted, weighted | sequential \| unweighted \| weighted |
| onExhaustion | String | false | error | exhaustion,onend | error, repeat, hold, null | error \| repeat \| hold \| null (sequential only) |
| weightColumn | String | false | 0 | weight,weightcol,weightindex | — | 0-based index or column name for weighted mode (default 0) |

### EIN  (Pro)
`com.obsvra.spicegrinder.business.generators.EIN`

Generates a US Employer Identification Number, real assignable prefixes only

No `@Parameter`-declared fields — no composed input, same shape as `SSN`/`NPI`. The 2-digit prefix is drawn uniformly from the real 83 prefixes the IRS currently assigns (01-99 excluding the IRS's own documented invalid-prefix list); the 7-digit serial is drawn uniformly at random. No `fictionalOnly` toggle: the IRS's invalid-prefix list documents prefixes no longer assigned to new applicants, not an officially reserved "guaranteed safe for testing" block. See `samples/pro/ein.xml` and its header comment for the full disclosure.

### FhirIdRegistry  (Pro)
`com.obsvra.spicegrinder.business.generators.FhirIdRegistry`

Mints unique <prefix>-<n> ids from one shared counter via the Collaborate channel, so every resource in a model gets a distinct id

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| startAt | int | false | 1 | — | First number minted. |

### FlatFile  (Pro)
`com.obsvra.spicegrinder.pro.generators.FlatFile`

Sample rows from a CSV file (sequential, unweighted, or weighted)

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| file | String | true | — | filename,path | — | Path to the CSV file. A relative path is looked for beside the model first, then in its local root (--local-root, project.root, a .spicegrinder-root marker or the Git top), then in the working directory, and must stay inside that folder (a ../ or symlink escape needs flatFile.path.allowlist like an absolute path); an absolute path must be inside a folder on flatFile.path.allowlist in preferences.properties (whole path segments, real paths), which is empty (so absolute paths are refused) by default |
| skipHeader | boolean | false | false | header | — |  |
| delimiter | String | false | , | sep,separator | — |  |
| textColumns | String | false | — | text,textcolumn | — | Columns to keep as text even when their cells look like numbers (ZIPs, codes, account numbers): 0-based file column indexes or header names (names need skipHeader), comma-separated |
| mode | String | false | unweighted | — | sequential, unweighted, weighted | sequential \| unweighted \| weighted |
| onExhaustion | String | false | error | exhaustion,onend | error, repeat, hold, null | error \| repeat \| hold \| null (sequential only) |
| weightColumn | String | false | 0 | weight,weightcol,weightindex | — | 0-based index or column name for weighted mode (default 0) |

**Cell types.** A cell that reads as a plain decimal number (`42`, `-3.5`, `1e6`) becomes a number; anything else stays text (`NaN`, `Infinity` and codes like `3074F` stay text). A column whose values only look like numbers, such as ZIP codes, account numbers or procedure codes, belongs in `textColumns`: every cell in it stays text, so `02134` keeps its leading zero instead of printing as `2134.0`. Quoting a cell doesn't change its type. Column indexes count the file's own columns, the weight column included, the same numbering as `weightColumn`; the weight column itself can't be a text column.

A relative `file` is looked for beside the model file first (the folder of the model being loaded, as an `Import`'s path is), then in the model's local root, then in the working directory of the process reading it. The local root is the first of `--local-root DIR` given to the command (the desktop app passes its Local root setting this way), `project.root` in preferences, the nearest folder at or above the model that holds a `.spicegrinder-root` file (a release's top folder has one), and the top of the Git work tree the model is in, the same local root `Import` uses. So a table shipped next to its model (such as one `tabulate --extract` wrote) is found wherever the model is run from, and a path written relative to a project's top folder is found from anywhere inside that project. Every bundled sample names its data by a bare file name beside the model. A model submitted as text has no folder of its own: under `ModelServiceApp`, that process is the server, not the caller — see [Service API Reference](Service-API-Reference.md#file-paths-in-submitted-models) for what path to use when the model is submitted to a service rather than run locally.

**Relative vs. absolute, and the `flatFile.path.allowlist` gate.** A relative `file` (every bundled sample uses one) is resolved against the folder it is found in (beside the model, the local root, or the working directory) and then to its real path, symlinks resolved; it is accepted without the allowlist only if that real path stays inside that folder, so a `../` chain or a symlink that leaves the folder is refused unless it is on the allowlist. An absolute path names anywhere on the filesystem directly, so it is always gated the same safe-by-default way `Database`'s `database.url.allowlist`/`ServiceCall`'s `service.url.allowlist` already are: empty allowlist (the default) means every absolute `file` value, and every relative one that escapes its folder, is rejected outright, not silently allowed. Add absolute directory entries to unlock specific locations. An entry matches whole path segments (`/data/shared` covers `/data/shared/f.csv` but not `/data/shared-private`), and entries are resolved to their real paths just like the file, so on macOS an entry of `/tmp/data` matches a file under `/private/tmp/data`. Relative entries are ignored. A model with no folder of its own (submitted to `ModelServiceApp` or an MCP tool) resolves a relative `file` from the working directory, and when `project.root` is set in preferences it must stay inside that folder instead. When the model came through `ModelServiceApp` or an MCP tool, a missing file and a refused one get the same error, which names only the path as written; the detail goes to the server log. This applies regardless of whether the model came from a local file or `ModelServiceApp` — a malicious/untrusted model read locally carries the same arbitrary-file-read risk as one submitted over HTTP.

### IMEI  (Pro)
`com.obsvra.spicegrinder.business.generators.IMEI`

Generates a 15-digit mobile device IMEI with a real Luhn check digit

No `@Parameter`-declared fields — no composed input, same shape as `SSN`/`NPI`/`EIN`. TAC (8 digits) and serial number (6 digits) are drawn uniformly at random; the 15th digit is a real Luhn check digit computed over the preceding 14 — the same algorithm already used for `CreditCard`/`NPI`. TAC/serial are not sourced from a real per-device GSMA allocation table (a confidently-verified curated subset of those exact mappings wasn't available to cite directly) — only the real 15-digit format and the real Luhn check digit are guaranteed correct. No `fictionalOnly` toggle: GSMA does not publish a reserved-safe-for-testing IMEI block. See `samples/pro/imei.xml` and its header comment, or `IMEI.java`'s own javadoc, for the full disclosure.

### Import  (Pro)
`com.obsvra.spicegrinder.pro.generators.Import`

Load a sub-model from another XML file as a reusable library

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| file | String | true | — | — | Path to the library model XML |

`<Import>` also accepts any number of extra key/value attributes beyond `file`/`name`/`prefix`, not `@Parameter`-discoverable (same reason `collaborate.<role>` isn't, above): each overrides a matching `<declare>` in the imported file for that one import — see [Model File Format Reference](Model-File-Format-Reference.md#parameterized-sub-models-pro--declare--import-overrides).

When you construct this class from Java code, the library's nodes' random streams are named under this node's name (the same names `<Import name="..."/>` gives in a model file), so two `Import`s of the same library under one seed draw different values. The library's own `<dataset seed>` is applied only when the process has no seed yet. See [Determinism](Determinism.md#seeds-custom-generators-and-code).

### IPAddress  (Pro)
`com.obsvra.spicegrinder.business.generators.IPAddress`

Generates an IPv4 address, real public unicast space by default

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| fictionalOnly | boolean | false | false | — | When true, restrict every draw to the three IANA/RFC 5737 documentation-only blocks (192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24) -- guaranteed to never be publicly routable, at the cost of only 768 distinct addresses. When false (default), all four octets are drawn from the real public unicast space (private/loopback/reserved/etc. blocks excluded), so a generated address could in principle match a real, currently-assigned one. |

No composed input — unlike `Phone`/`CreditCard` there's no real "network provider" concept to wrap, so this lives in `business.generators` rather than `business.filters`, same shape as `Constant`/`Sequence` just Pro-gated and domain-specific. Same collision-without-PII shape as `Phone`, and the same restricted-range-toggle design carried forward from it. See `samples/pro/ipaddress.xml` and its header comment for the full disclosure.

### IPv6Address  (Pro)
`com.obsvra.spicegrinder.business.generators.IPv6Address`

Generates an IPv6 address, real public unicast space by default

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| fictionalOnly | boolean | false | false | — | When true, fixes the first two groups to the real RFC 3849 documentation prefix 2001:0db8 and draws the remaining six groups at random -- guaranteed to never be publicly routable. When false (default), all eight groups are drawn from the real public unicast space (loopback/unspecified/link-local/unique-local/multicast/etc. blocks excluded), so a generated address could in principle match a real, currently-assigned one. |

No composed input, same self-contained shape as `IPAddress`. Rendered in the full, uncompressed 8-group colon-hex form; no RFC 5952 zero-compression is applied, disclosed explicitly. Same collision-without-PII shape as `IPAddress`, and the same restricted-range-toggle design carried forward from it. See `samples/pro/ipv6address.xml` and its header comment for the full disclosure.

### Mixture  (Pro)
`com.obsvra.spicegrinder.examples.generators.Mixture`

Example component (not covered by the 1.0 compatibility promise): single-node weighted mixture, component specs inline instead of separate nodes + Mix

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| components | String | true | — | — | Semicolon-separated 'Type(param=val,param=val):weight' specs, at least 2 |

**Example component** — a worked example of a custom generator, not covered by the 1.0 compatibility promise. `Mix` covers the same need with ordinary nodes and is the supported choice.

### NPI  (Pro)
`com.obsvra.spicegrinder.business.generators.NPI`

Generates a US National Provider Identifier, Luhn-valid per the CMS NPI Final Rule

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| type | String | false | random | — | individual, organization, random | individual \| organization \| random (default) -- constrains the NPI's first digit to 1 (Type 1, individual provider) or 2 (Type 2, organization provider) per the CMS NPI Final Rule; 'random' picks one uniformly on every draw. |

No composed input, same shape as `IPAddress`/`SSN`. The check digit is a real Luhn checksum computed over the 9-digit base prefixed with the constant `80840` (the ISO/IEC 7812 health-industry issuer identifier CMS's own rule specifies) — the exact algorithm every real NPI must satisfy. No `fictionalOnly` toggle: unlike `Phone`/`CreditCard`/`SSN`, CMS/NPPES does not publish an officially reserved "guaranteed safe" NPI block. See `samples/pro/npi.xml` and its header comment for the full disclosure.

### RoutingNumber  (Pro)
`com.obsvra.spicegrinder.business.generators.RoutingNumber`

Generates a US ABA routing transit number with a valid weighted mod-10 check digit

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| prefix | String | false | assigned | — | assigned, government, district, thrift, electronic, traveler, unassigned, any | assigned (default) \| government \| district \| thrift \| electronic \| traveler \| unassigned \| any -- which Federal Reserve routing-symbol band the leading two digits are drawn from. 'unassigned' draws from bands the Federal Reserve does not issue, guaranteeing no collision with a real institution at the cost of failing a strict prefix check. |

### SharedState  (Pro)
`com.obsvra.spicegrinder.pro.generators.SharedState`

Named numeric cells that separate parts of a model read and write; a read sees the value as of the end of the previous row

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| cells | String | true | — | — | Cells as name=initial pairs, comma-separated, e.g. "stock=100, backlog=0" (=initial is optional and means 0) |

A store of named numbers, read with `StateRead` and written with `StateWrite`, so one part of a model can respond to another: reorder when stock is low, throttle when a queue is long. `cells` lists the cells as `name=initial` pairs separated by commas, for example `cells="stock=100, backlog=0"`; `=initial` is optional and means 0. Names are letters, digits and `_`, and must not repeat. A name with a range makes one cell per index: `cells="queue[1..20]=0"` is the cells `queue1` to `queue20`, each starting at 0 (the bounds are whole numbers, and a declare works: `queue[1..${floors}]`).

**Reads are one row behind.** A read in a row returns the value as of the end of the previous row (the initial value in the first row). Writes made during a row take effect for reads in the next row. Because of that, results do not depend on where readers and writers sit in the model, and moving a node cannot change the output. Every loop through a `SharedState` therefore has a one-row delay; a response that must land in the same row belongs in `Recur` or a single `Calculate`.

**Writes.** A cell may have at most one `set` writer and any number of `add` writers. At the end of a row the cell becomes its `set` value (if the `set` writer wrote this row, otherwise its old value) plus the sum of this row's `add` amounts. The `add` amounts are summed in writer-name order, so the result is the same whichever writer is pulled first. A cell nobody wrote in a row keeps its value. NaN and infinity are stored as they come.

The store is not part of the model's input tree: `StateRead` and `StateWrite` name it with `collaborate.state="StoreName"`. Several stores are allowed. Pulling a `SharedState` directly returns its committed values, one column per cell. Cell names are checked when the model is validated or on the first row, before any output row.

### SSN  (Pro)
`com.obsvra.spicegrinder.business.generators.SSN`

Generates a US Social Security Number, real allocatable range by default

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| fictionalOnly | boolean | false | false | — | When true, restrict the area number to [900, 999] -- the SSA's own published rule states this range has never been, and never will be, allocated to a real person -- guaranteed safe at the cost of an obviously-synthetic-looking area number. When false (default), area is drawn from the real historically-allocatable [001, 899] range (excluding 666), so a generated number could in principle match a real person's actual SSN. |

No composed input, same shape as `IPAddress`. Same collision-without-PII shape as `Phone`, and the same restricted-range-toggle design carried forward from it. See `samples/pro/ssn.xml` and its header comment for the full disclosure.

### StateRead  (Pro)
`com.obsvra.spicegrinder.pro.generators.StateRead`

Emits the current value of chosen SharedState cells (as of the end of the previous row)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| cells | String | true | — | — | Cells to read, comma-separated, e.g. "stock, backlog" |

Emits the value of each cell in `cells`, one column per cell, in the order listed. A range stands for a block of cells: `cells="queue[1..20]"` is `queue1` to `queue20` (20 columns), and `queue[3]` is the single cell `queue3`. `collaborate.state="StoreName"` names the `SharedState` to read; it is not an `<input>`, and `StateRead` takes no input. The value is the one committed at the end of the previous row (the cell's initial value in the first row), whatever the node's position in the model, and a read never changes the store. To read the same cell in two places, use two `StateRead` nodes. A cell that is not in the store is reported when the model is validated or on the first row, before any output row.

## Filters

### Append  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Append`

Concatenates DataPoints from multiple inputs into one Observation

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input (multiple) | List | true | — | — | attrs: name. Input generator reference; concatenated in document order. |

### Arrange  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Arrange`

Outputs the listed input DataPoint indices in the listed order: exclude, reorder or duplicate columns

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| columns | int[] | true | — | — | 0-based input DataPoint indices to output, comma/space-separated, in output order. Leave an index out to exclude it; repeat one to duplicate it |

One general column operation. On a 3-column input: `columns="0,2"` excludes the middle column; `columns="2,0,1"` reorders; `columns="0,1,1,2"` duplicates the second; `columns="0,1,2,0,1,2"` doubles the whole row. Output dimension is the number of listed indices. Values keep their types, so this is also how to copy or move a text column (`Calculate` handles only numbers, and one node can't be wired into two places). With `Extract`, list `formatted` instead when the goal is keeping a composite's whole value beside its fields.

### Calculate  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Calculate`

Arithmetic expressions over input observation

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| expression | String | true | — | expr,formula | Semicolon-separated assignments y[i] = ... |
| dimension | int | false | — | outputdimension,dim | Output dimension; 0 (the default) keeps the input's dimension. Outputs past the input pass 0 unless assigned |

Each assignment sets one output value from the input values `x[0]`, `x[1]`, ...; an output not assigned passes its input through. Operators `+ - * /` and parentheses, numeric literals, and functions: `floor`, `ceiling` (or `ceil`), `round`, `abs`, `sqrt`, `exp` (e to the power x) and `log` (or `ln`, the natural logarithm) take one argument; `sin` and `cos` (angles in radians; they use `StrictMath`) take one, `min`, `max`, `mod` and `pow` take two, and `if(c, a, b)` takes three: it gives `a` when `c` is nonzero (and not NaN) and `b` otherwise, evaluating only the branch it picks. The constant `pi` is available. The comparisons `<`, `<=`, `>`, `>=`, `==` and `!=` give 1 when true and 0 when false; they rank below `+ - * /`, so `x[0] + 1 > x[1] * 2` compares two sums, and they do not chain. Conditions combine with `&&` (and), `||` (or) and the prefix `!` (not): each gives 1 or 0, `!` binds tighter than a comparison (`!a == 0` is `(!a) == 0`; write `!(a == 0)`), `&&` binds tighter than `||`, and a value counts as true when it is nonzero and not NaN, as in `if()`. The right side of `&&` and `||` is evaluated only when needed, so a guard such as `i >= 0 && choose(i, 5, 6, 7)` never reaches `choose` with a negative index. In an XML attribute write `<` as `&lt;`, and `&&` as `&amp;&amp;`. Seasonality: `y[0] = 10 + 3 * sin(2 * pi * x[0] / 24)` with `x[0]` an hour counter; a flag: `y[0] = if(x[0] > 100, 1, 0)` or just `y[0] = x[0] > 100`. The optional `dimension` makes the output wider (or narrower) than the input: every output not assigned passes its input through, or is 0 past the input's end; every `y[i]` must be inside it. Results are always decimal numbers; end with `ToInteger` when a whole number should print as one. `exp`, `log` and `pow` use Java's `StrictMath` (fdlibm), so their results are identical on every platform and Java version: `log(0)` is negative infinity and `log` of a negative number is NaN. Example, a multivariate lognormal from a `MultivariateNormal` fitted to the logs of two skewed columns: `y[0] = exp(x[0]); y[1] = exp(x[1])`.

**Local variables.** `let name = expression;` computes a value once for the whole row, for the statements written after it: `let busy = x[0] + x[1]; y[0] = busy / 2; y[1] = busy * busy`. A name is letters, digits and `_`; it cannot be `x`, `s`, `y`, `pi`, `let` or a function name, cannot be defined twice, and cannot be used before its `let`. An assignment still reads only the inputs and the locals, never another assignment's result, so a dependent value goes through a `let` and not a second `Calculate`. All `let`s are evaluated every row, in the order written.

**Several values and column ranges.** `x[a..b]` is the columns from `a` to `b`, both included; it can only stand as an argument of `sum`, `mean`, `min`, `max`, `argmin`, `argmax` or `choose`, which take any number of values and ranges (left to right): `sum(x[2..21])`, `max(x[0], x[3..5], 7)`. `min` and `max` need two or more values or a range. `argmin` and `argmax` give the 0-based position in the list of the smallest or largest value (the lowest position on a tie; NaN values are skipped). `choose(i, a, b, ...)` gives the i-th of the values (0-based, `i` rounded down; outside the list is an error): `choose(x[0], 120, 90, 60, 35, 20)`. `interp(x, x0,y0, x1,y1, ...)` reads a table: the line through the points (x increasing; the first y below the first x and the last y above the last): `interp(mod(x[0], 24), 0,0, 6,0, 12,1, 18,0)`; `lookup(x, x0,y0, ...)` gives the y of the last point whose x is not above x (a step table). The index of `x[...]` can be an expression, rounded down: `x[x[2] - 2]`; a computed index is checked when the row is evaluated.

### Copula  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Copula`

Correlated columns with arbitrary marginal distributions (Gaussian or Student-t copula)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input (multiple) | List | true | — | — | attrs: name. A one-dimensional distribution generator: one output column, in document order. |
| correlation | double[][] | true | — | corr | Correlation matrix of the underlying normal (or t) variables, one row/column per input: rows separated by ';' or a newline, values comma/space-separated, e.g. "1, 0.6; 0.6, 1". Symmetric, 1 on the diagonal, positive definite. |
| df | Double | false | — | degreesoffreedom | Degrees of freedom (> 0) for a Student-t copula; omit for a Gaussian copula |

Each input is a one-dimensional distribution generator -- `Normal`, `Gamma`, `Poisson`, `Empirical`, `Categorical`, `Constant` and the other built-in distributions, a `Mix` or `Truncate` of them, a `Calculate` that shifts, scales or negates one (`y[0] = 2 * x[0] + 5`, `y[0] = -x[0]`), or (Pro) a `FlatFile` or `Database` table of one numeric column read at random, weighted or not -- and gives one output column with exactly that distribution. The inputs are used only for their distributions (quantile functions); they aren't drawn from, so wire each one only here. `correlation` sets how the columns move together: a symmetric matrix with 1 on the diagonal, one row and column per input in input order, in the same format as `MultivariateNormal`'s `covariance` (for example `"1, 0.6; 0.6, 1"`). It is the correlation of the underlying normal (or t) variables, which is close to, but not the same as, the correlation of the output columns. To target a rank (Spearman) correlation `rs` measured from data, use `r = 2 sin(pi rs / 6)` (Gaussian copula). Discrete inputs give integer columns.

Without `df`, extremes in different columns are nearly independent however high the correlation (a Gaussian copula has no tail dependence). Give `df` (small values such as 3-10) for a Student-t copula, whose columns tend to be extreme together: joint losses, simultaneous claims, correlated outages.

### Draw  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Draw`

One draw per row from a library distribution whose parameters are computed from the input row

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| distribution | String | true | — | dist | The library distribution to draw from, for example Binomial or Poisson |
| params | String | true | — | parameters | name = expression statements separated by ;, over the input's columns x[i], for example "n = x[0]; p = x[1]" |
| options | String | false | — | — | Fixed parameters that are not numbers computed per row, as name=value pairs separated by ;, for example "mode=fast" |

A distribution whose parameters come from the model instead of from constants. `distribution` names a scalar distribution of the library (`Bernoulli`, `Beta`, `Binomial`, `ChiSquared`, `Exponential`, `FDistribution`, `Gamma`, `Geometric`, `Gumbel`, `Hypergeometric`, `InverseGaussian`, `Laplace`, `Logistic`, `Lognormal`, `NegativeBinomial`, `Normal`, `Pareto`, `Poisson`, `Skellam`, `StudentT`, `Triangular`, `Uniform`, `VonMises`, `Weibull`, `Zipf`). `params` assigns its parameters, by name or alias, as `name = expression` statements separated by `;`, in the expression language of `Calculate` over the columns `x[0]`, `x[1]`, ... of the input (`let` locals, ranges and `if` work): `params="n = x[0]; p = x[1]"` for the number of survivors among `x[0]` individuals that each survive with probability `x[1]`, or `params="lambda = x[0] * (1 + 0.2 * sin(x[1]))"` for a seasonal Poisson. A parameter that is not assigned keeps the distribution's default; `options` sets fixed non-numeric parameters as `name=value` pairs separated by `;` (for example `mode=fast`).

Each row pulls the input once, evaluates the parameters, and draws one value with them; the output is what the distribution gives (a `Binomial` still gives whole numbers). The distribution's own checks apply to every row's parameters (`p` in [0, 1], `n` a whole number of at least 0, ...), and a failure stops the run with this node's name and the row; a parameter that must be a whole number and gets 3.4 is an error (use `floor` or `round`). The random stream is this node's own, so a `Draw` named `N` with constant parameters gives exactly what a plain distribution node named `N` with those parameters gives. The distribution is reconfigured only when a parameter changed since the last row; a standard `Binomial` costs one uniform per trial, and `mode=fast` builds its table once per distinct set of parameters, so it pays only when the parameters repeat. Not for the multivariate or table distributions (`Categorical`, `Empirical`, `Dirichlet`, `Multinomial`, `Markov`): their parameters are not scalars; for several draws in a row use `Replicate` over a `Draw`.

### Mix  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Mix`

Weighted random selection among input generators

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input (multiple) | List | true | — | — | attrs: name,weight. Input generator reference with optional weight (default 1). Weights are normalized to probabilities on [0,1]. |
| synchronous | boolean | false | false | sync | When true, advance every synchronous input on each observation (even if discarded). Non-synchronous inputs advance only when selected. |

### Pool  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Pool`

Reuses each entity (a provider, a customer, a vehicle) on several rows: draws it once, then emits it on a fitted number of rows

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input (multiple) | List | true | — | — | attrs: name,role. role="entity": generates one entity's fixed columns, drawn once per entity. role="count": whole numbers of at least 1, each entity's number of rows. Without roles: entity, then count. With countColumn, only the entity input. |
| interleave | int | false | 1 | — | How many entities are open at once: 1 keeps each entity's rows together; more spreads them out |
| countColumn | int | false | — | — | 0-based column of the entity input that gives each entity's number of rows, instead of a count input, so the number can depend on the entity; that column isn't passed on |

Real transactional data repeats its entities: a provider bills several services, a customer places several orders. The `entity` input generates one entity's fixed columns (an identity, an address, a specialty); `Pool` draws it once and emits the same values on each of its rows. The `count` input gives each entity's number of rows, whole numbers of at least 1, drawn once per entity; fit it from the sample's rows per identifier, for example an `Empirical` of how many identifiers have 1, 2, 3... rows. Row-level columns (the service, the amount) come from elsewhere and are joined with `Append`: `Append(Providers, Service)`.

`interleave` sets how many entities are open at once. With 1, each entity's rows come out together, as in an extract sorted by identifier; with more, each row picks one of the open entities at random, spreading each entity's rows out like orders arriving from many customers over time. The number of rows per entity follows `count` either way. At the end of a run, the entities still open are cut short. `compare`'s `repetition` check shows whether the output repeats entities as often as the sample.

When the number of rows depends on the entity (a radiology practice bills many more services than a chiropractor), make it one of the entity's own columns and name it with `countColumn` instead of giving a `count` input: for example an entity of `Append(Identity, Switch(Specialty, one rows-per-provider distribution per specialty))`. That column sets the entity's number of rows and isn't passed on. Entity-level columns fitted over one row per entity then come out with the right shares per row too, because the entities that have more rows get them.

### Recur  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Recur`

Carries numeric state from row to row: new state from the previous state s[i] and input x[i]

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single input; every column an expression reads as x[i] must be numeric |
| initial | String | true | — | init | Starting state, one value per state column; its length sets the state dimension. Comma or space separated numbers, or comma separated constant expressions of numbers and declared values ("0.5 * 100, 0") |
| expression | String | true | — | expr,formula | Semicolon-separated assignments y[i] = ... over the previous state s[0].. and the current input x[0].. |
| resetEvery | int | false | 0 | period | When above 0, the state returns to initial before every resetEvery-th pull after the first, so each block of resetEvery pulls is an independent path. 0 never resets |
| appendInput | boolean | false | false | — | When true, each row is the new state followed by the input's columns |

Each pull reads one row from the input and computes a new state from the previous state `s[0]`, `s[1]`, ... and the input `x[0]`, `x[1]`, ..., then outputs the new state and keeps it for the next pull. `initial` gives the starting state, and its number of values sets how many state columns there are. Assignments use `Calculate`'s operators and functions, plus `s[i]`. Every assignment reads the previous state, so their order doesn't matter (`y[0] = s[1]; y[1] = s[0]` swaps two columns); a state column with no assignment keeps its value. The first row is already one step on from `initial`: with `initial="120"` and `y[0] = s[0] + x[0]`, row 1 is `120 + x[0]`.

The state is never reset during a run, so one run is one trajectory and `--count` is its length; use another seed for another replication. To get one independent path per row instead, set `resetEvery` to the path length and reshape with `Redimension`: `Redimension(Recur(NetFlow, 120, "y[0] = s[0] + x[0]", resetEvery=12), 12)` gives twelve months of balance per row, each row starting again from 120.

`Recur` advances only when it is pulled, so under a `Mix` or `Switch` branch it steps only on rows where that branch is chosen; set `synchronous="true"` to keep it stepping under a `Mix`. NaN and infinity follow standard arithmetic and never stop generation; once a state value is NaN it stays NaN. `initial` may be `Infinity` (a running minimum: `y[0] = min(s[0], x[0])`). Set `appendInput="true"` to output the input's columns after the state.

Example, a single-server queue (Lindley's recursion): input columns service time and time to the next arrival, `initial="0"`, `y[0] = max(0, s[0] + x[0] - x[1])`; each row is the next customer's wait.

Local variables and ranges work as in `Calculate` (see there): `let big = argmax(s[0..2]); y[0] = s[0] + x[0]; y[1] = s[1] - big; y[2] = max(s[0..2])`. A `let` can read the previous state `s[i]` and the input `x[i]`, and `s[a..b]` is a range of state columns, so a rule over several state columns (the free-up time of the earliest car, the longest queue) is one assignment and not a chain of nodes. Assignments still read only the previous state, never another assignment's new value.

### Redimension  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Redimension`

Reshapes a single input stream to a new output dimension

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| dimension | int | true | — | outputdimension,dim | Output dimension (DataPoints per Observation) |

### Replicate  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Replicate`

Pulls its input count times per row and joins the results: count independent draws of one generator

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| count | int | true | — | k | Number of pulls of the input per row |

Each row pulls the input `count` times and puts the results side by side, so the output has `count` times the input's number of columns. Twelve independent uniform draws in a row are one `Uniform` and `<Replicate count="12">` over it. Every pull is a fresh draw, so the columns are independent (for a random input) and come from the input's own random stream in order: the first row holds draws 1 to `count`, the second row draws `count`+1 to 2 x `count`.

`Replicate` keeps nothing between rows. `Redimension` is the other way to get several columns from one source: it reshapes a stream, so it carries leftover values from one row to the next and can take one pull of a wide input in pieces. For a single-column input both give `count` independent draws; use `Replicate` when you mean "this many copies" and `Redimension` when you mean "reshape".

### Switch  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Switch`

Picks a branch by one column's value and appends that branch's columns, so later columns can depend on earlier ones

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input (multiple) | List | true | — | — | attrs: name,role,value. One input with role="input": the rows to read the key from. Each other input is a branch, with value="..." (the key value it's chosen for) or value="*" (every value not listed). |
| key | int | true | — | — | 0-based column of the input whose value picks the branch |

Some columns depend on the value of another: a provider's specialty decides which procedures they bill, a payment type decides whether there's a tip. `Switch` reads a row from its `role="input"` input, looks at the value in its `key` column (0-based), and appends the columns of the branch whose `value` matches it; a branch with `value="*"` takes every value not listed. Numbers match as numbers (`1` matches `1.0`); text matches exactly. Only the chosen branch is advanced, so each branch generates only the rows it's chosen for.

Every branch must produce the same number of columns. A value that matches no branch, with no `*` branch, stops generation with an error naming the value. With a `Pool`, `Switch` makes row-level columns depend on the entity: `Switch(input = Providers, key = the specialty column)`, one branch of services per specialty.

### ToInteger  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.ToInteger`

Converts numeric DataPoints to IntDataPoint via a rounding mode

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| mode | String | false | floor | rounding | floor, ceiling, round, truncate | floor \| ceiling \| round \| truncate |
| indexes | String | false | — | index,indices | — | 0-based DataPoint indices to convert, comma/space-separated (default: all) |

### Truncate  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Truncate`

Bounds a numeric generator's output to [min, max] via redraw (truncate) or clamp (censor)

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| min | String | false | — | — | — | Lower bound (omit for no lower bound) |
| max | String | false | — | — | — | Upper bound (omit for no upper bound) |
| mode | String | false | truncate | — | truncate, censor | truncate (redraw until in bounds) \| censor (clamp to nearest bound) |
| indexes | String | false | — | index,indices | — | 0-based DataPoint indices to bound, comma/space-separated (default: all) |
| maxAttempts | int | false | 10000 | — | — | Truncate mode only: draws to try before failing loudly (> 0) |

### Address  (Pro)
`com.obsvra.spicegrinder.business.filters.Address`

Assembles a real city/region/postal code source and a real street-name source into a street address (US and Canadian data bundled)

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input (multiple) | List | true | — | — | attrs: name,role. Inputs: location (dimension-3: [city, region, postalCode], or dimension-4 with a country code last), street (dimension-1: streetName), and optionally street.&lt;REGION> (e.g. street.QC) for regions with their own street names |
| minStreetNumber | int | false | 1 | — | Minimum street number (inclusive) |
| maxStreetNumber | int | false | 9999 | — | Maximum street number (inclusive) |
| unitProbability | double | false | 0.28 | — | Probability [0,1] that a generated address includes a unit/apt/suite |
| unitLabels | String | false | — | — | Unit designators to pick from, comma-separated (e.g. "Apt,Unit,Suite"). Default: address.unitLabels.&lt;COUNTRY>.&lt;REGION>, .&lt;COUNTRY>, then address.unitLabels in formats.properties |
| country | String | false | US | — | ISO 3166-1 alpha-2 country for every address, when the location input is dimension 3 (a dimension-4 location supplies its own). Picks the format locale; US also zero-pads postal codes to 5 digits |
| format | String | false | — | — | Template for this node's canonical string, overriding formats.properties -- {field} placeholders, [ ... ] dropped when its fields are empty. Fields: number, street, unit, city, region, postalCode, country, streetLine. Example: "{streetLine}, {city} {region}" |

Output is one `AddressDataPoint`, printed whole as `2607 Chestnut St, Woodville, VA 22749` (template `format.address.en_US`; the locale follows the address's country). Its fields are `number` (numeric), `street`, `unit`, `city`, `region`, `postalCode` (text, so `02134` keeps its zero), `country` and `streetLine` (`2607 Chestnut St Apt 4`); split them into columns with `Extract`. The postal code may arrive as text or as a number; a numeric US ZIP is zero-padded to 5 digits.

**Canada.** Set `country="CA"` and use the Canadian tables: `city_province_postal_ca.csv` (real city/province/postal code rows, read with `mode="weighted" weightColumn="0"`), `street_names_ca_weighted.csv`, and `street_names_qc_weighted.csv` wired as `role="street.QC"`. A row whose location is in Quebec then draws a French street name (`rue Principale`) and a French unit designator (`app`, `bureau`, `unité`); every other province gets English names and `Apt`/`Unit`/`Suite`. Addresses print the way Canada Post writes them (`format.address.en_CA`): `123 King St Apt 4, Toronto ON  M5V 2T6`, with no comma before the province and two spaces before the postal code. Any region can have its own street source the same way (`role="street.NB"`, or several regions in one role, `role="street.QC,NB"`); only the chosen source is read for a row. See `samples/pro/address-ca.xml`.

Nominal-realism, not true realism: city/state/zip come from one real reference table (so those three are always mutually consistent), street name from a second real reference table (the top 100 most common actual US street names, weighted by how many counties have a road with that exact name, from the Census Bureau's TIGER/Line data) — but the two are otherwise independent, so the street isn't claimed to exist in the drawn city. Street number and an optional unit are generated internally. See `samples/pro/address.xml` and its header comment for the full reasoning and data provenance.

### BusinessDay  (Pro)
`com.obsvra.spicegrinder.business.filters.BusinessDay`

Generates a US federal business day (weekday, non-holiday) from a year input

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single numeric-valued input supplying the year |
| format | String | false | — | — | DateTimeFormatter pattern for the produced DateDataPoint's stringValue() (default: ISO yyyy-MM-dd) |

`Date`'s calendar/holiday-aware sibling: same leap-year-correct day-of-year draw, redrawn until the result is Monday-Friday and not one of the 11 real US federal holidays (5 U.S.C. § 6103), including the real weekend-observance shift for the six fixed-date holidays. Reuses `DateDataPoint` directly — a business day is still just a date. No `fictionalOnly` toggle: a calendar date carries no PII-collision concern. See `samples/pro/business-day.xml` and its header comment for the full holiday list and computation.

### CollaborationWatcher  (Pro)
`com.obsvra.spicegrinder.examples.filters.CollaborationWatcher`

Example component (not covered by the 1.0 compatibility promise): combines its own input with one or more Collaborate targets' current values

**Example component** — a worked example of a Collaborate consumer, not covered by the 1.0 compatibility promise. See the Collaborating Components section of the [Customization guide](Customization.md) to write your own.

No `@Parameter`-declared fields (a plain `<input>` child wires this filter's own data source, same as any ordinary filter; `collaborate.<role>="TargetName"` node-tag attributes, not `@Parameter`-discoverable, name any number of Collaborate peers separately — see [Model File Format Reference](Model-File-Format-Reference.md#collaborate-references-pro)).

Output is the `<input>`'s columns followed by one column per `collaborate.<role>` target, in alphabetical order of the role names (ignoring case), not the order they are written. The dimension is the input's dimension plus the number of targets; each target is expected to answer with one column. The input is read first, then each target's `collaborate()`. The target columns are read, never advanced. A configuration error is raised if there is no `<input>`, no `collaborate.*` attribute, or a target is unknown or is not a Collaborate target.

### CompanyName  (Pro)
`com.obsvra.spicegrinder.business.filters.CompanyName`

Generates a business/company name from a [word1, word2, suffix] input

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single input supplying dimension-3 [word1, word2, suffix] |

Joins the two words with a space or " & " (chosen internally at random) and appends the real legal-entity suffix — e.g. "Falcon Meadow Group" or "Falcon & Meadow LLC". The sample model draws both words from the same real word list `Email`'s random-word mode uses, and the suffix from a real, standard (deliberately unweighted) US legal-entity suffix list. No `fictionalOnly` toggle — a company name is not sensitive PII, and there is no reserved-safe registry to opt into. See `samples/pro/company-name.xml` and its header comment for the full disclosure.

### Convert  (Pro)
`com.obsvra.spicegrinder.pro.filters.Convert`

Deserialize an upstream string into a typed ISerializable business object, wrapped in an ObjectDataPoint

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single input, must be single-dimension (a raw serialized string) — a multi-dimension input is rejected at configure time |
| class | String | true | — | — | Fully-qualified class name of an ISerializable business object, reflectively constructed (via a no-arg constructor) and populated from the single upstream input's serialized string. |

Works with any upstream node that produces a string, including `ServiceCall`, `FlatFile`, and `Database`. See `Convert`'s own class javadoc for the expected NDJSON wire format and the full security/design rationale, and [Customization](Customization.md) section 9.3 for a worked example using `ISerializable`/`AbstractSerializable`.

### CreditCard  (Pro)
`com.obsvra.spicegrinder.business.filters.CreditCard`

Generates a credit card number from a network/BIN input, fully random by default

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single input supplying dimension-3 [network, binPrefix, length] |
| fictionalOnly | boolean | false | false | — | When true, substitute the network's real published test number (e.g. Visa's 4242424242424242) instead of a randomly-filled one -- guaranteed to never be a real, chargeable card, at the cost of zero variety (every draw for a given network is identical). When false (default), remaining digits are drawn at random and a valid Luhn check digit is computed, so a generated number could in principle match a real, currently-issued one. |
| format | String | false | — | — | Template for this node's canonical string, overriding formats.properties -- {field} placeholders, [ ... ] dropped when its fields are empty. Fields: network, number, numberGrouped, last4. Example: "**** **** **** {last4}" |
| locale | String | false | — | — | Locale of the format.creditcard.&lt;locale> template to use when 'format' is not set (default: format.locale in formats.properties, else en_US) |

Printed whole as the number in 4-digit groups (`5110 2537 3048 5662`, template `{numberGrouped}`); fields `network`, `number`, `numberGrouped`, `last4`, all text.

By default (`fictionalOnly=false`), the digits between the real issuer BIN prefix and the check digit are drawn uniformly at random and a valid Luhn check digit is computed, so the result is format- and checksum-valid but not derived from any real cardholder's actual account — the same collision-without-PII shape already established for `Phone`/`Email` (see `CreditCardDataPoint`'s javadoc for the full disclosure). Setting `fictionalOnly="true"` is an explicit opt-in to a guaranteed-safe number instead — the network's real, published test number (the exact numbers Stripe, and every other major payment processor, document for sandbox testing) — carrying forward the same "put the power in the user's hands, along with the documented tradeoffs" design confirmed with the user during `Phone`'s `fictionalOnly` follow-up. See `samples/pro/creditcard.xml` and its header comment for the same disclosure and data provenance (real network market share and BIN prefixes).

### Date  (Pro)
`com.obsvra.spicegrinder.business.filters.Date`

Generates a calendar date from a year input, uniform over that year's days

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single numeric-valued input supplying the year |
| minAge | int | false | 0 | — | Minimum whole years of age as of 'asOf' (0 = no minimum) |
| asOf | String | false | — | — | Reference date (yyyy-MM-dd) minAge is measured against -- required when minAge > 0. Never wall-clock, so runs stay reproducible for a fixed seed. |
| format | String | false | — | — | DateTimeFormatter pattern for the produced DateDataPoint's stringValue() (default: ISO yyyy-MM-dd) |

Day of year is drawn uniformly via `Randoms.get().getNextUniformInt(1, daysInYear)`, where `daysInYear` is computed from the drawn year (`Year.isLeap`) *after* the year is known — leap-year-correct by construction, not by truncating a `Uniform(1,366)` draw. When `minAge > 0`, a drawn date younger than `minAge` as of `asOf` is rejected and redrawn, bounded to 10,000 attempts (`InvalidParameterException` if never satisfied). Not birth-date-specific despite the motivating use case — see [Model File Format Reference](Model-File-Format-Reference.md).

### DomainName  (Pro)
`com.obsvra.spicegrinder.business.filters.DomainName`

Generates a domain/website name from a [word, tld] input

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single input supplying dimension 2: [word, tld] |

Joins the two fields as `word.tld` after lowercasing and stripping non-alphanumerics from each. The word half typically draws from the same `email_words.txt` word list `Email`/`CompanyName` use; the TLD half from `samples/pro/domain_tlds.csv` (10 real, currently-significant top-level domains, unweighted — see that CSV's own header comment for why). No `fictionalOnly` toggle: a domain name is not sensitive PII, and there is no reserved-safe registry to opt into even if one were wanted. See `samples/pro/domain-name.xml`
for a full worked example.

### Email  (Pro)
`com.obsvra.spicegrinder.business.filters.Email`

Builds an email address from a real domain source, plus a name source (default) or random words

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input (multiple) | List | true | — | — | attrs: name,role. Inputs: name (dimension-1 PersonDataPoint source, required only when nameBased=true), domain (dimension-1, always required) |
| nameBased | boolean | false | true | — | When true (default), the local part is derived from the 'name' input's PersonDataPoint via a common real-world username pattern. When false, the local part is a random common word plus a random number, and no 'name' input is needed. |
| wordListFile | String | false | samples/pro/email_words.txt | — | Path to the word list used when nameBased=false. Found and checked like a FlatFile file: a relative path is looked for beside the model, then in its local root (--local-root, project.root, a .spicegrinder-root marker or the Git top), then in the working directory, and must stay inside that folder; an absolute path must be on flatFile.path.allowlist |
| format | String | false | — | — | Template for this node's canonical string, overriding formats.properties -- {field} placeholders, [ ... ] dropped when its fields are empty. Fields: localPart, domain. Example: "{localPart} at {domain}" |
| locale | String | false | — | — | Locale of the format.email.&lt;locale> template to use when 'format' is not set (default: format.locale in formats.properties, else en_US) |

Printed whole as `brooksa@icloud.com` (template `{localPart}@{domain}`); fields `localPart`, `domain`.

Two modes, both real-format, neither tied to any real inbox. `nameBased=true` (default) picks uniformly among 7 common real-world username patterns (`john.smith`, `jsmith`, `john.smith47`, `johnsmith47`, `johns`, `smithj`, `john_smith`) derived from the composed name input's `PersonDataPoint`. `nameBased=false` builds `word123`-style local parts from a common-word list (`email_words.txt`, from SCOWL's most common words) instead, with no name input needed at all. Either way the domain always comes from a real email-provider reference table (`gmail.com`, `icloud.com`, `outlook.com`, `yahoo.com`, `protonmail.com`, `aol.com`, `gmx.com`, `zoho.com`, weighted by real approximate global user share). Same collision-without-PII shape as `business.filters.Phone`: a generated address can in principle coincide with a real, in-use inbox, but carries no tie to any real person's data either way (see `EmailDataPoint`'s javadoc for the full disclosure). See `samples/pro/email.xml` (name-based) and `samples/pro/email-random.xml` (random-word) for worked examples and full provenance.

### Extract  (Pro)
`com.obsvra.spicegrinder.pro.filters.Extract`

Replace a composite dimension (Address, Person, Email, Phone, CreditCard, or a Convert result) with its named fields, one output dimension each

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single input; the dimension at index must hold a composite data point |
| fields | String | true | — | — | Field names to extract, comma/space-separated, in output order -- e.g. "street,city,region,postalCode" for an Address. Each becomes its own output dimension; text fields stay text (a ZIP keeps its leading zero). "formatted" is the whole value as one string, to keep it alongside its fields. |
| index | int | false | 0 | — | 0-based input dimension holding the composite to split (default 0). Every other dimension passes through unchanged, in place. |

The generic way to turn a business object into columns: `<Extract name="Addr" fields="street,city,region,postalCode"><input name="Address"/></Extract>`. Works on every built-in composite (`Address`, `PersonAssembler`, `Email`, `Phone`, `CreditCard`; see each one's field list above) and on a `Convert` result, whose fields are read through `ObjectDataPoint.get(key)`. The fields replace the composite at its position, in the order listed, and every other column stays where it was: output dimension is the input dimension minus one plus the number of fields. Splitting removes the composite; to keep it too, list the reserved field `formatted` (the whole value as printed, e.g. `fields="formatted,postalCode"`), which every composite has. To split several composites, chain `Extract` nodes; working from the rightmost composite leftward keeps each later `index` unaffected by earlier splits. An unknown field name fails when the model loads if the input is the business-object filter itself, and on the first row otherwise (for example through an `Append`); either way the message lists the valid fields. There is no auto-detection of which dimension holds the composite: set `index` when it isn't dimension 0. See `samples/pro/address-columns.xml`.

### FhirBloodPressureRender  (Pro)
`com.obsvra.spicegrinder.business.filters.FhirBloodPressureRender`

Renders a FHIR R4 blood-pressure Observation (LOINC 85354-9 panel, systolic/diastolic components), the shape the official validator's bp profile requires

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input (multiple) | List | true | — | — | attrs: name,role. Inputs: systolic (numeric), diastolic (numeric) |
| unit | String | false | mmHg | — | Display unit for both component values. |
| unitCode | String | false | mm[Hg] | — | UCUM unit code for both component values. |
| effectiveDateTime | String | false | 2026-01-02T09:00:00Z | — | Fixed effective date/time (ISO 8601), not the system clock, so output stays reproducible. |
| idPrefix | String | false | bp | — | Prefix sent to the id registry when minting this resource's id. |

### FhirBundleAssembler  (Pro)
`com.obsvra.spicegrinder.business.filters.FhirBundleAssembler`

Assembles a FHIR R4 Bundle from one Patient render and any number of resource renders, pulled once each in order

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| id | String | false | bundle-1 | — | Bundle.id. |
| type | String | false | collection | — | Bundle.type -- collection (default) \| transaction \| batch \| searchset, etc. |
| baseUrl | String | false | http://example.org/fhir | — | Base URL each entry's fullUrl is built from: &lt;baseUrl>/&lt;resourceType>/&lt;id>. Synthetic; nothing is actually hosted there. |

### FhirObservationRender  (Pro)
`com.obsvra.spicegrinder.business.filters.FhirObservationRender`

Renders a FHIR R4 Observation resource with one numeric value, referencing a patient via Collaborate

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| code | String | true | — | — | LOINC code identifying what was measured, e.g. 8867-4 (Heart rate). |
| display | String | true | — | — | Human-readable name for the code, e.g. "Heart rate". |
| unit | String | false | — | — | Display unit for the value, e.g. "beats/minute". |
| unitCode | String | false | — | — | UCUM unit code for the value, e.g. "/min". |
| category | String | false | vital-signs | — | Observation category code (observation-category CodeSystem). |
| effectiveDateTime | String | false | 2026-01-02T09:00:00Z | — | Fixed effective date/time (ISO 8601), not the system clock, so output stays reproducible. |
| idPrefix | String | false | obs | — | Prefix for the minted Observation.id, followed by a 1-based sequence number. |

### FhirPatientRender  (Pro)
`com.obsvra.spicegrinder.business.filters.FhirPatientRender`

Renders a FHIR R4 Patient resource; also a Collaborate target other resources can reference by name

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input (multiple) | List | true | — | — | attrs: name,role. Inputs: person (a PersonDataPoint source, e.g. PersonAssembler), birthDate (a YYYY-MM-DD string source, e.g. the core Date filter) |
| idPrefix | String | false | patient | — | Prefix for the minted Patient.id, followed by a 1-based sequence number. |

### IBAN  (Pro)
`com.obsvra.spicegrinder.business.filters.IBAN`

Generates an International Bank Account Number from a country-code input

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single input supplying a real 2-letter ISO 3166-1 country code (DE, GB, FR, ES, IT, or NL) |

Real per-country BBAN field structure (ISO 13616) for 6 countries, plus a real, correctly computed ISO 7064 MOD-97 checksum (the required, universally-checked part of IBAN validity). Nominal realism, not true realism: France/Spain/Italy/the Netherlands each embed a second, country-specific check algorithm inside the BBAN itself (RIB key, national check digits, CIN, "elfproef") that this generator does not also implement — only the inner BBAN digits/letters outside the universal MOD-97 check are plain random. No `fictionalOnly` toggle: no standards body publishes a reserved-safe IBAN block. See `samples/pro/iban.xml` and its header comment for the full disclosure and per-country field breakdown.

### ISBN  (Pro)
`com.obsvra.spicegrinder.business.filters.ISBN`

Generates a 13-digit ISBN from a real registration-group input

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single input supplying a real single-digit ISBN registration group (0/1 = English, 2 = French, 3 = German, 4 = Japan, 5 = former USSR, 7 = China) |

The real "978" EAN Bookland prefix is fixed (979 also exists in the real standard but is not modeled). The remaining 8 digits (publisher + title code, combined — no complete citable real publisher-range table was available to split them correctly) are drawn uniformly at random. The 13th digit is the real ISO 2108/EAN-13 check digit (alternating weights 1/3, sum mod 10). Rendered as the bare 13-digit string, no hyphens. No `fictionalOnly` toggle: no standards body publishes a reserved-safe ISBN block. See `samples/pro/isbn.xml` and its header comment, or `ISBN.java`'s own javadoc, for the full disclosure.

### MACAddress  (Pro)
`com.obsvra.spicegrinder.business.filters.MACAddress`

Generates a 6-byte MAC address from a real OUI (vendor prefix) input

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single input supplying a real 3-byte OUI (e.g. "00:05:02" = Apple, "B8:27:EB" = Raspberry Pi Foundation) |

The 3 NIC-specific bytes are drawn uniformly at random and rendered as the standard colon-separated uppercase hex form (`XX:XX:XX:XX:XX:XX`). No `fictionalOnly` toggle: IEEE 802's real "locally administered" address space is actively used by real software for its own addresses, not an officially reserved never-collide block. See `samples/pro/macaddress.xml` and its header comment, or `MACAddress.java`'s own javadoc, for the full disclosure.

### NachaEntryRender  (Pro)
`com.obsvra.spicegrinder.business.filters.NachaEntryRender`

Renders a NACHA ACH Entry Detail record (type 6) as a 94-character line

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input (multiple) | List | true | — | — | attrs: name,role. Inputs by role: routing, account, amount, name (all required); id, trace (optional) |
| transactionCode | String | false | 22 | — | Two-digit ACH transaction code: 22 checking credit, 27 checking debit, 32 savings credit, 37 savings debit. |
| addenda | String | false | 0 | — | Addenda Record Indicator: 0 when no addenda record follows this entry, 1 when one does. |

### NachaFileAssembler  (Pro)
`com.obsvra.spicegrinder.business.filters.NachaFileAssembler`

Assembles a complete blocked NACHA ACH file from Entry Detail records, with computed trailers

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| count | int | false | 10 | entries | Number of Entry Detail records to pull into the file. |
| companyName | String | false | SPICEGRINDER CO | — | Originating company name (Batch Header, 16 chars). |
| companyId | String | false | 1000000000 | — | Company Identification (10 chars), typically an IRS EIN prefixed with 1. |
| companyEntryDescription | String | false | PAYROLL | — | Company Entry Description (10 chars), e.g. PAYROLL. |
| originatingDfi | String | false | 12102537 | — | Originating DFI Identification: the first 8 digits of the ODFI's routing number. |
| destinationRouting | String | false | 021000021 | — | Immediate Destination: the 9-digit routing number of the receiving ACH operator. |
| destinationName | String | false | ACH OPERATOR | — | Immediate Destination Name (23 chars). |
| originName | String | false | SPICEGRINDER CO | — | Immediate Origin Name (23 chars). |
| serviceClassCode | String | false | 200 | — | 200 mixed debits and credits \| 220 credits only \| 225 debits only. |
| standardEntryClass | String | false | PPD | — | Standard Entry Class code, e.g. PPD (consumer), CCD (corporate), WEB. |
| fileCreationDate | String | false | 260101 | — | File creation date as YYMMDD. Fixed, not the system clock, so output stays reproducible. |
| fileCreationTime | String | false | 0000 | — | File creation time as HHMM. Fixed, not the system clock, so output stays reproducible. |
| effectiveEntryDate | String | false | 260102 | — | Effective entry date as YYMMDD (Batch Header). |
| renumberTraces | boolean | false | true | — | When true (default), rewrite each entry's trace number as the originating DFI plus a 7-digit sequence, which is what a real originator does -- trace sequence is file-scoped, so the entry renderer cannot know it. Set false to keep whatever trace the input produced. |

### PersonAssembler  (Pro)
`com.obsvra.spicegrinder.business.filters.PersonAssembler`

Assembles a [gender, givenName] source and a surname source into a Person

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input (multiple) | List | true | — | — | attrs: name,role. Inputs: genderGiven (dimension-2: [gender, givenName]), surname (dimension-1) |
| format | String | false | — | — | Template for this node's canonical string, overriding formats.properties -- {field} placeholders, [ ... ] dropped when its fields are empty. Fields: gender, givenName, surname. Example: "{surname}, {givenName}" |
| locale | String | false | — | — | Locale of the format.person.&lt;locale> template to use when 'format' is not set (default: format.locale in formats.properties, else en_US) |

Printed whole as `Sophia Peterson` (template `{givenName} {surname}`); fields `gender`, `givenName`, `surname`.

### Perturb  (Pro)
`com.obsvra.spicegrinder.pro.filters.Perturb`

Inject disturbance on a timed schedule

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| repeat | boolean | false | true | — | Repeat disturbances after each cycle |
| synchronous | boolean | false | false | sync | When true, advance the inactive branch (normal/disturbance) on each observation too, if that branch is itself synchronous -- discarding its result but keeping its internal state in lock-step so a disturbance episode picks up wherever the baseline actually is by then, rather than a frozen snapshot. Same idea Mix uses for its own inputs. |
| input (multiple) | List | true | — | — | attrs: name,role. Input generator reference with a role: normal/disturbance/wait/duration (aliases: data/primary, perturb/error, delay, length). Falls back to positional order (normal, disturbance, wait, duration) if roles are omitted. |
| mode | String | false | replace | — | What a disturbance episode does to the normal value: "replace" (the default) outputs the disturbance instead of the normal value; "add" outputs normal + disturbance, so the disturbance rides on a baseline that keeps advancing. In add mode both inputs must be numeric, and the disturbance has either the same number of columns as the normal input or one column, which is added to every column. |

### Phone  (Pro)
`com.obsvra.spicegrinder.business.filters.Phone`

Generates a US (NANP) phone number from an area code input, exchange/subscriber fully random by default

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single numeric-valued input supplying the area code, [200, 999] |
| fictionalOnly | boolean | false | false | — | When true, restrict exchange/subscriber to the NANP-reserved 555-0100..555-0199 fictional block (guaranteed no real-subscriber collision, but only 100 distinct endings per area code and an unmistakably fake-looking 555 exchange). When false (default), exchange/subscriber are fully random within valid NANP format -- more variety and realism, but a generated number could in principle match a real assigned one. Area code is unaffected either way. |
| format | String | false | — | — | Template for this node's canonical string, overriding formats.properties -- {field} placeholders, [ ... ] dropped when its fields are empty. Fields: areaCode, exchange, subscriber. Example: "+1{areaCode}{exchange}{subscriber}" (E.164) |
| locale | String | false | — | — | Locale of the format.phone.&lt;locale> template to use when 'format' is not set (default: format.locale in formats.properties, else en_US) |

Printed whole as `(747) 301-6980` (template `({areaCode}) {exchange}-{subscriber}`; `format="+1{areaCode}{exchange}{subscriber}"` gives E.164); fields `areaCode`, `exchange`, `subscriber`, all digit strings so a subscriber of `0042` keeps its zeros.

By default (`fictionalOnly=false`), exchange/subscriber are fully random NANP-valid, not restricted to the reserved fictional block — a deliberate choice, confirmed directly with the user: a generated number can in principle be a real, currently-assigned number that would reach a live line, but it carries zero connection to any real person or PII (see `PhoneDataPoint`'s javadoc for the full disclosure). Exchange excludes the 8 reserved N11 codes (211/311/411/511/611/711/811/911). Setting `fictionalOnly="true"` is an explicit opt-in to the guaranteed-safe block instead. See `samples/pro/phone.xml` and its header comment for the same disclosure and data provenance (area codes from NANPA's own official public database).

### ProcessFlow  (Pro)
`com.obsvra.spicegrinder.pro.filters.ProcessFlow`

A queueing network: entities arrive, queue for the servers of a station, are served and move on or leave; the output is the event log, one event per row

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| input (multiple) | List | true | — | — | — | attrs: name,role. role="arrival": the gap to the next external arrival. role="service.&lt;Station>": one service time for an entity starting at that station. One one-column numeric input per role, each at least 0. |
| stations | String | true | — | — | — | Stations as Name:servers pairs, comma-separated, e.g. "Reception:2, Doctor:3" (1 server if :n is omitted; Name:inf is a delay station with unlimited servers; Name[3]:1 is a group of three stations, Name1 to Name3) |
| entry | String | false | — | — | — | Where external arrivals enter: one station, or Name:prob pairs that sum to 1 (default: the first station) |
| routing | String | false | — | — | — | Edges From>To:prob separated by ; or , where To may be exit (or back: the station the entity last left by a timeout); probabilities from one station sum to 1; a station with no edges sends everyone out |
| events | String | false | arrive,start,finish,exit | — | — | Which event types become rows: any of arrive, start, finish, exit, and with fleets or transit edges call, board, alight, and with trains on a network depart and denied (comma-separated); the simulation runs all of them. With fleets or transit edges the default also includes call, board and alight, and with trains depart and denied |
| output | String | false | events | — | — | events: one row per event. entities: one row per departed entity (and, with censored, per entity still inside at until) |
| maxInSystem | int | false | 1000000 | — | — | Safety cap on entities in the system at once; reaching it is an error that names the station and the row |
| rate | String | false | — | — | — | Makes the arrivals follow the clock: time:rate points, e.g. "7:0.4, 8.5:6, 10:2" (see details). The arrival input is then read in operational time: gaps of mean 1 give a Poisson stream at this rate |
| rateMode | String | false | step | — | step, linear | step: constant from each point to the next. linear: interpolated |
| ratePeriod | double | false | 0 | — | — | 0 for none; otherwise the rate profile repeats every ratePeriod |
| rateScale | double | false | 1 | — | — | A multiplier on every rate |
| rateStart | double | false | 0 | — | — | The profile's time at clock 0 (a day starting at 07:00 in clock hours: 7) |
| attributes | String | false | — | — | — | Names of the columns of the entity input (role="entity"), e.g. "class, size": numbers fixed for each entity at its arrival |
| priority | String | false | — | — | — | Station:attribute pairs, e.g. "ED:class": that station serves the lowest attribute value first, first come first served within a value, and never interrupts a service |
| serviceBy | String | false | — | — | — | Station:attribute pairs, e.g. "ED:class": that station has a service input per attribute value (role service.ED@1, service.ED@2, and service.ED or service.ED@* for the rest) |
| join | String | false | shortest | — | shortest, random | How an entity sent to a station group picks a member: shortest (fewest entities present, waiting plus in service) or random |
| ties | String | false | first | — | first, random | Among members with equally few entities: first (the lowest-numbered) or random |
| serviceScale | String | false | — | — | — | Station:expression pairs separated by ; e.g. "Lane: 0.9 + 0.1 * items": the station's service time is its service input's draw times the expression, evaluated over the entity's attributes (a group name covers every member) |
| until | Double | false | — | — | — | End the run at this clock time: events after it are not produced and the run ends there (an end of data, not an error). In events output the last row shows the state at the end, including inSystem |
| closes | Double | false | — | — | — | Stop external arrivals at this clock time; customers already in the system finish, and the run ends when the last has left |
| resources | String | false | — | — | — | Resource pools as Name:units pairs, e.g. "Room:4, Physician:3"; stations take units through needs |
| needs | String | false | — | — | — | Station:Pool + Pool pairs separated by ; e.g. "Treatment: Room + Physician": a service there starts only when a server and a unit of every listed pool are free, and holds those units for its length |
| keeps | String | false | — | — | — | Station:Pool pairs (the pool must be in that station's needs): the unit is not given back at the finish but stays with the entity until a station that releases it, or exit |
| releases | String | false | — | — | — | Station:Pool pairs: at the finish of a service there, a unit of that pool the entity holds (from keeps) is given back |
| batch | String | false | — | — | — | Station:min..max pairs (or Station:n), e.g. "Oven: 2..4": a free server takes between min and max waiting entities together, with one service draw for all |
| positions | String | false | — | — | — | Station:coordinate pairs, e.g. "Lobby:0, F2:4.5, F3:9": where the stations that vehicles reach lie on a line |
| fleets | String | false | — | — | — | Fleets as "Name:count option=value ..." separated by ;, e.g. "Car:4 capacity=8 speed=2 stop=5 load=0.5 home=Lobby dispatch=nearest" (options: capacity, speed, stop, load, home, dispatch = nearest, least-loaded or random) |
| carry | String | false | — | — | — | Routing edges carried by a fleet, From>To:Fleet separated by ;, e.g. "Lobby>F2:Car; F2>Lobby:Car": the entity calls a vehicle at From and arrives at To when it gets off |
| schedule | String | false | — | — | — | Station:time:servers points, e.g. "Runway: 0:2, 6:1, 9:2; Desk: 0:3, 8:5, 17:3": the number of servers follows the clock (a drop drains: no service is interrupted) |
| schedulePeriod | double | false | 0 | — | — | 0 for none; otherwise the schedules repeat every schedulePeriod |
| breakdowns | String | false | — | — | — | Stations (or groups) whose servers fail and are repaired for ever, e.g. "ATM"; needs inputs with roles up.&lt;Station> (time up) and down.&lt;Station> (repair time) |
| timeouts | String | false | — | — | — | Station:wait > target pairs separated by ;, e.g. "Lane: 10 > exit; Claims: 5 > Senior; Desk: patience > exit": an entity that has waited that long in the queue leaves it for the target (exit, a station or a group); patience is a draw of the input with role patience.&lt;Station>; age 30 puts the threshold on the time since the entity's arrival ("Claims: age 30 > Senior") |
| queueLimit | String | false | — | — | — | Station:limit > target pairs separated by ;, e.g. "Lane: 8 > exit; Desk: 20 > Overflow": an entity that finds that many or more waiting goes to the target instead of joining (0: no waiting room) |
| poolSchedule | String | false | — | — | — | Pool:time:units points, e.g. "Runway: 0:2, 6:1": the size of a resource pool follows the clock (repeats every schedulePeriod; a drop drains: units in use come back before the pool is free again) |
| contend | String | false | — | — | — | Stations in order of priority for the units of a shared pool, e.g. "Landing > Takeoff": when units come free, earlier stations start first; stations not named go last, the longest-waiting first |
| breakdownMode | String | false | — | — | — | Station:mode pairs separated by ;, e.g. "ATM: lose; Runway: resume": what a failure does to a service in progress. finish (the default) lets it end, resume continues it after the repair, repeat starts it again, lose sends the entity out (a lose row, then an exit) |
| stocks | String | false | — | — | — | Station: level=L reorder=R refill=Q [max=M] [delay=D] separated by ;, e.g. "ATM: level=50000 reorder=10000 refill=40000 delay=24": a stock used up by services (see uses) and refilled after a delay when it falls below R; no service starts without enough. Without delay, an input with role restock.&lt;Station> gives the delay |
| uses | String | false | — | — | — | Station:expression pairs separated by ;, e.g. "ATM: amount": how much of the station's stock a service takes, an expression of the attributes (1 if not given) |
| entityPeriod | double | false | 0 | — | — | 0 for none; otherwise the clock for entity@time inputs repeats every entityPeriod |
| censored | boolean | false | false | — | — | With output=entities and until: when the run reaches until, also write a row for each entity still inside (exitTime the horizon, its totals so far), and end every row with censored (1 for these rows, 0 for departed entities) |
| network | String | false | — | — | — | A network of transit lines, "Name: options; Line = A B C back\|loop hop=2 stop=0.5 turn=2 headway=6; ..." (network options walk, walk.&lt;Place>, places; line options hop, stop, turn, headway or trains with capacity, load and hold): least-expected-time routes between its places, for the route functions and the transit edges |
| transit | String | false | — | — | — | Routing edges ridden over the network, From>To: Network from=place to=place separated by ;, e.g. "Gate>exit: Metro from=o to=d": the entity rides its route from place from to place to (expressions of the attributes) and then arrives at To |

Stations, server counts, routing and the entry rule are attributes; arrival gaps and service times are ordinary input nodes (any distribution, an `Empirical` table, a fitted model) tagged with roles: `role="arrival"` gives the gap to the next external arrival, `role="service.<Station>"` gives one service time for an entity starting at that station. Each is a one-column numeric node producing values of at least 0, and a missing, repeated or unknown role is an error. Queues are first come first served. Time is dimensionless: whatever unit the gaps and service times use.

				`stations` is a comma-separated list of `Name:servers` (1 server if `:n` is left out). `Name:inf` (or `Name:*`) is a **delay station** with unlimited servers: nobody ever waits there for a server (every wait is 0 unless the station `needs` a resource, which makes entities wait for a unit of the pool; an arrive row still shows the entity joining for the instant before its start), `busy` counts the entities inside, and the station's service input is simply the time spent (a shopping stage before checkout, a transit, a cooking time); entities leave in the order their delays end. `entry` is the station external arrivals join, or `Name:prob, Name:prob` (default: the first station). `routing` lists edges `From>To:prob` separated by `;` or `,`, where `To` may be `exit`; the probabilities leaving one station must sum to 1, and a station with no edges sends everyone out. Every station an entity can reach must be able to reach `exit`.

				`output="events"` (the default) is one row per event: `time` (the clock; never decreases), `entity` (1, 2, 3, ... in order of arrival), `station` (0-based, in `stations` order; for `exit` the station the entity left), `type` (0 arrive, 1 start, 2 finish, 3 exit), `queue` (entities waiting at that station after the event), `busy` (its servers busy after the event) and `inSystem` (entities in the whole system after the event). An arrive event is the entity joining the queue, so it counts in `queue`; its start, in the same instant, takes it onto a server. `events` chooses which types become rows (default `arrive,start,finish,exit`); the simulation always runs all of them. Event rows are unevenly spaced, so average `queue` and `busy` weighted by the time each value lasted, not by row.

				`output="entities"` is one row per departed entity, with the columns in this order: `exitTime`, `entity`, `sojourn` (time in the system), `wait` (total time spent queueing over all visits), `service` (total service time), `visits`, then the attributes (in the order of `attributes`), then, with `fleets` or `transit`, `rideWait` and `ride`, then, with `transit`, `boardings`, then, with `timeouts` or `queueLimit`, `timeouts` and `balks`, then, when a `breakdownMode` entry is `lose`, `lost`, then, with `censored="true"`, `censored`; a column group that does not apply is absent, not zero. Plain averages over these rows are correct. With `until`, `censored="true"` also writes a row for each entity still inside when the run reaches the horizon (see the end of a run), with `censored` 1 for those rows and 0 for the departed; without it the entities still inside have no row, so the averages are over the ones that finished. At a delay station nobody queues, so for an entity that visits only delay stations `wait` is always 0 and `service` is the whole time it spent (its `sojourn`); `wait` is not 0 there only when the station `needs` a pool, whose wait counts as queueing.

				**Service time by an expression of the attributes.** `serviceScale="Lane: 0.9 + 0.1 * items; Shop: 4 + 0.8 * items"` (Station:expression pairs separated by `;`) makes a station's service time its service input's draw times the expression, evaluated over the entity's attributes by name, in the `Calculate` expression language (`+ - * /`, `sqrt`, `log`, `min`, `max`, `if`, ...). The input then holds the randomness (a Gamma or Exponential factor of mean 1, or a constant 1) and the expression the mean for this entity; the result must be finite and at least 0. A group name covers every member; it combines with `serviceBy`.

				**The end of a run.** `until` ends the run at a clock time: events after it are not produced, and the run ends there; in events output the last row is the last event before that time (there is no row at the horizon), so it shows the state at the end (`inSystem`, and each station's `queue` on its last row), and a time-weighted average must be extended to the horizon by hand. `output="entities"` has no row for an entity still inside unless `censored="true"`: then, when the run reaches `until`, one more row is written for each entity inside, in arrival order, before the end: `exitTime` is the horizon, `sojourn` its age (the horizon minus its arrival), `wait`, `service`, `rideWait` and `ride` the totals so far including the wait, service or ride in progress up to the horizon (a service suspended by a failure counts what was served before the failure; one to be repeated, none of it), `visits` the services begun (one in progress counts), the attributes, `timeouts` and `balks` so far, `lost` 0, and `censored` 1 (the last column, after `lost`). These are right-censored ages: the claims still open at the end and how long they have been open. `censored` needs `until` and `output="entities"` (with events output it is an error), and adds its column only when on, so a model without it is unchanged; with `closes` before `until` the system empties and no row is censored. `closes` stops external arrivals at a clock time: customers already inside finish, and the run ends when the last one has left. Both end the run with an end of data, not an error: `Grind`, the Service and the MCP server keep the rows produced and report that the model ended (a count larger than the model produces is fine). With both, whichever comes first.

				**Station groups: choosing among lanes.** `Lane[3]:1` makes a group of three one-server stations, `Lane1`, `Lane2` and `Lane3` (the count can be a declare: `Lane[${lanes}]:1`), and the name `Lane` stands for the group. Used as the `entry` or as the `To` of a routing edge, `Lane` sends the entity to the member with the fewest entities present (waiting plus in service) at the moment it joins, with `ties="first"` (the lowest-numbered, the default) or `ties="random"`; `join="random"` picks a member uniformly instead. Used as the `From` of an edge, `priority`, `serviceBy` or a service role (`service.Lane`), the name means every member, each with its own queue. An entity stays in the lane it joined. The `station` column names the member (0-based, in `stations` order). One shared line for the whole group is a single station with that many servers, which is a different system (a shorter wait). The cost estimate spreads a group target equally over its members.

				**Arrivals that follow the clock.** `rate` gives the arrival rate as `time:rate` points, `rate="7:0.4, 8.5:6, 10:2"`: constant from each point to the next (`rateMode="step"`, the default), or interpolated between points (`rateMode="linear"`, a ramp up to a peak and down). Before the first point the rate is the first point's, after the last it stays at the last point's; `ratePeriod` repeats the profile (a day: `ratePeriod="24"`); `rateScale` multiplies every rate; `rateStart` is the profile's time at clock 0. With `rate` the `arrival` input is read in operational time: each draw is the expected number of arrivals until the next, so an `Exponential` input of rate 1 gives exactly a Poisson stream whose intensity is the profile, and a more regular input (a gamma of mean 1) gives the same average rate with less variation. Without `rate`, the input is a gap in clock time, as before. If the rate is 0 from some time on (no period, last rate 0), the run stops with an error when the next arrival is due.

				**Entities with attributes.** An input with `role="entity"` draws the numbers that describe each entity once, at its external arrival; `attributes="class, size"` names its columns. Attributes are numbers (code a category as a whole number; a `Categorical` gives 0, 1, 2, ...). They can change how the network treats the entity: `priority="ED:class"` makes station `ED` serve its waiting entities lowest `class` first, first come first served among equals, and never interrupt a service that has begun (low-priority entities can wait without bound under heavy load; there is no ageing). `serviceBy="ED:class"` gives the station a service input per value: `role="service.ED@1"`, `role="service.ED@2"`, and `role="service.ED"` (or `@*`) for every other value; an entity whose value has no input and there is no default stops the run with an error. A routing edge may carry a condition on the station it leaves, `From[class=1]>To:prob`: an entity uses the group of edges whose condition it meets, otherwise the unconditional group, and a station with no unconditional group sends everyone else out; the probabilities of one group sum to 1; a condition can also name `escalated`, the entity's timeouts so far (see giving up below). The attributes are appended to every output row, after the existing columns. Not in this version: preemption, ageing, attributes that change, conditions other than equality, entry by attribute. The call weights for the cost estimate use the unconditional routing only.

				Events at the same clock time are ordered finish before arrival, then in the order they were scheduled. `maxInSystem` (default 1,000,000) stops a network whose arrivals exceed its capacity with an error that names the station and the row. **Resource sets.** `resources="Room:4, Physician:3"` names pools of units, and `needs="Treatment: Room + Physician; Consult: Physician"` makes a service at that station start only when a server is free and every listed pool has a free unit; it holds one unit of each for its length. Stations that name the same pool compete for it: when units come free, the station whose first waiting entity has waited longest starts first. The first entity of a queue that cannot start blocks those behind it. `keeps="Treatment: Room"` (the pool must be in that station's `needs`) keeps the unit with the entity when the service ends, through the stations after, until a service ends at a station whose `releases="Discharge: Room"` lists the pool, or the entity leaves. A station that needs a pool the entity already holds does not take another unit. With `resources`, every event row ends with the free units of each pool after the event, columns in `resources` order, after the attributes. A waiting time includes waiting for a resource.

**Batch service.** `batch="Oven: 2..4"` (or `Oven: 3` for exactly 3): a free server takes between the minimum and the maximum waiting entities together, in queue order, with one service draw (using the first one's attributes) that ends all their services at one instant; each has its own start, finish and routing rows. `busy` counts servers. Entities wait until the minimum has gathered, with no time limit. A resource a batch station needs is taken once per batch; a batch station cannot `keeps`, and a delay station cannot batch.

**State in the service time.** Besides the attributes, `serviceScale` can use `queue` (entities still waiting at the station when the service starts), `busy` (its busy servers, this one included), `inSystem` (entities in the whole network), `size` (the batch size) `time` (the clock when the service starts) and `escalated` (the entity's timeouts so far): `serviceScale="Ward: 1 + 0.02 * queue"` is a load-dependent service rate. An attribute with one of these names is an error.

**Vehicles.** Stations on a line carry a coordinate: `positions="Lobby:0, F2:7, F3:10.5"`. `fleets="Car:3 capacity=8 speed=1.6 stop=4 load=1.2 home=Lobby dispatch=nearest; Shuttle:1 capacity=20"` defines vehicles: `capacity` passengers, `speed` coordinate units per time unit, `stop` time lost at each stop, `load` extra time per passenger getting on or off, `home` the station they start at (default the first with a position) and `dispatch` (`nearest`, `least-loaded` or `random`). `carry="Lobby>F2:Car; F2>Lobby:Car"` marks routing edges (single stations on the line) that a fleet carries: an entity routed along such an edge makes a call at the first station after its service there, waits for a vehicle, and arrives at the second station when it gets off. A call is given to one vehicle when it is made (nearest: the one that can be there soonest; least-loaded: fewest passengers and assigned calls; random) and stays with it, unless another vehicle that stops there on its way, with room, taking the call's direction, takes it over. A vehicle keeps its direction while any destination of a passenger or any call it holds lies ahead, turns round only at a station when only the other direction has any, and waits where it is when it has nothing to do. Stations with the same coordinate are one place and one stop. At a place it stops if someone gets off or a call it holds, or one it may take over, is waiting; the waiting calls board in the order they were made up to capacity, its own whatever their direction; a stop takes `stop` plus `load` per passenger moved, and a caller who arrives while the doors are open steps in for only the `load` time. The `alight` and `board` rows are written when the stop begins, so a ride ends at the arrival, before the stop time at the destination. Passing a place costs only travel. Three more event types: `call` (4, the entity asks for a ride; `queue` is the number now waiting for a ride at that station), `board` (5) and `alight` (6); with fleets the default `events` includes them. Fleet rows end (after the attributes and the pool columns) with `vehicle` (0-based over all fleets, -1 on other rows) and `load` (passengers after the event); `output="entities"` gains `rideWait` and `ride` (total time waiting for a ride, and on board) after the attributes. A line only: no loops or networks (riders on a network of lines are `network` and `transit`, below), no destination dispatch, no breakdowns.

**Capacity that follows the clock, breakdowns, giving up and a full line.** `schedule="Runway: 0:2, 6:1, 9:2; Desk: 0:3, 8:5, 17:3"` gives a station a number of servers that follows the clock (`time:servers` points, constant from each to the next; before the first it is the first point's; `schedulePeriod="24"` repeats it). A drop drains: services in progress finish, nothing new starts until enough have; a rise starts waiting entities at once; 0 closes the station. `breakdowns="ATM"` (stations or groups) makes each server fail and be repaired for ever: its time up is a draw of the input with role `up.ATM`, its repair time a draw of the input with role `down.ATM`; a server that fails while serving finishes that service first and then goes down, one that is idle goes down at once; the servers available are the scheduled number minus the failed ones. `timeouts="Lane: 10 > exit; Claims: 5 > Senior; Desk: patience > exit"`: an entity that has waited that long in the station's queue (a number, or `patience`, a draw of the input with role `patience.Desk` made each time it joins) leaves the queue for the target, which is `exit` (it gives up) or a station or group (it is escalated or redirected); an entity in service is not affected. `Claims: age 30 > Senior` puts the threshold on the entity's age, the time since its external arrival, instead of its wait in this queue: it leaves the queue when its age reaches 30. One that is already that old when it joins still starts if a server is free; otherwise it joins and times out at the same instant (an arrive and a timeout row). It is the same `timeout` event and counter. Timeouts that could send an entity round to the same age timeout through queues it leaves at once (age timeouts and waits of 0) are an error. **Escalation and sending back.** `escalated` is the number of times the entity has left a queue by a timeout so far, a read-only number the model keeps (not an attribute and not a column; the `timeouts` column of entity output is its final value): a routing condition can use it, `Senior[escalated=1]>Claims:1`, and so can `serviceScale`. It is never reset, so a claim escalated a second time has `escalated=2`. The routing target `back` is the station whose queue the entity last left by a timeout (the member it left, for a group): `routing="Senior[escalated=1]>back:1"` returns an escalated claim to the team it timed out from, where it joins the queue again (its timeout there starts again) and leaves by that station's routing when served. `back` is for routing only (not a `timeouts` or `queueLimit` target) and needs `timeouts`; an edge to `back` that an entity could take before its first timeout is an error (put it under `[escalated=1]`, or on a station reached only by a timeout). Conditional groups are tried in the order they first appear in `routing`, and the first the entity meets is used. `queueLimit="Lane: 8 > exit; Desk: 20 > Overflow"`: an entity that finds that many or more waiting does not join and goes to the target (`exit` is balking, a loss system; a limit of 0 is no waiting room, an Erlang B system). Event types 7 `capacity`, 8 `down`, 9 `up`, 10 `timeout` and 11 `balk` are in the default `events` when the model can produce them; when the model has a `schedule`, a `poolSchedule` or `breakdowns` (not for timeouts or queue limits alone), event rows end (after the vehicle columns) with `servers`, the servers available at the row's station after the event; `output="entities"` has `timeouts` and `balks` (the times each happened to the entity) for a model with `timeouts` or `queueLimit`, in the place given with `output="entities"` above. None of these applies to a delay station. Not in this version: finite queues that block the previous station.

**Pools on the clock, who goes first, interrupted services, stocks, traffic mixes by clock.** `poolSchedule="Runway: 0:2, 6:1, 9:2"` makes a resource pool's size follow the clock (points `time:units`, repeating every `schedulePeriod`; a drop drains: units in use come back before the pool is free again, and the free count shows 0 meanwhile); each step is a `capacity` row (type 7) at the first station that needs the pool. `contend="Landing > Takeoff"` ranks stations that share a pool: when units come free the earlier station is served first (names joined by `+` or `,` share a rank; stations not named go last, the longest-waiting head first). `breakdownMode="ATM: lose; Runway: resume"` says what a failure does to a service in progress: `finish` (the default) lets it end, `resume` continues it after the repair with the time that was left, `repeat` starts it again with the same length, `lose` sends the entity out (a `lose` row, type 12, then its exit; entity output then ends with `lost`, as listed with `output="entities"`). `stocks="ATM: level=50000 reorder=10000 refill=40000 max=100000 delay=24"` gives a station an amount that each service uses (`uses="ATM: amount"`, an expression of the attributes, 1 if not given) when it starts and cannot start without; when the level falls below `reorder` a refill of `refill` is ordered and arrives `delay` later (or after a draw of the input with role `restock.<Station>`); the arrival is a `restock` row (type 13), and event rows carry each stock's level after the event (station order, after the pool columns). Inputs with role `entity@120` take over the `entity` role from clock time 120 (all with the same columns; `entityPeriod` repeats the pattern), so the mix of entities can follow the clock. Fleet options: `board=direction` (a vehicle boards the calls it holds only when going their way or with nothing else to do; usually worse where every call goes to or from one station), `redispatch=T` (a call that has waited T is given to the best vehicle then, and checked again every T) and `park=Station` (an idle vehicle goes to that station).

**Transit networks.** `network="Metro: walk=3 places=A,B,C,D,E; Red = A B C D back hop=2 stop=0.5 turn=2 headway=6; Blue = B E C loop hop=2 stop=0.5 headway=5"` declares a network of lines: after the network's name, its options `walk` (the time to change trains, default 0), `walk.C=5` (at one place) and `places=` (the places in order, for their 0-based numbers; default the order in which the lines first name them); then each line, `Name = places`, `back` (out and back: the line runs to its last place and back) or `loop` (one way round, from the last place on to the first), and `hop` (the time between neighbouring places; `hop.A-B=3` for one segment), `stop` (the time stopped at each place passed, default 0), `turn` (at each end of a back line, default 0) and `headway` (the expected time between trains). A place may be on several lines (that is where riders change) but only once on each, and every place must be reachable. Values may be constant expressions of declares (`headway=24/${trains}`). When the model is configured the network works out the route with the least expected time between every pair of places: each boarding costs half the line's headway in expected waiting, riding the hops and the stops (and turns) passed, each change the walk at the place; ties go to fewer boardings, then to the lower legs in order (the line in declaration order, the boarding position along the line, the earlier stop to get off). Routes are static: they do not react to crowding or to the waits a rider meets. The route functions are available in `serviceScale`, `uses` and the transit expressions: `routetime(o, d)` (the expected journey time), `routelegs(o, d)` (boardings; 0 from a place to itself) and, for leg `k` (0-based), `routeline`, `routeboard`, `routealight` (places), `routeride` (its ride time) and `routeheadway` `(o, d, k)`; places and lines are 0-based, a place or leg outside the network is an error at the row; elsewhere these are unknown functions. `transit="Gate>exit: Metro from=o to=d"` marks routing edges (`From` a station or group, `To` a station, a group or `exit`) that ride the network: the entity routed along one goes from place `from` to place `to` (expressions of the attributes, rounded down) by its route, leg by leg at rider level, and then arrives at `To` (or leaves). On a line without trains (rider level): at each boarding it waits a uniform draw between 0 and the headway (one number from the node's stream, drawn on reaching the platform), rides the leg's ride time, and walks the place's walk before the next leg; a ride from a place to itself takes no time and writes no rows. It writes `call` (reaching a platform), `board` and `alight` rows; on these `station` is the station the ride left and `queue` the riders waiting on that platform (a line, a place and a direction) after the event, and with `transit` every event row ends (after the vehicle columns) with `place` and `line` (-1 on other rows), while `vehicle` and `load` are -1 and 0 on transit rows. The default `events` includes the three types. `output="entities"` gains `rideWait` (waiting on platforms), `ride` and `boardings`; the walking is the rest of the sojourn. A model without `network` is unchanged; a network alone, used only by the route functions, adds no columns. **Trains.** A line with `trains=N` runs real trains instead of the drawn waits: `Red = A B C D back hop=2 stop=0.5 turn=2 trains=4 capacity=200 load=0.02 hold=on`. `capacity` is the riders a train holds (default unlimited), `load` the extra stop time per rider who gets on or off (default 0) and `hold=on` keeps a train at the first place of its line until a headway has passed since the last train left it (default off). A line with trains has no `headway` (giving both is an error): its headway, for the routes, is the time round the line over the trains, where the time round is every hop plus the stop at every place plus the turn at both ends of a back line. The N trains start evenly spaced round that cycle at time 0 (train 0 leaving the first place at time 0) and run for ever. A train stops at every place: first the riders whose leg ends there get off (`alight`), then the riders waiting on that platform (this line, this place and direction) board in the order they came, up to `capacity` (`board`); the stop takes `stop` (and `turn` at an end of a back line) plus `load` per rider moved from its arrival, a rider who reaches the platform while the doors are open and there is room steps in and adds `load`. Each rider still waiting when the train leaves writes a `denied` row and waits for the next train; then the train leaves (`depart`) and reaches the next place a hop later. One train stands at a platform at a time: a train that arrives while another is there waits behind it and stops when it has left, so trains never overtake and a late train drags those behind it (bunching). Routes stay the static routes from the headways: a rider does not change its route because a train is full. A network may mix lines with trains and lines without (rider level). The new event types are `depart` (14) and `denied` (15), both in the default `events` of a model with trains; on `board`, `alight` and `denied` rows `vehicle` is the train (0-based over all trains, after any `fleets` vehicles) and `load` the riders aboard after the event; a `depart` row belongs to no entity (entity 0, attributes 0, `station` -1) and carries the train's `load`, the `place` and `line` it left and, in `queue`, the riders left on the platform, so loads along a line can be read from the depart rows; a `call` row keeps `vehicle` -1. `output="entities"` gains `denied` (the times the entity was left behind) after `boardings`. Trains draw no random numbers, so a model whose lines all have trains adds nothing random to the run. With `until`, a rider on a platform or aboard a train counts its wait or ride so far. Not in this version: breakdowns of trains, timetables, express service or short turns, platform capacity, routes that react to what a rider sees.

Not in this version: preemption or any discipline but first come first served and priority by attribute, a time limit on a batch.

### ServiceCall  (Pro)
`com.obsvra.spicegrinder.pro.filters.ServiceCall`

Wrap a local or remote HTTP service call as a data source or transform

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| url | String | true | — | — | HTTP endpoint POSTed to for each round of the exchange (e.g. http://localhost:9000/rules). Must match an entry on service.url.allowlist (scheme, host and port, plus the entry's path at a '/' boundary; no userinfo) -- disabled by default, see UserPreferences. |
| outputs | String | true | — | — | Comma-separated value type per output position, e.g. "numeric,string". Position count fixes this filter's dimension. |
| timeoutMs | long | false | 5000 | — | Per-HTTP-call timeout in milliseconds. |
| maxRounds | int | false | 25 | — | Safety bound on need/provide round trips within one exchange before aborting -- protects against a misbehaving or malicious service that never returns a result. |
| headers | String | false | — | — | Semicolon-separated static Name=Value header pairs (e.g. for a bearer auth token). No per-call token refresh. |

### StateWrite  (Pro)
`com.obsvra.spicegrinder.pro.filters.StateWrite`

Passes its input through unchanged and writes its columns into SharedState cells at the end of the row

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| cells | String | true | — | — | Cells to write, one per input column, comma-separated |
| mode | String | false | set | — | set replaces the cell's value; add adds the input to it |

Writes each input column into the matching cell of `cells` (the first column to the first cell, and so on); the number of cells must equal the input's dimension. A range stands for a block of cells (`cells="queue[1..20]"` is `queue1` to `queue20`), and a `-` marks an input column that is not stored: `cells="a, -, b"` stores columns 0 and 2 and passes column 1 through (`-[1..3]` is three skipped columns), so a value that is only wanted as output needs no cell of its own. The output is the input, unchanged, so a write can sit in a series that is also recorded. `collaborate.state="StoreName"` names the `SharedState` to write; it is not an `<input>`.

`mode="set"` (the default) replaces the cell's value; `mode="add"` adds the input to it. A cell may have at most one `set` writer and any number of `add` writers. Writes take effect at the end of the row, so reads in the same row still see the old value, and reads in the next row see the new one. To subtract, add a negative number (for example `Calculate` with `y[0] = -x[0]` in front). The input must be numeric. A cell that is not in the store, or a second `set` writer for a cell, is reported when the model is validated or on the first row, before any output row.

### Time  (Pro)
`com.obsvra.spicegrinder.business.filters.Time`

Generates a time of day from an hour input, uniform over that hour's minutes/seconds

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single numeric-valued input supplying the hour, [0, 23] |
| format | String | false | — | — | DateTimeFormatter pattern for the produced TimeDataPoint's stringValue() (default: HH:mm:ss) |

`Date`'s exact sibling for time of day: hour is a plain composed `<input>` (any numeric distribution), minute/second are drawn uniformly within that hour internally. No `minAge`/`asOf`-style constraint parameter — unlike `Date`'s day-of-year piece there's no leap-style correctness landmine here (every hour has exactly 60 minutes, every minute exactly 60 seconds), and a "business hours only" constraint falls out for free by restricting the hour input's own range rather than needing a dedicated parameter.

### UserAgent  (Pro)
`com.obsvra.spicegrinder.business.filters.UserAgent`

Generates an HTTP User-Agent string from a browser/OS input

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single input supplying dimension-2 [browser, osFamily] |

Real browser/OS market share (StatCounter, hand-combined nominally — see the reference CSV's own header comment) drives which real-format UA string template gets assembled; current major version numbers (Chrome 152, Firefox 153, Edge 151, Safari 26.6, Samsung Browser 30.x, mid-2026) are hardcoded in `UserAgent.java` rather than read from the table, so the table doesn't need updating on every browser release. Four of five browsers are deterministic per major version by construction — Chrome/Edge/Samsung Browser's frozen `X.0.0.0` build tag and Firefox's `X.0` are both real conventions (Chrome's own User-Agent Reduction initiative), not simplifications. Safari's real point-release variance (`Version/26.0` through `26.6` in 2026) is the one case with genuine internal randomization. No `fictionalOnly` toggle, unlike `Phone`/`CreditCard` — a UA string carries no PII-collision concern in the first place. See `samples/pro/useragent.xml` and its header comment for the full disclosure and data
provenance.

### VIN  (Pro)
`com.obsvra.spicegrinder.business.filters.VIN`

Generates a 17-character Vehicle Identification Number from a WMI input

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| input | IGenerator | true | — | — | Single input supplying a real 3-character WMI (World Manufacturer Identifier) |

Positions 4-8 (VDS) and 11 (plant code) are drawn from the real 33-character VIN alphabet (digits + uppercase letters, excluding I/O/Q). Position 9 is a real check digit computed via the exact NHTSA/ISO 3779 algorithm (transliteration + weighted sum mod 11, 'X' for a remainder of 10). Position 10 is a real model-year code from the standard's own 30-symbol cycle (deliberately not resolved to an absolute year, since the encoding repeats every 30 years by design). Positions 12-17 are a 6-digit random sequential-production number. No `fictionalOnly` toggle: no standards body publishes an officially reserved "guaranteed safe" VIN block. See `samples/pro/vin.xml` and its header comment for the full disclosure and WMI data provenance.
