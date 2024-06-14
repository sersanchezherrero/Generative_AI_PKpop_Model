# Load necessary libraries
library(ggplot2)
library(reshape2)
library(broom)  # For tidying the linear model output

# Assuming 'datos' is your dataframe loaded
datos <- read.csv("Resutls.csv", header = TRUE)

# Select the columns for density plots
etas <- datos[, c("ETA1", "ETA2", "ETA3", "ETA4")]

# Convert to long format for easier plotting with ggplot2
etas_long <- melt(etas)

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

# Fit a linear model
fit <- lm(DV ~ IPRED, data = filtered_data)

# Extract statistics
fit_summary <- summary(fit)
adj_r2 <- fit_summary$adj.r.squared
intercept <- fit$coefficients[1]
slope <- fit$coefficients[2]
p_value <- fit_summary$coefficients[2, 4]

# Create the plot
p <- ggplot(filtered_data, aes(x = IPRED, y = DV)) +
  geom_point(color = "blue") +  # Dots in blue
  geom_smooth(method = "lm", color = "red", fill = "grey", alpha = 0.3) +  # Trend line in red, shaded grey
  labs(title = "DV vs IPRED",
       x = "IPRED",
       y = "DV") +
  annotate("text", x = Inf, y = Inf, label = paste("Adj R² =", round(adj_r2, 3), 
                                                   "\nIntercept =", round(intercept, 3), 
                                                   "\nSlope =", round(slope, 3), 
                                                   "\nP-value =", format.pval(p_value, digits = 3)), 
           hjust = 1.1, vjust = 2, size = 4, color = "black", parse = FALSE) +
  theme_minimal()

print(p)
