BC-style Parallel-Trends Violation + HonestDiD (RM)

This project simulates a Benzarti & Carloni (2019) style setting with a violation of parallel trends, estimates an event-study DiD, and applies Rambachan & Roth (2023)’s HonestDiD Relative Magnitudes (RM) bounds to obtain robust confidence intervals and sensitivity plots.

The goal is to replicate the style of sensitivity analysis shown in RR (2023), Figure 5.

References

Benzarti, Y., & Carloni, D. (2019). Who Really Benefits from Consumption Tax Cuts? Evidence from a Large VAT Reform in France. AEJ: Economic Policy, 11(1), 38–63.

Rambachan, A., & Roth, J. (2023). A More Credible Approach to Parallel Trends. Review of Economic Studies, 90(5), 2555–2591.

What we do

Data Generating Process (DGP)

Two groups: treated (restaurants) vs control (other services).

Event time 0 is the policy date, reference period is -1.

Violation of parallel trends: treated group has a mild negative pre-trend and a slightly stronger negative post-trend.

Treatment effect: positive and modest after the policy.

Event-study DiD

Regression:

feols(y ~ i(rel_time, treated, ref = -1) | id + time, cluster = ~id)


Extract coefficients and VCOV in the format HonestDiD requires.

HonestDiD RM bounds

Target parameter: average of post-treatment ATTs.

Construct original CI (parallel trends).

Construct robust CIs under RM bounds over Mbar in [0,2].

Outputs

Event-study plot.

RM sensitivity plot (Hybrid vs OLS).

CSVs with CI results.

Session info for reproducibility.

File structure
.
├─ README.md
├─ bc_honestdid_rm.R              # main script
├─ rm_threshold_annotate.R        # optional annotation of M* threshold
└─ plots/
   ├─ event_study.png / .pdf
   ├─ rm_sensitivity.png / .pdf
   ├─ rm_sensitivity_annotated.png / .pdf
   ├─ original_cs.csv
   ├─ rm_results.csv
   ├─ rm_threshold.txt
   └─ sessionInfo.txt

Requirements

R version 4.2 or later

Packages: data.table, fixest, ggplot2, remotes, and HonestDiD from GitHub

The script installs any missing packages automatically.

How to run

Run the main simulation and analysis:

source("bc_honestdid_rm.R")


(Optional) Add the threshold annotation where the robust CI first includes zero:

source("rm_threshold_annotate.R")


This creates extra outputs in the plots/ folder.

Interpreting the RM plot

Blue band = OLS CI under parallel trends (Mbar = 0).

Red bands = HonestDiD RM robust CIs for different Mbar values.

As Mbar grows, the CI widens.

The threshold M* is the point where the lower CI first touches zero.

Interpretation: effects are robust up to M*, meaning they remain positive even if post-treatment bias is as large as M* times the largest pre-treatment bias.

Switching parameters

To estimate a specific post period instead of the average, change:

l_vec <- rep(1 / hd$numPost, hd$numPost)


to

l_vec <- diag(hd$numPost)[1, ]   # first post period


To use smoothness (SD) bounds instead of relative magnitudes, replace the RM function with the SD version provided by HonestDiD.

Reproducibility

set.seed(12345) is used.

If HonestDiD plotting functions are missing, the script falls back to ggplot2.

If you see “Event-study interactions not found”, check that the regression uses the correct specification with i(rel_time, treated, ref = -1).

Citation

If you use this code, please cite:

Rambachan & Roth (2023), A More Credible Approach to Parallel Trends.

Benzarti & Carloni (2019), Who Really Benefits from Consumption Tax Cuts?
