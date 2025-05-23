
# 📊 Non-Parallel Trends in Canonical 2x2 Difference-in-Differences (DiD)

This repository includes two R scripts simulating canonical 2x2 Difference-in-Differences (DiD) models under **non-parallel trends** — one **without covariates** and one **with covariates**. These setups demonstrate how violations of the parallel trends assumption affect treatment effect estimates.

---

## 🎯 Objective

The goal is to:
- Simulate treatment and control groups with **different underlying time trends**.
- Quantify how much these trends diverge using a **reusable function**.
- Visualize the outcome trajectories to illustrate non-parallel trends.
- Estimate the treatment effect using **TWFE** via the `fixest` package.

---

## 📁 Files Included

| Script Name                                      | Description                                    |
|--------------------------------------------------|------------------------------------------------|
| `Non-parallel Basic DiD.R`                       | Simulates a 2x2 DiD setup with non-parallel trends, **no covariates** |
| `Non-parallel basic DiD with Covariates.R`       | Same as above, but includes a continuous covariate \( X \) |

---

## 🧪 Model Overview

- **Design**: Canonical 2-period (pre/post), 2-group (treated/control) DiD
- **Sample**: 100 units (50 treated, 50 control)
- **Treatment Effect**: \( \theta = 2 \)
- **Trend Violation**:
  - Control group: \( Y_{it} = 0.5 \times \text{time} \)
  - Treated group: \( Y_{it} = 1.2 \times \text{time} \)

### ➕ In the second model:
- Covariate \( X \sim N(0, 1) \)
- Covariate effect: \( \beta = 1.5 \)

---

## 🔧 Key Feature: `measure_non_parallel()` Function

Each script defines a reusable function:

```r
measure_non_parallel <- function(data) {
  avg <- data %>%
    group_by(group, time) %>%
    summarise(mean_Y = mean(Y)) %>%
    pivot_wider(names_from = time, values_from = mean_Y) %>%
    mutate(change = `1` - `0`)
  abs(diff(avg$change))
}

🎯 What Both Models Share

Both simulate a canonical 2x2 DiD setup (2 groups, 2 time periods).

Both violate the parallel trends assumption by assigning different slopes to treated and control groups.

Both estimate treatment effects using TWFE (feols).

Both include a function to measure non-parallelness of trends.

🔍 What They Do Differently

| Feature                     | `Non-parallel Basic DiD.R`                  | `Non-parallel DiD with Covariates.R`                  |              |             |
| --------------------------- | ------------------------------------------- | ----------------------------------------------------- | ------------ | ----------- |
| Covariate                   | ❌ None                                      | ✅ One covariate (`X ~ N(0, 1)`) included              |              |             |
| True model                  | $Y = \theta D + \text{trend} + \varepsilon$ | $Y = \theta D + \beta X + \text{trend} + \varepsilon$ |              |             |
| Estimated model             | \`Y \~ D                                    | id + time\`                                           | \`Y \~ D + X | id + time\` |
| Bias due to trend violation | ✅ Present                                   | ✅ Present (but **may be smaller**)                    |              |             |
| Controls for confounding    | ❌ None                                      | ✅ Partially controlled via `X`                        |              |             |

📈 Example Output Comparison (Hypothetical)

| Model              | Estimated $\hat{\theta}$ | Non-parallelness Score |
| ------------------ | ------------------------ | ---------------------- |
| Without Covariates | 2.9                      | 2.3                    |
| With Covariates    | 2.5                      | 2.3                    |

The treatment effect is overestimated in both.

Adding covariates pulls the estimate closer to 2, but doesn’t eliminate the bias.

The non-parallelness score remains the same, because it's a property of the data-generating trend, not the covariate.

📈 Visual Output
Produces a side-by-side faceted ggplot2 histogram:

📌 Interpretation
Without covariates: Bias is typically larger due to non-parallel trend violation.

With covariates: Bias is reduced, but not eliminated (covariates help with omitted variable bias, not trend bias).

This plot visually reinforces how modeling assumptions affect DiD estimates.

🧰 Requirements
R ≥ 4.0

Packages:

r
install.packages(c("fixest", "dplyr", "ggplot2", "tidyr"))
