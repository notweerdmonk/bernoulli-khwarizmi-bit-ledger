---
layout: default
title: The Bernoulli–Khwarizmi Experiment
permalink: /
---
<script>
  window.MathJax = {
    tex: {
      inlineMath: [
        ["\\(", "\\)"],
        ["$", "$"]
      ],
      displayMath: [
        ["\\[", "\\]"],
        ["$$", "$$"]
      ]
    }
  };
</script>
<script
  async
  src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js">
</script>
# The Bernoulli–Khwarizmi Experiment

_**A computational experiment in randomness, probability, and convergence.**_

---
<br>

[![Request a coin toss](https://img.shields.io/badge/Request-coin%20toss-blue)](https://github.com/notweerdmonk/bernoulli-khwarizmi-bit-ledger/issues/new?template=coin-toss.yml)
<br>
<br>

<!-- COIN_STATS_START -->
## Current Results

- Total tosses: 8
- Number of ones: 3
- Current probability estimate: 0.37500000
- Current percentage of ones: 37.500000%

The current estimate is calculated as:

```text
number of ones / total tosses
```
<!-- COIN_STATS_END -->
<br>

---
<br>

## Prologue

A coin toss is among the simplest experiments in probability: two outcomes,
one observation at a time. Yet from this elementary act emerges one of the
central ideas of mathematical statistics—the possibility that the irregular
behavior of individual observations can exhibit remarkably stable structure
when viewed in aggregate.

reanalyzed as the experiment grows.
The **Bernoulli–Khwarizmi Experiment** explores this phenomenon computationally.
A C program obtains one random binary outcome from the Linux operating system
for each workflow execution. The outcome is recorded, accumulated, and
reanalyzed as the experiment grows.

The experiment is named for two figures whose intellectual legacies meet in this
small computation. **Jacob Bernoulli** helped establish the mathematical study
of repeated random trials and the law of large numbers. **Muhammad ibn Musa
al-Khwarizmi** stands at the historical foundations of systematic calculation
and the algorithmic tradition from which modern computation descends.

Here, probability and algorithm meet in their most elementary common form: **a
sequence of binary observations**.

The experiment therefore asks a modest but fundamental question:

> **As the number of observations grows, how does their empirical frequency behave?**

For a fair binary experiment, the theoretical probability of either outcome is

\\[
\frac{1}{2}
\\]

The observed proportion need not equal one half at any particular point. It may
wander above it, fall below it, and sometimes depart from it substantially. What
matters is its behavior over an increasing number of observations.

Under the usual assumptions of **independence** and a **stable underlying
distribution**, the law of large numbers predicts that the empirical proportion
converges to the underlying probability.

This repository is a record of that convergence—or, more precisely, of the
**evidence produced by the experiment as it proceeds**.

> **Important:** This experiment is not a proof of randomness, nor a proof that the underlying probability is exactly one half. A finite collection of observations can provide evidence consistent with a model, or evidence against it; it cannot establish an unknown probability with mathematical certainty.

## Experiment

Each workflow execution generates exactly **one random binary outcome**:

- `1` — interpreted as **heads**
- `0` — interpreted as **tails**

The outcome is obtained from the Linux operating system's `getrandom()` system
call.[^getrandom] The C program does not maintain its own pseudorandom state;
randomness is requested directly from the operating system.

Each successful result is appended to [`tosses.csv`](tosses.csv), together with
a **UTC timestamp**. The repository therefore maintains an explicit
chronological record of the observations rather than retaining only the latest
aggregate.

The `README` is subsequently updated with:

- the **cumulative number of observations**;
- the **number of ones** observed; and
- the **empirical proportion of ones**.

For \\(n\\\) observations, let \\(X_i\in\{0,1\}\\) denote the \\(i\\)-th outcome. The cumulative number of ones is

\\[
S_n = \sum_{i=1}^{n} X_i,
\\]

and the corresponding empirical proportion of ones is

\\[
\widehat{p}_n = \frac{S_n}{n}.
\\]

For a fair binary experiment, the expected limiting value is

\\[
\widehat{p}_n \longrightarrow \frac{1}{2}
\qquad\text{as } n\to\infty.
\\]

The experiment does not expect the observed proportion to approach \\(\frac{1}{2}\\)
monotonically. Rather, the proportion is expected to fluctuate around the
theoretical probability, with those fluctuations becoming relatively smaller as
the number of observations increases.

## Mathematical formulation

Let

\\[
X_i =
\begin{cases}
1, & \text{if the } i\text{-th outcome is } 1,\\
0, & \text{if the } i\text{-th outcome is } 0.
\end{cases}
\\]

Let

\\[
p = P(X_i = 1).
\\]

The hypothesis that the generator is fair is

\\[
H_0: p = \frac{1}{2}.
\\]

The corresponding two-sided alternative is

\\[
H_1: p \ne \frac{1}{2}.
\\]

After \\(N\\) recorded outcomes, let

\\[
H_N = \sum_{i=1}^{N} X_i
\\]

denote the number of ones. The cumulative empirical proportion of ones is

\\[
\widehat{p}_N = \frac{H_N}{N}.
\\]

The experiment estimates \\(p\\) using the observed proportion
\\(\widehat{p}_N\\). This is an estimate based on the recorded data, not the
actual probability \\(p\\). The experiment does not prove with certainty that
\\(p = \frac{1}{2}\\).

Thus \\(\widehat{p}_N\\) is an estimator of the underlying probability \\(p\\).
It is a quantity computed from the observed data; it is not itself the
probability being estimated.

The distinction is important. Even if the underlying process has
\\(p = \frac{1}{2}\\), a finite observation sequence will almost never satisfy
\\(\widehat{p}_N = \frac{1}{2}\\) exactly. Conversely, an empirical proportion
close to one half does not establish that the underlying probability is exactly
one half.

## Expected behavior

Under the fairness hypothesis, and assuming independent and identically

\\[
X_i \sim \operatorname{Bernoulli}\left(\frac{1}{2}\right),
\\]

Consequently,

\\[
\mathbb{E}[X_i] = \frac{1}{2}
\\]

and

\\[
\operatorname{Var}(X_i) = \frac{1}{4}.
\\]

These are the expectation and variance of a Bernoulli random variable with
success probability \\(\frac{1}{2}\\).[^bernoulli]

Assuming the outcomes are independent and identically distributed, the law of
large numbers states that

\\[
\widehat{p}_N \longrightarrow p
\\]

as \\(N\\) tends to infinity.[^lln] Therefore, under the fairness hypothesis
\\(H_0\\),

\\[
\widehat{p}_N \longrightarrow \frac{1}{2}.
\\]

This convergence should not be interpreted as monotonic motion toward one
half. The empirical proportion is itself random and may repeatedly cross the
value \\(\frac{1}{2}\\). What diminishes with increasing N is the typical scale
of its fluctuation.

For independent Bernoulli trials with \\(p = \frac{1}{2}\\),

\\[
\operatorname{Var}(\widehat{p}_N)
= \frac{p(1-p)}{N}
= \frac{1}{4N}
\\]

so the standard deviation of the empirical proportion is

\\[
\operatorname{SD}(\widehat{p}_N)
= \frac{1}{2\sqrt{N}}
\\]

Thus the characteristic scale of statistical error decreases on the order of

\\[
\frac{1}{\sqrt{N}}
\\]

rather than \\(\frac{1}{N}\\). Obtaining another decimal place of typical
precision therefore requires roughly one hundred times as many observations.

Concentration inequalities provide stronger finite-sample statements. For
example, Hoeffding's inequality gives, for independent Bernoulli observations,

\\[
P\left(\left|\widehat{p}_N-p\right|\ge\varepsilon\right)
\le 2e^{-2N\varepsilon^2}.
\\]

This bound concerns the probability of a deviation of a specified magnitude;
it does not assert that the observed proportion must lie within that magnitude
at every finite N.

## Statistical hypothesis test

For a fixed number \\(N\\) of observations, the number of ones under \\(H_0\\) has
the binomial distribution

\\[
H_N \sim \operatorname{Binomial}\left(N, \frac{1}{2}\right).
\\]

An exact two-sided binomial test can therefore be used to calculate the
probability, under \\(H_0\\), of obtaining a result at least as extreme as the
observed number of ones.[^binomial]

For a chosen significance level such as

\\[
\alpha = 0.05,
\\]

the conventional decision rule is:

- reject \\(H_0\\) if the p-value is less than \\(0.05\\);
- otherwise, fail to reject \\(H_0\\).

The phrase **fail to reject** is deliberate. A non-significant result is not
evidence that \\(p = \frac{1}{2}\\) has been proved. It means only that the
observed data do not provide sufficient evidence, at the chosen significance
level, against the null model.

Moreover, repeatedly inspecting the result and performing a hypothesis test
after every newly recorded observation introduces additional statistical
considerations. The experiment's cumulative display is therefore primarily a
record of empirical behavior and convergence; it should not be interpreted as
a sequence of independent confirmatory tests without accounting for the
sequential nature of the observations.

## Interpretation

The central prediction of the experiment is the conditional statement

\\[
p = \frac{1}{2}
\quad\Longrightarrow\quad
\widehat{p}_N \longrightarrow \frac{1}{2}
\\]

as \\(N\\) grows, provided the assumptions required by the law of large numbers
are satisfied.

The converse does not follow. Observing an empirical proportion close to
\\(\frac{1}{2}\\) does not prove that the underlying probability is exactly
\\(\frac{1}{2}\\). Likewise, even if \\(p=\frac{1}{2}\\), finite samples will
generally fluctuate around \\(\frac{1}{2}\\).

The experiment therefore provides empirical evidence about the behavior of the
random-number source under a specified statistical model; it does not prove
the exact value of the underlying probability or establish randomness with
certainty.

The interpretation of the accumulated results depends on several assumptions:

- outcomes are sufficiently independent;
- the underlying probability distribution remains stable over time;
- each successful workflow execution contributes its intended observation;
- previously recorded observations are not selectively removed or altered.

## What the experiment can—and cannot—show

The central mathematical prediction is the conditional statement

\\[
p=\frac{1}{2}
\quad\Longrightarrow\quad
\widehat{p}_N \longrightarrow \frac{1}{2}.
\\]

under the assumptions required by the law of large numbers.

The converse does not follow:

\\[
\widehat{p}_N \approx \frac{1}{2}
\quad\not\Longrightarrow\quad
p=\frac{1}{2}.
\\]

A biased process can produce a finite sample whose empirical proportion is
close to one half. Likewise, a fair process can produce a finite sample whose
empirical proportion is noticeably different from one half.

The experiment consequently illustrates a fundamental distinction between
**probability** and **observation**. Probability describes the model of the
generating process; empirical frequency describes what has actually been
observed. The latter becomes informative about the former through statistical
reasoning, not through identity.

## Experimental assumptions

The interpretation of the accumulated data depends on several assumptions and
engineering properties:

- **Independence:** successive outcomes should be sufficiently independent for
the probabilistic model being used.
- **Stationarity:** the underlying probability distribution should not change
systematically over the course of the experiment.
- **Completeness:** each successful workflow execution should contribute its
intended observation to the ledger.
- **Integrity:** previously recorded observations should not be selectively
removed or altered.
- **Correctness:** the C program and the surrounding workflow should correctly
interpret and record the operating system's random output.
- **Model validity:** statistical conclusions should be understood as
conditional on the assumptions of the model rather than as absolute
demonstrations of physical randomness.

The distinction between the **randomness source** and the **statistical model**
is particularly important. `getrandom()` supplies bytes from the Linux kernel's
randomness interface; the mathematical claim that the resulting binary
outcomes constitute independent Bernoulli trials is a modeling assumption
that must be considered separately.

## Computational design

The experiment deliberately keeps the computational state minimal.

The C program obtains randomness from the operating system and emits a single
binary result. Persistent experimental state is maintained by the repository
itself in `tosses.csv`, while the workflow is responsible for executing the
program and incorporating the resulting observation into the historical
record.

This separation makes the experiment reproducible at the level of its
mechanism:

operating-system randomness → C program → binary observation →
persistent ledger → cumulative statistics

The repository is therefore not merely a coin-flip simulation. It is a small
computational apparatus for observing how a sequence of random binary outcomes
behaves when accumulated over time.

## References

[^bernoulli]: [Bernoulli distribution — Wikipedia](https://en.wikipedia.org/wiki/Bernoulli_distribution)
[^binomial]: [Binomial test — Wikipedia](https://en.wikipedia.org/wiki/Binomial_test)
[^lln]: [Law of large numbers — Wikipedia](https://en.wikipedia.org/wiki/Law_of_large_numbers)
[^hoeffding]: [Hoeffding's inequality — Wikipedia](https://en.wikipedia.org/wiki/Hoeffding%27s_inequality)
[^getrandom]: [getrandom(2) Linux manual page](https://man7.org/linux/man-pages/man2/getrandom.2.html)
