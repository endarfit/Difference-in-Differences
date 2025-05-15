#the 50 Treated + 50 Control DiD Set-Up:
#Y_i_t = theta * Dit + u_i + v_t + eps_i_t

#load required packages
library(fixest)

#set seed for reproducibility
set.seed(123)

#parameters
N <- 100       #total units (50 treated, 50 control)
T <- 2         #two time periods: pre (0), post (1)
theta <- 2     #true treatment effect
n_sim <- 1000  #number of simulations

#create a panel structure
group <- rep(c(0,1), each = N / 2)  # 0 = control, 1 = treated
time <- rep(0:1, each = N)          # 0 = pre, 1 = post
id <- rep(1:N, times = T)
period <- rep(0:1, N)
panel <- data.frame(id = id, time = period)
panel$group <- rep(group, each = T)

#DiD treatment indicator
panel$D <- ifelse(panel$group == 1 & panel$time == 1, 1, 0)

#Monte Carlo Simulation
results <- replicate(n_sim, {
  #generate fixed effects and noise
  u_i <- rnorm(N)               #unit fixed effects
  v_t <- c(rnorm(1), rnorm(1))  #time fixed effects
  eps <- rnorm(N * T)           #error term
  
  #assign fixed effects
  u <- rep(u_i, each = T)
  v <- rep(v_t, times = N)
  
  #generate outcome
  Y <- theta * panel$D + u + v + eps
  df <- cbind(panel, Y = Y)
  
  #estimate TWFE DiD Model
  model <- feols(Y ~ D | id + time, data = df)
  
  #return estimated theta
  coef(model)["D"]
  
})

#show results
summary(results)
hist(results, breaks = 30, main = "Distribution of Estimated Treatment Effect", xlab = "Estimated Theta")
abline(v = theta, col = "red", lty = 2, lwd = 2)