# Difference-in-Differences under Non-Parallel Trends  
_A Master’s Thesis Project_  
by endarfit (Kağan Eskicioğlu)  
M.Sc. Economics, University of Bonn

## 📖 Project Overview  
This repository hosts all simulation code, empirical designs, and analysis developed as part of my master’s thesis. The thesis investigates estimation of treatment effects in panel data via the Difference-in-Differences (DiD) approach when the standard **parallel-trends assumption** fails — or can only be weakened. Specifically, the project explores recently developed bounding methods (smoothness bounds; relative‐magnitude bounds) drawing from the frameworks of Rambachan & Roth (2023) and Molinari (2020).  
The work uses the R programming language and focuses on reproducibility and clear documentation so that researchers and applied analysts can adapt the tools to their settings.

## 🎯 Aims & Contribution  
- To simulate canonical and more complex DiD setups (2×2, multi-period, group-specific‐trends violations) and illustrate how estimator bias unfolds under non-parallel trends.  
- To implement bounding approaches in the R package HonestDiD:  
  - Relative-magnitude bounds (RM)  
  - Smoothness restrictions (SM)  
- To provide a fully reproducible workflow (code + data + graphics) that bridges econometric theory and applied practice for policy evaluation with quasi-experiments.  
- To equip practitioners with a “tool-kit” for assessing identification risk when using DiD under weaker assumptions.

## 🧮 Repository Structure  
/Canonical, but more than 2 periods to use HonestDiD/
/Non-parallel Basic DiD/
/Ashenfelter’s Dip (1978)/
/Ashenfelter’s Dip + RM Bounds/
/Group-Specific Trends ATT Estimates/
/Monte Carlo Simulation: Non-Robust ATT Estimation under Smooth Group-Specific Pre-Trends (Relative Magnitude Bounds)/
/Smoothness Restriction on Group-Specific Trends ATT Estimates/

Each folder corresponds to a specific simulation design or empirical case study and contains:  
- R scripts (.R) for data generation, estimation, bounding, and graphics  
- A README or script header explaining assumptions, parameter settings, and how to reproduce results  
- Output files: tables, figures (PDFs/PNG) summarising key findings  

## 🔧 Technical Environment & Requirements  
- R (version ≧ 4.0)  
- Key R packages: `HonestDiD`, `fixest`, `CVXR`, `tidyverse`, `ggplot2`, `data.table`   
- GitHub (for version control) and the repository is structured for reproducibility  

## 🚀 How to Use / Reproduce  
1. Clone this repository:  
   ```bash  
   git clone https://github.com/endarfit/Difference-in-Differences.git  
Navigate to the folder/design of interest.

Open the main R script (e.g., simulate_RM_bounds.R) and follow the instructions in the header (set working directory, install/load packages).

Run the script: it will generate simulation data, estimate ATT under varying conditions, apply bounding approach(s), and output tables/figures.

Review the output files (tables/graphics) for interpretations of bias, bound width, and robustness trade-offs.

📌 Key Findings 
In canonical DiD designs, estimator bias under parallel trends is minimal; however, once pre-trends or group-specific trends violate the assumption, bias grows quickly.

Applying RM bounds via HonestDiD helps quantify the identification risk and provides a narrower credible region for ATT.

Smoothness restrictions can yield tighter bounds when pre-trend violations evolve gradually, but require stronger assumptions.

The choice of bound type (RM vs SM) depends on the nature of violation, researcher’s prior belief, and policy context.

🤝 Citation & License
If you use or adapt this code in your work, please cite the repository and mention the original thesis.
License: MIT License (see LICENSE file).

✉️ Contact
For questions, suggestions, or collaborations, feel free to contact me:

Email: kaganeskicioglu@gmail.com

GitHub profile: https://github.com/endarfit

Thank you for visiting the repository — I hope this code base supports your work in robust causal inference and policy evaluation!

---
