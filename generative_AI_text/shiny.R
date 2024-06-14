library(shiny)
library(deSolve)
# Define the UI
ui <- fluidPage(
 titlePanel("Two-Compartment Pharmacokinetic Model"),
 sidebarLayout(
 sidebarPanel(
 numericInput("Vc","Volume of the central compartment (l)",value = 48.58),
 numericInput("Vp","Volume of the peripheral compartment (l)",value = 33.47),
 numericInput("Cl","Clearance (ml/day)",value = 7.05),
 numericInput("Vmax","Maximum elimination rate (ug/day)",value = 0),
 numericInput("Km","Michaelis-Menten constant (ug/ml)",value = 5),
 numericInput("Q","Flow between compartments (ml/day)",value = 49.04),
 numericInput("Dose","Dose (ug)", value = 10000),
 numericInput("time","Integration time (days)",value = 35, min = 1),
 actionButton("run","Run Model")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)
# Define the server
server <- function(input, output) {
  observeEvent(input$run, {
    # Parameter definition
    Vc <- input$Vc
    Vp <- input$Vp
    Cl <- input$Cl
    Vmax <- input$Vmax
    Km <- input$Km
    Q <- input$Q
    Dose <- input$Dose
    # Initial concentrations
    Cc0 <- Dose/Vc #Initial concentration in the central compartment (ug/ml)
    Cp0 <- 0  #Initial concentration in the peripheral compartment (ug/ml)
    # Time integration
    times <- seq(0, input$time, by = 0.1)
    # Function defining the differential equations
    two_compartment_model <- function(time, state, parameters) {
      Cc <- state[1]  # Central compartment concentration
      Cp <- state[2]  # Peripheral compartment concentration
      # Differential equations
      dCc <- -(Cl/Vc)*Cc-(Q/Vc)*Cc+(Q/Vc)*Cp-(Vmax/(Km+Cc))*Cc
      dCp <- (Q/Vp)*Cc-(Q/Vp)*Cp
      # Return the rate of change
      list(c(dCc, dCp))
    }
    # Initial state
    initial_state <- c(Cc = Cc0, Cp = Cp0)
    # Solving the differential equations
    output_data <- ode(y = initial_state, times = times, 
    func = two_compartment_model, parms = NULL)
    # Convert output to data frame for plotting
    output_df <- as.data.frame(output_data)
    # Plotting the concentrations
    output$plot <- renderPlot({
      plot(output_df$time, output_df$Cc, type = "l", col = "blue", 
      ylim = c(0, max(output_df$Cc, output_df$Cp)),
           xlab = "Time (days)", ylab = "Concentration (ug/ml)", lwd = 2)
      lines(output_df$time, output_df$Cp, col = "red", lwd = 2)
      legend("topright", 
      legend = c("Central Compartment", "Peripheral Compartment"), 
             col = c("blue", "red"), lty = 1, cex = 1, lwd = 2)
    })
  })
}
# Run the application 
shinyApp(ui = ui, server = server)
