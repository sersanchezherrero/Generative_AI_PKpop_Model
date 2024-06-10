# Load necessary libraries
library(deSolve)
library(pracma)

# Define model parameters
Vc <- 49.86  # Volume of central compartment (liters)
Vp <- 33.14  # Volume of peripheral compartment (liters)
Cl <- 3.51   # Clearance (ml/day)
Vmax <- 0    # Maximum elimination rate (ug/day)
Km <- 5      # Michaelis-Menten constant (ug/ml)
Q <- 50.55   # Flow between compartments (ml/day)
dose <- 10000  # Dose (ug)

# Initial concentrations
Cc_init <- dose / Vc  # Initial concentration in the central compartment (ug/ml)
Cp_init <- 0          # Initial concentration in the peripheral compartment (ug/ml)

# Time frame for the simulation
times <- seq(0, 35, by = 0.1)

# Function defining the differential equations of the model
two_compartment_model <- function(time, state, parameters) {
  Cc <- state[1]  # Concentration in the central compartment
  Cp <- state[2]  # Concentration in the peripheral compartment
  
  with(as.list(parameters), {
    dCc <- -(Cl / Vc) * Cc - (Q / Vc) * (Cc - Cp) - (Vmax / (Km + Cc))
    dCp <- (Q / Vp) * (Cc - Cp)
    
    list(c(dCc, dCp))
  })
}

# Initial state of the system
initial_state <- c(Cc = Cc_init, Cp = Cp_init)

# Parameters to pass to the model function
parameters <- c(Vc = Vc, Vp = Vp, Cl = Cl, Vmax = Vmax, Km = Km, Q = Q)

# Define dosing events every 7 days
event_times <- seq(7, 35, by = 7)
events <- data.frame(var = "Cc", time = event_times, value = dose / Vc, method = "add")

# Solving the differential equations with dosing events
output <- ode(y = initial_state, times = times, func = two_compartment_model, parms = parameters, events = list(data = events))

# Extracting results
results <- as.data.frame(output)

# Plotting the concentrations in the central and peripheral compartments
plot(results$time, results$Cc, type = "l", col = "blue", ylim = c(0, max(results$Cc, results$Cp)),
     xlab = "Time (days)", ylab = "Concentration (ug/ml)", lwd = 2, main = "Two-Compartment Pharmacokinetic Model with Periodic Dosing")
lines(results$time, results$Cp, col = "red", lwd = 2)
legend("topright", legend = c("Central Compartment", "Peripheral Compartment"), 
       col = c("blue", "red"), lwd = 2, cex = 1)

# Filter the data up to day 28
filtered_results <- subset(results, time <= 28)

# Calculate the AUC using the trapezoidal rule
AUC_Cc <- trapz(filtered_results$time, filtered_results$Cc)
AUC_Cp <- trapz(filtered_results$time, filtered_results$Cp)

# Print the AUC values
cat("AUC for Central Compartment (up to day 28):", AUC_Cc, "ug/ml * day\n")
cat("AUC for Peripheral Compartment (up to day 28):", AUC_Cp, "ug/ml * day\n")
