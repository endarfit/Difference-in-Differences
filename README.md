# 📊 Monte Carlo Simulations for Basic Difference-in-Differences (DiD) Models

This repository contains R scripts for Monte Carlo simulations of various basic **Difference-in-Differences (DiD)** models, including both canonical and extended versions with covariates and larger samples.

## 🎯 Purpose

The goal is to explore how the **estimated treatment effect (θ)** behaves under different DiD setups using simulated data. We compare:

1. The **canonical 2x2 DiD** structure with only 2 units and 2 time periods.
2. The impact of adding **covariates** to the canonical model.
3. A more realistic case with **100 units** (50 treated, 50 control) over 2 periods.
4. The same large-sample setup with **covariates** included.

By plotting the distribution of estimates across **1,000 simulations**, we observe how sample size and model complexity affect the **bias** and **variance** of DiD estimators.

---

## 🧪 Models Simulated

| Model ID | Description                                      | Units | Time Periods | Covariates | File Name |
|----------|--------------------------------------------------|--------|---------------|-------------|------------|
| 1        | Canonical 2x2 DiD (baseline)                     | 2      | 2             | No          | `Canonical DiD.R` |
| 2        | Canonical 2x2 DiD with Covariates                | 2      | 2             | Yes         | `The Canonical DiD with Covariates.R` |
| 3        | 50 Treated + 50 Control DiD                      | 100    | 2             | No          | `50 Treated + 50 Control DiD.R` |
| 4        | 50 Treated + 50 Control DiD with Covariates      | 100    | 2             | Yes         | `50 Treated + 50 Control DiD with covariates.R` |

Each model estimates the treatment effect θ = 2 and (if included) a covariate effect β.

---

## 📈 Visualization

A combined script (`compare_did_models.R`) is included to:
- Run all 4 models side by side,
- Plot histograms of estimated treatment effects,
- Visualize the differences in estimator precision and spread.

You will see 4 histograms comparing:
- Small vs. large sample behavior,
- With vs. without covariates.

---

## 💡 Key Insights

- The **canonical 2x2 DiD** is useful for teaching but too small for reliable inference.
- Adding covariates in very small samples causes **collinearity** and unstable estimates.
- **Larger samples** dramatically improve precision.
- Including **informative covariates** in larger samples further reduces variance.

---

## 🧰 Requirements

- R (≥ 4.0)
- `fixest` package for fixed effects estimation:
  ```r
  install.packages("fixest")
