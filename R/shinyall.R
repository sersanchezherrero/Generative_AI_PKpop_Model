# app.R
library(shiny)
library(deSolve)
library(ggplot2)

# Define UI for application
ui <- fluidPage(
  titlePanel("Pharmacokinetic Model: Central and Peripheral Compartments"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV File", accept = c(".csv")),
      numericInput("dose", "Dose (ug)", value = 10000, min = 0),
      numericInput("vc", "Volume of Central Compartment (liters)", value = 48.58, min = 0),
      numericInput("vp", "Volume of Peripheral Compartment (liters)", value = 33.47, min = 0),
      numericInput("cl", "Clearance (ml/day)", value = 7.05, min = 0),
      numericInput("km", "Michaelis-Menten constant (ug/ml)", value = 5, min = 0),
      numericInput("q", "Flow between Compartments (ml/day)", value = 49.04, min = 0)
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    req(input$file)
    
    # Read uploaded CSV file
    additional_data <- read.csv(input$file$datapath, sep = ";")
    
    # Parameters from user input
    Vc <- input$vc
    Vp <- input$vp
    Cl <- input$cl
    Km <- input$km
    Q <- input$q
    Dose <- input$dose
    Vmax <- 0
    
    # Initial conditions
    C0 <- Dose / Vc
    P0 <- 0
    initial_conditions <- c(Cc = C0, Cp = P0)
    
    # Define the function for the differential equations
    pharma_model <- function(time, state, parameters) {
      with(as.list(c(state, parameters)), {
        # Differential equations
        dCc <- -(Cl/Vc) * Cc - (Q/Vc) * (Cc - Cp) - (Vmax * Cc) / (Km + Cc)
        dCp <- (Q/Vp) * (Cc - Cp)
        
        return(list(c(dCc, dCp)))
      })
    }
    
    # Integration time
    times <- seq(0, 35, by = 0.1)
    
    # Solve the differential equations
    solution <- ode(y = initial_conditions, times = times, func = pharma_model, parms = c(Vc = Vc, Vp = Vp, Cl = Cl, Vmax = Vmax, Km = Km, Q = Q))
    
    # Extract results
    results <- as.data.frame(solution)
    
    # Plot concentrations for central and peripheral compartments with ggplot
    ggplot(results, aes(x = time)) +
      geom_line(aes(y = Cc, color = "Central Compartment"), size = 1) +
      geom_line(aes(y = Cp, color = "Peripheral Compartment"), size = 1) +
      geom_point(data = additional_data, aes(x = TimeSim, y = Central, color = "Simulated Central"), size = 2) +
      geom_point(data = additional_data, aes(x = TimeSim, y = Peri, color = "Simulated Peripheral"), size = 2) +
      geom_point(data = additional_data, aes(x = TimeObs, y = Obs, color = "Observed Data"), size = 2) +
      labs(x = "Time (days)", y = "Concentration (ug/ml)", title = "Central and Peripheral Compartment Concentrations") +
      scale_color_manual(values = c("Central Compartment" = "blue", "Peripheral Compartment" = "red", 
                                    "Simulated Central" = "green", "Simulated Peripheral" = "orange", 
                                    "Observed Data" = "purple"),
                         name = "Legend") +
      theme_minimal()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
