#The Canonical DiD Set-up with Covariates

# Load necessary package
library(fixest)

# Set seed
set.seed(123)

# Parameters
N <- 2         # 2 units
T <- 2         # 2 time periods
theta <- 2   # True treatment effect
n_sim <- 1000  # Number of simulations

# Create panel data
group <- c(0, 1)        # 0 = control, 1 = treated
id <- rep(1:2, each = T)
time <- rep(0:1, times = N)
panel <- data.frame(id = id, time = time)
panel$group <- rep(group, each = T)

# Define treatment variable
panel$D <- ifelse(panel$group == 1 & panel$time == 1, 1, 0)

# Monte Carlo Simulation with covariates
results_cov <- replicate(n_sim, {
  X <- rnorm(N * T)              # Covariate
  
  u_i <- rnorm(N)
  v_t <- rnorm(T)
  eps <- rnorm(N * T)
  
  u <- rep(u_i, each = T)
  v <- rep(v_t, times = N)
  
  Y <- theta * panel$D + 0.5 * X + u + v + eps  # ?? = 0.5
  
  df <- cbind(panel, X = X, Y = Y)
  
  model <- feols(Y ~ D + X | id + time, data = df)
  coef(model)["D"]
})

# Results
hist(results_cov, breaks = 30, main = "2x2 DiD with Covariates", xlab = "Estimated ??")
abline(v = theta, col = "red", lty = 2, lwd = 2)
summary(results_cov)
