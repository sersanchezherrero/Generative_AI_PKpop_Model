# Load the necessary library
library(deSolve)

# Define the pharmacokinetic model
pharma_model <- function(t, state, parameters) {
  # Unpack the state variables (concentrations in central and peripheral compartments)
  Cc <- state[1]  # Concentration in the central compartment (ug/ml)
  Cp <- state[2]  # Concentration in the peripheral compartment (ug/ml)
  
  # Unpack the parameters
  Vc <- parameters["Vc"]  # Volume of the central compartment (L)
  Vp <- parameters["Vp"]  # Volume of the peripheral compartment (L)
  Cl <- parameters["Cl"]  # Clearance (ml/day)
  Vmax <- parameters["Vmax"]  # Maximum elimination rate (ug/day)
  Km <- parameters["Km"]  # Michaelis-Menten constant (ug/ml)
  Q <- parameters["Q"]  # Flow between compartments (ml/day)
  dose <- parameters["dose"]  # Initial dose (ug)
  
  # Define the differential equations
  dCc <- (-Cl/Vc) * Cc - (Vmax * Cc) / (Km + Cc) + Q * (Cp - Cc) / Vc  # Central compartment
  dCp <- (Q/Vp) * (Cc - Cp)  # Peripheral compartment
  
  # Return the rate of change
  list(c(dCc, dCp))
}

# Parameter values
parameters <- c(
  Vc = 48.58,    # Volume of central compartment (L)
  Vp = 33.47,    # Volume of peripheral compartment (L)
  Cl = 7.05,     # Clearance (ml/day)
  Vmax = 0,      # Maximum elimination rate (ug/day)
  Km = 5,        # Michaelis-Menten constant (ug/ml)
  Q = 49.04,     # Flow between compartments (ml/day)
  dose = 10000   # Initial dose (ug)
)

# Initial conditions (concentrations in central and peripheral compartments)
initial_conditions <- c(Cc = parameters["dose"] / parameters["Vc"], Cp = 0)

# Time points for integration (from 0 to 35 days)
time <- seq(0, 35, by = 0.1)

# Solve the differential equations using ode()
solution <- ode(y = initial_conditions, times = time, func = pharma_model, parms = parameters)

# Convert the solution to a data frame for easier manipulation
solution_df <- as.data.frame(solution)

# Plot the results
plot(solution_df$time, solution_df$Cc, type = "l", col = "blue", 
     xlab = "Time (days)", ylab = "Concentration (ug/ml)", 
     main = "Concentration vs Time in Central and Peripheral Compartments")
lines(solution_df$time, solution_df$Cp, col = "red")
legend("topright", legend = c("Central Compartment", "Peripheral Compartment"), 
       col = c("blue", "red"), lty = 1, cex = 1)

