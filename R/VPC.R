# Load required package
library(deSolve)

# Define fixed parameters
Vmax <- 0             # Maximum elimination rate (ug/day)
Km <- 5               # Michaelis-Menten constant (ug/ml)
Dose <- 100000        # Dose (ug)

# Initial concentrations
Cc0 <- Dose / 48.58   # Initial concentration in the central compartment (ug/ml) based on average Vc
Cp0 <- 0              # Initial concentration in the peripheral compartment (ug/ml)

# Define the differential equations
two_compartment_model <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dCc <- -(Cl / Vc) * Cc - (Q / Vc) * (Cc - Cp) - (Vmax / (Km + Cc)) * Cc
    dCp <- (Q / Vp) * (Cc - Cp)
    
    list(c(dCc, dCp))
  })
}

# Monte Carlo simulation for 1000 patients
n_patients <- 1000

# Define standard deviations
sd_Cl <- 0.2
sd_Q <- 9.28
sd_Vc <- 3.8
sd_Vp <- 5.2

# Generate random samples for the parameters
set.seed(123)  # For reproducibility
Cl_samples <- rnorm(n_patients, mean = 7.05, sd = sd_Cl)
Q_samples <- rnorm(n_patients, mean = 49.04, sd = sd_Q)
Vc_samples <- rnorm(n_patients, mean = 48.58, sd = sd_Vc)
Vp_samples <- rnorm(n_patients, mean = 33.47, sd = sd_Vp)

# Define the integration time
times <- seq(0, 35, by = 0.1)

# Create a matrix to store the results
results_Cc <- matrix(0, nrow = length(times), ncol = n_patients)
results_Cp <- matrix(0, nrow = length(times), ncol = n_patients)


# Run the simulations
for (i in 1:n_patients) {
  parameters <- c(Vc = Vc_samples[i], Vp = Vp_samples[i], Cl = Cl_samples[i], Vmax = Vmax, Km = Km, Q = Q_samples[i])
  state <- c(Cc = Dose / Vc_samples[i], Cp = Cp0)
  
  out <- ode(y = state, times = times, func = two_compartment_model, parms = parameters,rtol = 1e-6, atol = 1e-6)
  out_df <- as.data.frame(out)
  
  results_Cc[, i] <- out_df$Cc
  results_Cp[, i] <- out_df$Cp
}


# Load additional data from CSV
additional_data <- read.csv("Libro1.csv", sep = ";")
# Eliminar filas con NA en el marco de datos additional_data
# Eliminar la primera, segunda y tercera columna del marco de datos additional_data
additional_data <- additional_data[, -c(1, 2, 3)]
additional_data <- na.omit(additional_data)


# Plot the results
plot(times, results_Cc[, 1], type = "l", col = rgb(0, 0, 1, 0.1), ylim = c(0, max(results_Cc)),
     xlab = "Time (days)", ylab = "Concentration (ug/ml)", main = "100 mg Monte Carlo Simulation of Two-Compartment Model")
for (i in 2:n_patients) {
  lines(times, results_Cc[, i], col = rgb(0, 0, 1, 0.1), lwd = 0.1)  # Reducir el ancho de las líneas
}

# Superponer los puntos de los datos adicionales
points(additional_data$TimeObs2, additional_data$Obs2, col = "green", pch = 19)


# Añadir leyenda
legend("topright", legend = c("Central Compartment (Cc)", "Peripheral Compartment (Cp)", "Additional Data"), 
       col = c("blue", "red", "green"), lty = c(1, 1, NA), pch = c(NA, NA, 19), cex = 1)

# Generate histograms for parameters with variability
par(mfrow = c(2, 2))  # Divide the plotting area into a 2x2 grid

hist(Cl_samples, main = "Distribution of Cl", xlab = "Cl", col = "skyblue", border = "black")
hist(Q_samples, main = "Distribution of Q", xlab = "Q", col = "lightgreen", border = "black")
hist(Vc_samples, main = "Distribution of Vc", xlab = "Vc", col = "salmon", border = "black")
hist(Vp_samples, main = "Distribution of Vp", xlab = "Vp", col = "lightpink", border = "black")

# Reset the plotting parameters
par(mfrow = c(1, 1))

library(ggplot2)

# Create a data frame for parameter distributions
param_df <- data.frame(Parameter = rep(c("Cl", "Q", "Vc", "Vp"), each = n_patients),
                       Value = c(Cl_samples, Q_samples, Vc_samples, Vp_samples))

# Plot parameter distributions using ggplot2
ggplot(param_df, aes(x = Value, fill = Parameter)) +
  geom_density(alpha = 0.5) +
  facet_wrap(~ Parameter, scales = "free") +
  labs(title = "Density Plot of Parameter Distributions",
       x = "Value", y = "Density") +
  theme_minimal()


# Calcular percentiles 5, 50 y 95 para cada tiempo
Cc_percentiles <- apply(results_Cc, 1, quantile, probs = c(0.05, 0.5, 0.95))

# Integrar la curva de concentración vs. tiempo usando la regla del trapecio para obtener el AUC
calc_auc <- function(concentration, time) {
  auc <- sum(diff(time) * (head(concentration, -1) + tail(concentration, -1)) / 2)
  return(auc)
}

auc_5 <- calc_auc(Cc_percentiles[1, ], times)
auc_50 <- calc_auc(Cc_percentiles[2, ], times)
auc_95 <- calc_auc(Cc_percentiles[3, ], times)

# Imprimir los valores del AUC
print(paste("AUC para el percentil 5:", auc_5))
print(paste("AUC para el percentil 50:", auc_50))
print(paste("AUC para el percentil 95:", auc_95))

# Graficar los percentiles con AUC en la gráfica
plot(times, Cc_percentiles[2, ], type = "l", col = "blue", ylim = c(0, max(Cc_percentiles)),
     xlab = "Time (days)", ylab = "Concentration (ug/ml)", main = "Percentiles 5, 50, 95 Monte Carlo Simulation")
lines(times, Cc_percentiles[1, ], col = "red")
lines(times, Cc_percentiles[3, ], col = "green")

legend("topright", legend = c("Percentil 5", "Percentil 50", "Percentil 95"), 
       col = c("red", "blue", "green"), lty = 1, cex = 1)

# Añadir los valores del AUC en la gráfica
text(max(times) * 0.8, max(Cc_percentiles) * 0.9, paste("AUC 5%:", round(auc_5, 2)), col = "red")
text(max(times) * 0.8, max(Cc_percentiles) * 0.8, paste("AUC 50%:", round(auc_50, 2)), col = "blue")
text(max(times) * 0.8, max(Cc_percentiles) * 0.7, paste("AUC 95%:", round(auc_95, 2)), col = "green")
