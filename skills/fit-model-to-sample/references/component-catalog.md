# Component Library Reference

> © 2026 Obsvra. This document describes SpiceGrinder and is provided to help you evaluate and use it. It is not a license to reproduce, adapt, or use this material to build a competing product or service. Full terms: the SpiceGrinder EULA.

Generated from the components' `@ComponentInfo`/`@Parameter` annotations by `library --markdown docs/Component-Library-Reference.md --write`, which keeps the explanatory text written under each component; a test fails if this file and the annotations disagree. For a live, always-current view straight from the registry, use `ComponentLibraryApp`(1) instead — see [ComponentLibraryApp.md](ComponentLibraryApp.md).

Including all Pro components, there are 84 components: 48 generators, 36 filters.


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
| scale | double | false | 1.0 | theta | Scale parameter (> 0); a 'rate' attribute (or its synonym 'beta') is also accepted as 1/scale |

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

Mutable counter usable as a normal generator or a Collaborate target -- collaborate() reads current state without advancing it

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| initial | double | false | 0 | — | Starting counter value |

### Database  (Pro)
`com.obsvra.spicegrinder.pro.generators.Database`

Sample rows from a database table/query

| Parameter | Type | Required | Default | Aliases | Allowed Values | Notes |
|---|---|---|---|---|---|---|
| url | String | true | — | jdbcurl,connection | — | JDBC connection URL (e.g. jdbc:h2:~/test). Must match a prefix on database.url.allowlist -- disabled by default (empty allowlist), see UserPreferences. |
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
| file | String | true | — | filename,path | — | Path to the CSV file. A relative path is looked for beside the model first, then in the working directory, and always works; an absolute path must start with a prefix on flatFile.path.allowlist in preferences.properties, which is empty (so absolute paths are refused) by default |
| skipHeader | boolean | false | false | header | — |  |
| delimiter | String | false | , | sep,separator | — |  |
| textColumns | String | false | — | text,textcolumn | — | Columns to keep as text even when their cells look like numbers (ZIPs, codes, account numbers): 0-based file column indexes or header names (names need skipHeader), comma-separated |
| mode | String | false | unweighted | — | sequential, unweighted, weighted | sequential \| unweighted \| weighted |
| onExhaustion | String | false | error | exhaustion,onend | error, repeat, hold, null | error \| repeat \| hold \| null (sequential only) |
| weightColumn | String | false | 0 | weight,weightcol,weightindex | — | 0-based index or column name for weighted mode (default 0) |

**Cell types.** A cell that reads as a plain decimal number (`42`, `-3.5`, `1e6`) becomes a number; anything else stays text (`NaN`, `Infinity` and codes like `3074F` stay text). A column whose values only look like numbers, such as ZIP codes, account numbers or procedure codes, belongs in `textColumns`: every cell in it stays text, so `02134` keeps its leading zero instead of printing as `2134.0`. Quoting a cell doesn't change its type. Column indexes count the file's own columns, the weight column included, the same numbering as `weightColumn`; the weight column itself can't be a text column.

A relative `file` is looked for beside the model file first (the folder of the model being loaded, as an `Import`'s path is), then in the working directory of the process reading it, so a table shipped next to its model (such as one `tables --extract` wrote) is found wherever the model is run from, and paths written relative to a project root (every bundled `samples/pro/*.xml`) keep working. A model submitted as text has no folder of its own: under `ModelServiceApp`, that process is the server, not the caller — see [Service API Reference](Service-API-Reference.md#file-paths-in-submitted-models) for what path to use when the model is submitted to a service rather than run locally.

**Relative vs. absolute, and the `flatFile.path.allowlist` gate.** A relative `file` (every bundled `samples/pro/*.xml` uses one) always resolves — it can only ever reach somewhere the deploying process's own working directory already makes reachable, which the deployer controls regardless of who's submitting models. An absolute path names anywhere on the filesystem directly, so it's gated the same safe-by-default way `Database`'s `database.url.allowlist`/`ServiceCall`'s `service.url.allowlist` already are: empty allowlist (the default) means every absolute `file` value is rejected outright, not silently allowed. Add real, symlink-resolved directory prefixes to unlock specific locations — on macOS in particular, `/tmp` is itself a symlink to `/private/tmp`, so an allowlist entry has to name `/private/tmp/...`, not `/tmp/...`, or it will never match. This applies regardless of whether the model came from a local file or `ModelServiceApp` — a malicious/untrusted model read locally carries the same arbitrary-file-read risk as one submitted over HTTP.

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

Single-node weighted mixture: component specs inline instead of separate nodes + Mix

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| components | String | true | — | — | Semicolon-separated 'Type(param=val,param=val):weight' specs, at least 2 |

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

### SSN  (Pro)
`com.obsvra.spicegrinder.business.generators.SSN`

Generates a US Social Security Number, real allocatable range by default

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| fictionalOnly | boolean | false | false | — | When true, restrict the area number to [900, 999] -- the SSA's own published rule states this range has never been, and never will be, allocated to a real person -- guaranteed safe at the cost of an obviously-synthetic-looking area number. When false (default), area is drawn from the real historically-allocatable [001, 899] range (excluding 666), so a generated number could in principle match a real person's actual SSN. |

No composed input, same shape as `IPAddress`. Same collision-without-PII shape as `Phone`, and the same restricted-range-toggle design carried forward from it. See `samples/pro/ssn.xml` and its header comment for the full disclosure.

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

Each assignment sets one output value from the input values `x[0]`, `x[1]`, ...; an output not assigned passes its input through. Operators `+ - * /` and parentheses, numeric literals, and functions: `floor`, `ceiling` (or `ceil`), `round`, `abs`, `sqrt`, `exp` (e to the power x) and `log` (or `ln`, the natural logarithm) take one argument; `min`, `max`, `mod` and `pow` take two. Results are always decimal numbers; end with `ToInteger` when a whole number should print as one. `exp` and `log` follow standard math: `log(0)` is negative infinity and `log` of a negative number is NaN. Example, a multivariate lognormal from a `MultivariateNormal` fitted to the logs of two skewed columns: `y[0] = exp(x[0]); y[1] = exp(x[1])`.

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

### Redimension  (Free)
`com.obsvra.spicegrinder.core.defaults.filters.Redimension`

Reshapes a single input stream to a new output dimension

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| dimension | int | true | — | outputdimension,dim | Output dimension (DataPoints per Observation) |

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

Combines its own input with one or more Collaborate targets' current values

No `@Parameter`-declared fields (a plain `<input>` child wires this filter's own data source, same as any ordinary filter; `collaborate.<role>="TargetName"` node-tag attributes, not `@Parameter`-discoverable, name any number of Collaborate peers separately — see [Model File Format Reference](Model-File-Format-Reference.md#collaborate-references-pro)).

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
| wordListFile | String | false | samples/pro/email_words.txt | — | Path to the word list used when nameBased=false |
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

### ServiceCall  (Pro)
`com.obsvra.spicegrinder.pro.filters.ServiceCall`

Wrap a local or remote HTTP service call as a data source or transform

| Parameter | Type | Required | Default | Aliases | Notes |
|---|---|---|---|---|---|
| url | String | true | — | — | HTTP endpoint POSTed to for each round of the exchange (e.g. http://localhost:9000/rules). Must be on service.url.allowlist -- disabled by default, see UserPreferences. |
| outputs | String | true | — | — | Comma-separated value type per output position, e.g. "numeric,string". Position count fixes this filter's dimension. |
| timeoutMs | long | false | 5000 | — | Per-HTTP-call timeout in milliseconds. |
| maxRounds | int | false | 25 | — | Safety bound on need/provide round trips within one exchange before aborting -- protects against a misbehaving or malicious service that never returns a result. |
| headers | String | false | — | — | Semicolon-separated static Name=Value header pairs (e.g. for a bearer auth token). No per-call token refresh. |

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
