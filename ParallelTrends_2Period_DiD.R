# Non-Parallel Trends in Canonical 2x2 DiD Base Version

# Load necessary packages
library(fixest)
library(dplyr)
library(ggplot2)
library(tidyr)

# Set seed and parameters
set.seed(123)
N <- 100         # Total units (50 treated, 50 control)
T <- 2           # Two periods: 0 (pre), 1 (post)
theta <- 2       # True treatment effect

# Construct panel structure
group <- rep(c(0, 1), each = N / 2)         # 0 = control, 1 = treated
id <- rep(1:N, each = T)
time <- rep(0:1, times = N)
panel <- data.frame(id = id, time = time)
panel$group <- rep(group, each = T)

# Define DiD treatment indicator (only treated group in post-period)
panel$D <- ifelse(panel$group == 1 & panel$time == 1, 1, 0)

# Introduce non-parallel trends: group-specific time effects
# Control changes by 0.5, Treated by 1.2 (difference causes bias)
panel <- panel %>%
  mutate(trend = ifelse(group == 1, time * 1.2, time * 0.5),
         eps = rnorm(n()),
         Y = theta * D + trend + eps)

# ---- Reusable Function to Measure Non-Parallelness ----
measure_non_parallel <- function(data) {
  avg <- data %>%
    group_by(group, time) %>%
    summarise(mean_Y = mean(Y), .groups = "drop") %>%
    pivot_wider(names_from = time, values_from = mean_Y) %>%
    mutate(change = `1` - `0`)
  
  # Difference in change across groups (slope gap)
  non_parallel_score <- abs(diff(avg$change))
  return(non_parallel_score)
}

# Calculate and print score
nonparallel_score <- measure_non_parallel(panel)
print(paste("Non-parallelness score:", round(nonparallel_score, 3)))

# ---- Visualization ----
avg_outcomes <- panel %>%
  group_by(group, time) %>%
  summarise(mean_Y = mean(Y), .groups = "drop")

ggplot(avg_outcomes, aes(x = time, y = mean_Y, color = factor(group))) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  labs(
    title = paste("Average Outcomes Over Time ??? Non-Parallel Trends\nScore:", round(nonparallel_score, 3)),
    x = "Time", y = "Average Outcome (Y)", color = "Group"
  ) +
  theme_minimal()
