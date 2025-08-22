LW-Style Parallel-Trends Violation + HonestDiD (SR)

This repo simulates a Lovenheim & Willén (2019)–style violation of parallel trends for female employment and then applies Rambachan & Roth (2023)’s Smoothness Restriction (SR) using HonestDiD.
Output = the familiar sensitivity figure with a blue “Original (PT)” CI and red FLCIs that widen as the smoothness bound 
𝑀
M increases (like RR’s Figure 7, right panel).

What’s here

01_sim_sr_LW_female.R — end-to-end script:

simulates a panel with a smooth downward pretrend for treated units (LW-female flavor),

fits a TWFE event-study,

runs HonestDiD SR (FLCIs) over a small 
𝑀
M grid (≈ 0–0.04),

draws the official HonestDiD plot if available, else a look-alike ggplot with capped intervals.

LW_like_PT_violation_SR.png — example plot produced by the script.

Quick start
# 1) Install dependencies (first time)
install.packages(c("fixest","data.table","dplyr","ggplot2","remotes"))

# 2) HonestDiD (latest recommended; CRAN also works)
remotes::install_github("asheshrambachan/HonestDiD")  # or: install.packages("HonestDiD")

# 3) Run the pipeline
source("01_sim_sr_LW_female.R")


If your HonestDiD build exports a plotting helper (plotSensitivityResults() or createSensitivityPlot()), you’ll see their plot.

Otherwise, the script draws a capped-interval ggplot with the same information design.

What the simulation does (one paragraph)

We generate a balanced treated/control panel over multiple pre/post periods. Treated units have a smooth, downward pretreatment drift in their untreated potential outcomes (a quadratic in time), so parallel trends fails in the LW-female direction. Treatment effects are set near zero so any apparent post-treatment effect is spurious under PT. We estimate a TWFE event-study, then feed the pre/post coefficients and their covariance to HonestDiD’s SR engine to compute FLCIs for a target parameter (by default, the average effect over post periods). We use a tight 
𝑀
M grid in [0, 0.04] to mirror the scale shown in RR’s application to LW.

Interpreting the figure

Blue bar (“Original”): 95% CI for the naive event-study estimand under parallel trends.

Red bars (“FLCI”): Robust 95% CIs when PT can be violated by a trend that is smooth—i.e., the second difference of the treated–control gap is bounded by 
𝑀
M each period.

As 
𝑀
M increases (we allow less smoothness / more curvature), the robust intervals widen.

With a downward pretrend (our DGP), the blue CI is negative, but at small 
𝑀
M the robust CI often includes 0—matching the RR × LW female qualitative result.

Common tweaks

Target estimand (τ at a horizon vs. average):

# In 01_sim_sr_LW_female.R
# Default: l_vec <- rep(1/numPost, numPost)  # average across post periods

# To target a specific horizon, e.g., r = 15 post periods:
l_vec <- rep(0, numPost); l_vec[15] <- 1


Reference period (RR use −2 in the LW app):

# In the feols() call, change the omitted pre period:
es_fit <- feols(y ~ i(rel_time, treated, ref = -2) | id + time, cluster = ~ id, data = DT)
# Update the "pre periods" set accordingly when extracting betas.


Smoothness grid 
𝑀
M:

# Fine grid in [0, 0.04] like RR Fig. 7 (right panel)
M_grid <- sort(unique(round(c(0,
                              seq(0.0025, 0.010, by=0.0025),
                              seq(0.0125,0.040, by=0.0025)), 4)))


HonestDiD plotter (use official if present):

The script first tries HonestDiD::plotSensitivityResults() then HonestDiD::createSensitivityPlot().

If neither exists in your install, it draws the same figure via ggplot2 using the table returned by createSensitivityResults().

Notes & limitations

This is a synthetic non-staggered panel that’s designed to reproduce the pretrend logic from LW’s female sample; it does not replicate LW’s microdata or staggered adoption.

RR’s LW application focuses on employment at r = 15 and changes the reference period to −2 (to avoid potential partial treatment at −1). You can replicate that behavior with the tweaks above.

The math (bounds, FLCIs) is entirely from HonestDiD. The fallback plot is only a visualization choice.

References

Rambachan, A., & Roth, J. (2023). A More Credible Approach to Parallel Trends. Review of Economic Studies, 90(5), 2557–2596.

Lovenheim, M., & Willén, A. (2019). The Long-Run Effects of Teacher Collective Bargaining. American Economic Journal: Economic Policy, 11(3), 129–168.

License

Code is released under the MIT License. The referenced papers are © their respective authors/publishers.
