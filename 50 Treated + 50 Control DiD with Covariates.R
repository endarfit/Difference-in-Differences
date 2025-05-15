#the 50 Treated + 50 Control DiD with covariates:
#Y_i_t = theta * D_i_t + X'_i_t * beta + u_i + v_t + eps_i_t

#load necessary package
library(fixest)

#set seed for reproducibility
set.seed(123)

#parameters
N <- 100       # 100 units (50 treated, 50 control)
T <- 2         # Two periods
theta <- 2     # true treatment effect
beta <- 1.5    # coefficient on X
n_sim <- 1000  # number of simulations


#create a panel structure
group <- rep(c(0, 1), each = N / 2)  # 0 = control, 1 = treated
id <- rep(1:N, each = T)
time <- rep(0:1, N)
panel <- data.frame(id = id, time = time)
panel$group <- rep(group, each = T)

#define DiD treatment
panel$D <- ifelse(panel$group == 1 & panel$time ==1, 1, 0)

#Monte Carlo Simulation loop
results <- replicate(n_sim, {
  #generate covariate X_it (can be correlated with treatment)
  X <- rnorm(N * T)
  
  #unit and time fixed effects
  u_i <- rnorm(N)
  v_t <- c(rnorm(1), rnorm(1))
  eps <- rnorm(N * T)
  
  #add fixed effects and construct Y
  u <- rep(u_i, each = T)
  v <- rep(v_t, times = N)
  
  Y <- theta * panel$D + beta * X + u + v + eps
  
  df <- cbind(panel, X = X, Y = Y)
  
  #estimate model with covariates and fixed effects
  model <- feols(Y ~ D + X | id + time, data = df)
  
  coef(model)["D"]
})

#show results
summary(results)
hist(results, breaks = 30,
     main = "Estimated Treatment Effect (with controls)",
     xlab = "Estimated Theta")
abline(v = theta, col= "red", lty =2, lwd = 2)
