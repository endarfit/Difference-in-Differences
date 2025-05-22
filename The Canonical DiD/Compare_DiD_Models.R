#Compare all basic DiD Models graphically

# Load required package
library(fixest)

# Settings
set.seed(123)
theta <- 2
n_sim <- 1000

### 1. Canonical DiD (2 units, no covariates)
N <- 2; T <- 2
group <- c(0, 1)
id <- rep(1:2, each = T)
time <- rep(0:1, times = N)
panel <- data.frame(id = id, time = time)
panel$group <- rep(group, each = T)
panel$D <- ifelse(panel$group == 1 & panel$time == 1, 1, 0)

results1 <- replicate(n_sim, {
  u <- rep(rnorm(N), each = T)
  v <- rep(rnorm(T), times = N)
  eps <- rnorm(N * T)
  Y <- theta * panel$D + u + v + eps
  df <- cbind(panel, Y = Y)
  coef(feols(Y ~ D | id + time, data = df))["D"]
})

### 2. Canonical DiD with Covariates (2 units)
results2 <- replicate(n_sim, {
  X <- rnorm(N * T)
  u <- rep(rnorm(N), each = T)
  v <- rep(rnorm(T), times = N)
  eps <- rnorm(N * T)
  Y <- theta * panel$D + 0.5 * X + u + v + eps
  df <- cbind(panel, X = X, Y = Y)
  coef(feols(Y ~ D + X | id + time, data = df))["D"]
})

### 3. 50 Treated + 50 Control (100 units, no covariates)
N <- 100; T <- 2
group <- rep(c(0, 1), each = N / 2)
id <- rep(1:N, each = T)
time <- rep(0:1, times = N)
panel <- data.frame(id = id, time = time)
panel$group <- rep(group, each = T)
panel$D <- ifelse(panel$group == 1 & panel$time == 1, 1, 0)

results3 <- replicate(n_sim, {
  u <- rep(rnorm(N), each = T)
  v <- rep(rnorm(T), times = N)
  eps <- rnorm(N * T)
  Y <- theta * panel$D + u + v + eps
  df <- cbind(panel, Y = Y)
  coef(feols(Y ~ D | id + time, data = df))["D"]
})

### 4. 50 Treated + 50 Control with Covariates (100 units)
results4 <- replicate(n_sim, {
  X <- rnorm(N * T)
  u <- rep(rnorm(N), each = T)
  v <- rep(rnorm(T), times = N)
  eps <- rnorm(N * T)
  Y <- theta * panel$D + 1.5 * X + u + v + eps
  df <- cbind(panel, X = X, Y = Y)
  coef(feols(Y ~ D + X | id + time, data = df))["D"]
})

# Plot all histograms
par(mfrow = c(2, 2))  # 2x2 layout

hist(results1, breaks = 30, main = "1. Canonical DiD (2 units)", xlab = "Estimated ??")
abline(v = theta, col = "red", lty = 2, lwd = 2)

hist(results2, breaks = 30, main = "2. Canonical w/ Covariates (2 units)", xlab = "Estimated ??")
abline(v = theta, col = "red", lty = 2, lwd = 2)

hist(results3, breaks = 30, main = "3. 50T/50C DiD (100 units)", xlab = "Estimated ??")
abline(v = theta, col = "red", lty = 2, lwd = 2)

hist(results4, breaks = 30, main = "4. 50T/50C w/ Covariates (100 units)", xlab = "Estimated ??")
abline(v = theta, col = "red", lty = 2, lwd = 2)
