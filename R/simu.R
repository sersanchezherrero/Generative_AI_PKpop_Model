# Load necessary libraries
library(deSolve)
library(ggplot2)

# Define the parameter values
Vc <- 49.86  # Volume of the central compartment (liters)
Vp <- 33.14  # Volume of the peripheral compartment (liters)
Cl <- 3.51   # Clearance (ml/day)
Vmax <- 0    # Maximum elimination rate (ug/day)
Km <- 5      # Michaelis-Menten constant (ug/ml)
Q <- 50.55   # Flow between compartments (ml/day)
dose <- 100000  # Dose (ug)

# Initial conditions
Cc_init <- dose / Vc  # Initial concentration in the central compartment (ug/ml)
Cp_init <- 0          # Initial concentration in the peripheral compartment (ug/ml)

# Define the time sequence for the integration
time <- seq(0, 35, by = 0.1)

# Define the differential equations
two_compartment_model <- function(time, state, parameters) {
  Cc <- state[1]  # Concentration in the central compartment
  Cp <- state[2]  # Concentration in the peripheral compartment
  
  with(as.list(parameters), {
    # Differential equations
    dCc <- - (Cl/Vc) * Cc - (Q/Vc) * (Cc - Cp) - (Vmax / (Km + Cc)) * Cc
    dCp <- (Q/Vp) * (Cc - Cp)
    
    return(list(c(dCc, dCp)))
  })
}

# Parameters to pass to the model function
parameters <- c(Vc = Vc, Vp = Vp, Cl = Cl, Vmax = Vmax, Km = Km, Q = Q)

# Initial state
state <- c(Cc = Cc_init, Cp = Cp_init)

# Define the event function to add dose every 7 days
add_dose <- function(time, state, parameters) {
  state["Cc"] <- state["Cc"] + (dose / Vc)
  return(state)
}

# Define the event times (every 7 days)
event_times <- seq(7, 35, by = 7)

# Define the events
events <- data.frame(var = "Cc", time = event_times, value = dose / Vc, method = "add")

# Solving the differential equations with events
output <- ode(y = state, times = time, func = two_compartment_model, parms = parameters, 
              events = list(data = events))

# Convert output to a data frame
output_df <- as.data.frame(output)

# Plotting the results
ggplot(data = output_df, aes(x = time)) +
  geom_line(aes(y = Cc, color = "Central Compartment")) +
  geom_line(aes(y = Cp, color = "Peripheral Compartment")) +
  labs(y = "Concentration (ug/ml)", x = "Time (days)",
       title = "Two-Compartment Pharmacokinetic Model with Periodic Dosing") +
  theme_minimal()+
  theme(axis.title = element_text(size = 20), axis.text = element_text(size = 18))+
  theme(legend.title = element_blank(),
        legend.position = "top",
        legend.text = element_text(size = 10)) +
  scale_color_manual(values = c("Central Compartment" = "blue", "Peripheral Compartment" = "red"))

# Filtramos los datos hasta el tiempo 28
output_df_filtered <- subset(output_df, time <= 28)

# Calculamos el área bajo la curva utilizando la regla del trapecio
area <- sum(with(output_df_filtered, diff(time) * (Cc[-1] + Cc[-nrow(output_df_filtered)]) / 2))

print(paste("El área bajo la curva hasta el tiempo 28 es:", round(area, 2)))

