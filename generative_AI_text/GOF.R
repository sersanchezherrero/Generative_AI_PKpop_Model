# Load necessary library
library(ggplot2)
# Assuming 'datos' is your dataframe loaded
datos <- read.csv("Resutls.csv", header = TRUE)

# Select the columns for density plots
etas <- datos[, c("ETA1", "ETA2", "ETA3", "ETA4")]

# Convert to long format for easier plotting with ggplot2
etas_long <- reshape2::melt(etas)

# Plot density plots for each ETA
ggplot(etas_long, aes(x = value, fill = variable)) +
  geom_density(alpha = 0.6) +
  facet_wrap(~ variable, scales = "free_y") +
  labs(title = "Density Plots of ETA Parameters",
       x = "Value",
       y = "Density") +
  theme_minimal()


# Filter out rows where DV or IPRED is 0
filtered_data <- datos[datos$DV != 0 & datos$IPRED != 0, ]

# Plot DV vs IPRED
p <- ggplot(filtered_data, aes(x = IPRED, y = DV)) +
  geom_point(color = "blue") +  # Dots in blue
  geom_smooth(method = "lm", color = "red", fill = "grey", alpha = 0.3) +  # Trend line in red, shaded grey
  labs(title = "DV vs IPRED",
       x = "IPRED",
       y = "DV") +
  theme_minimal()

print(p)
