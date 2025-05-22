# Extended 2x2 DiD Simulation with Covariates and Non-Parallel Trends

library(fixest)
library(dplyr)
library(ggplot2)
library(tidyr)

# Set parameters
set.seed(123)
N <- 100       # Total units
T <- 2         # Two periods
theta <- 2     # True treatment effect
beta <- 1.5    # Covariate effect

# Create panel structure
group <- rep(c(0, 1), each = N / 2)
id <- rep(1:N, each = T)
time <- rep(0:1, times = N)
panel <- data.frame(id = id, time = time)
panel$group <- rep(group, each = T)

# Define DiD treatment
panel$D <- ifelse(panel$group == 1 & panel$time == 1, 1, 0)

# Simulate covariate and outcomes with NON-PARALLEL TRENDS
panel$X <- rnorm(N * T)
panel <- panel %>%
  mutate(trend = ifelse(group == 1, time * 1.2, time * 0.5),
         eps = rnorm(n()),
         Y = theta * D + beta * X + trend + eps)

# FUNCTION: Measure non-parallelness (reusable)
measure_non_parallel <- function(data) {
  avg <- data %>%
    group_by(group, time) %>%
    summarise(mean_Y = mean(Y), .groups = "drop") %>%
    pivot_wider(names_from = time, values_from = mean_Y) %>%
    mutate(change = `1` - `0`)
  abs(diff(avg$change))  # difference in slope between groups
}

# Calculate non-parallelness
np_score <- measure_non_parallel(panel)
cat("Non-parallelness score:", round(np_score, 3), "\n")

# Estimate model
model <- feols(Y ~ D + X | id + time, data = panel)
summary(model)

# Visualization of average trends
avg_Y <- panel %>%
  group_by(group, time) %>%
  summarise(mean_Y = mean(Y), .groups = "drop")

ggplot(avg_Y, aes(x = time, y = mean_Y, color = factor(group))) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  labs(
    title = paste("Non-Parallel Trends with Covariates ??? Score:", round(np_score, 3)),
    x = "Time", y = "Average Outcome (Y)", color = "Group"
  ) +
  theme_minimal()
