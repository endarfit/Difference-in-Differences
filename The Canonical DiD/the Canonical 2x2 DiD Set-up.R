#the Canonical 2x2 DiD Set-up

# Load necessary package
library(fixest)

# Set seed
set.seed(123)

# Parameters
N <- 2         # 2 units (1 treated, 1 control)
T <- 2         # 2 periods
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

# Monte Carlo Simulation
results_basic <- replicate(n_sim, {
  u_i <- rnorm(N)                # Unit fixed effects
  v_t <- rnorm(T)                # Time fixed effects
  eps <- rnorm(N * T)            # Idiosyncratic errors
  
  u <- rep(u_i, each = T)
  v <- rep(v_t, times = N)
  
  Y <- theta * panel$D + u + v + eps
  
  df <- cbind(panel, Y = Y)
  
  model <- feols(Y ~ D | id + time, data = df)
  coef(model)["D"]
})

# Results
hist(results_basic, breaks = 30, main = "the Canonical Model", xlab = "Estimated ??")
abline(v = theta, col = "red", lty = 2, lwd = 2)
summary(results_basic)
