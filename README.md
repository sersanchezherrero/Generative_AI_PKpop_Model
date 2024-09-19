# Assessing the Potential of Generative AI Models as Tools to Assist Experts in the Development of Pharmacokinetic Models in R Studio
·	This repository has been created to showcase the results of the development of a Two-Compartment Antibody Population PK Single-Dose Intra-Venous model with Generative Artificial Intelligence. Different Generative Artificial Intelligence models have been used to validate a Two-Compartment Antibody Population PK Single-Dose Intra-Venous model. Real data comes from Hosseini et al 2018.

# Index

### 1. Step 1: Developing a Two-Compartment Model in R Studio Using Generative Model
### 2. Step 2: Shiny application based on the Two-Compartment Model in R Studio Using Generative Model
### 3. Step 3: Population Analysis based on the Two-Compartment Model in R Studio Using Generative Model
### 4. Step 4: Project PK for an alternate dosing regimen and explore potential PK variability based on the Two-Compartment Model in R Studio Using Generative Model  
### 5. Step 5: Visual Predicted Check based on the Two-Compartment Model in R Studio Using Generative Model 
### 6. Step 6: Parameter Distribution Profiles based on the Two-Compartment Model in R Studio Using Generative Model  
### 7. Step 7: Goodness-of-Fit based on the Two-Compartment Model in R Studio Using Generative Model 

# Content

## 1. Step 1: Developing a Two-Compartment Model in R Studio Using Generative Model
In the first results section, various AI generative models were tasked with generating a two-compartment model based on Hosseini et al. 2018 model. To accomplish this, different generative AI models, including Microsoft Copilot, Gemini, and ChatGPT, were asked to produce the model in R sharing the text belown.

### Text:
  
I want to generate R code for a two-compartment pharmacokinetic model with dose intravenous administration. The two compartment model defines the differential equations governing the behavior of the two-compartment system. This system consists of a central compartment (Cc) and a peripheral compartment (Cp). 
The rate of change of concentration in the central compartment (dCc) is calculated as the sum of three terms:
-	The first term represents the linear elimination of the drug from the central compartment, where the rate of linear elimination proportional to the concentration in the central compartment (Cc), and Cl is the clearance, the amount of plasma cleared of drug per unit time.
-	The second term describes the flow between the central and peripheral compartments, where represents the flow from Cc to Cp, and Q is the flow between compartments. In this second term, we only take into account here Cc, Cp and Vc and not Vp. 
-	The third term models the non-linear elimination of the drug from the central compartment, following Michaelis-Menten kinetics, where represents the rate of non-linear elimination, with Vmax being the maximum elimination rate and Km the Michaelis-Menten constant. 
The rate of change of concentration in the peripheral compartment (dCp) is calculated as the flow from the central compartment to the peripheral compartment minus the flow from the peripheral compartment to the central compartment. This is expressed as, where Q is the flow between compartments and Vp is the volume of the peripheral compartment. Vc is not used in this differential equation. The first differential equation include Vc and not Vp, but second differential equation include Vp and not Vc.
These differential equations describe how the drug concentrations in the central and peripheral compartments change over time, considering both linear and non-linear drug elimination, as well as the flow between compartments.
Then:
-	Parameter definition
o	Volume of the central compartment (liters) = 48.58  
o	Volume of the peripheral compartment (liters) = 33.47  
o	Clearance (ml/day) = 7.05   
o	Maximum elimination rate (ug/day) = 0
o	Michaelis-Menten constant (ug/ml) = 5
o	Flow between compartments (ml/day) = 49.04
o	Dose (ug) = 10000
o	Initial concentration in the central compartment (ug/ml) = dose / Vc  
o	Initial concentration in the peripheral compartment (ug/ml) = 0

-	Function defining the differential equations of the model with library(deSolve). Differential equations should be defined with a more explicit approach.
- Integration time from 0 to 35.
- Initial conditions:  Initial concentration in the central compartment and Initial concentration in the peripheral compartment.
- Solving the differential equations with ode().
- Extracting results
- Plotting concentrations for central and peripheral compartments in the same plot with a legend size of 1. Legend position on the upper-right of the graph.

## 2. Step 2: Shiny application based on the Two-Compartment Model in R Studio Using Generative Model
The same code and asking text were adapted by AI generative models using the Shiny package to create a user interface. 

### Text:

The code you generate, I want it in Shiny, with inputs for the parameter definition and the time.

## 3. Step 3: Population Analysis based on the Two-Compartment Model in R Studio Using Generative Model
The code in "Generative_AI_PKpop_Model/generative_AI_text/mapbayr_example.R" must be shared with generative model.
Next, the text below has to be shared with generative model.
 
### Text:

"Please modify the initial code to:
1.	Update the PK model to include non-linear elimination using a Michaelis-Menten equation. Change the parameters as follows: set TVCL to 7, TVV1 to 40, TVV2 to 30, TVQ to 50, Vmax to 0.0, and Km to 0.005.
2.	Read data from a file called "Hosseini_et_al_2018.txt". Use this data for the parameter estimation instead of the manually defined dataset.
3.	After performing Bayesian parameter estimation, capture and print the individual parameter estimates (CL, V1, V2, Q), their covariances, and the posterior distributions.
4.	Save the estimation results to a CSV file called "Results.csv".
5.	Include visualizations such as observed vs predicted concentration plots and allow for simulating different dosing regimens based on posterior parameter distributions."
6.	Eliminated BW. I do not need it.

## 4. Step 4: Project PK for an alternate dosing regimen and explore potential PK variability based on the Two-Compartment Model in R Studio Using Generative Model 
The same code and asking text were adapted by AI generative models using the Shiny package to create a user interface. 

### Text:

Based on the previous model, I want a simulation with: 
Initial values:
•	Vc <- 49.86 # Volume of the central compartment (liters)
•	Vp <- 33.14 # Volume of the peripheral compartment (liters)
•	Cl <- 3.51 # Clearance (ml/day)
•	Vmax <- 0 # Maximum elimination rate (ug/day)
•	Km <- 5 # Michaelis-Menten constant (ug/ml)
•	Q <- 50.55 # Flow between compartments (ml/day)
•	dose <- 10000 # Dose (ug) 
Initial conditions: 
•	Cc_init <- dose / Vc # Initial concentration in the central compartment (ug/ml)
•	Cp_init <- 0 # Initial concentration in the peripheral compartment (ug/ml) 
And define a periodic dosing event every 7 days, where from the second dose, add the dose to the existing concentrations at that time. I suggest using event_times to indicate the times at which the dose is administered, and events containing information about the dosing events. 
Then, I want to plot the concentrations obtained in the central and peripheral compartments in the same plot. 
Finally, I want to filter the data up to day 28 and calculate the area under the curve (AUC) using the trapezoidal rule, which is a measure of the total body exposure to the drug up to that time.

## 5. Step 5: Visual Predicted Check based on the Two-Compartment Model in R Studio Using Generative Model 
After sharing the text in step 1 and obtaining the answer from generative model, we have to share the code below  

### Text:

Based on the previous model, I want a simulation with: 
1. How can I perform a Monte Carlo simulation with variability in the parameters?
•	Reason for asking: The new code introduces a Monte Carlo simulation for 1000 patients, generating random values for pharmacokinetic parameters (Cl, Q, Vc, Vp) to reflect interindividual variability. This is key for simulating different patient responses.
2. How can I generate random parameter values with specific means and standard deviations?
•	Reason for asking: The new code uses normal distributions (rnorm) to generate random samples for Cl, Q, Vc, and Vp. Asking this will help you learn how to incorporate variability into the model parameters.
3. How can I integrate and visualize experimental data alongside my simulation?
•	Reason for asking: The new code loads additional experimental data from a CSV file and overlays it on the simulation plot. This allows you to compare the simulated data with real-world observations.
4. How can I plot multiple simulations on a single graph with transparency?
•	Reason for asking: In the new code, concentration curves for 1000 patients are plotted with semi-transparent lines (rgb(0, 0, 1, 0.1)), which makes it easier to visualize variability without overwhelming the plot.

## 6. Step 6: Parameter Distribution Profiles based on the Two-Compartment Model in R Studio Using Generative Model 
The same code and asking text were adapted by AI generative models using the Shiny package to create a user interface. 

### Text:

1. How can I calculate percentiles (5th, 50th, 95th) from my simulation results?
•	Reason for asking: The code calculates the 5th, 50th, and 95th percentiles of concentration values across all simulations at each time point, summarizing the distribution of results.
2. How can I calculate the area under the curve (AUC) from the concentration vs. time data?
•	Reason for asking: The new code calculates the AUC for the percentiles using the trapezoidal rule. AUC is a crucial pharmacokinetic metric to assess drug exposure.
3. How can I create histograms or density plots for the parameter distributions?
•	Reason for asking: The new code generates histograms and density plots (with ggplot2) to visualize the distribution of the pharmacokinetic parameters. This helps in understanding the variability in the simulated population.
4. How can I add text annotations to a plot to display calculated values like AUC?
•	Reason for asking: The new code adds AUC values directly to the plot using text(), which allows you to present important metrics within the plot itself.
5. How can I adjust the tolerance settings in the ode function for more precise solutions?
•	Reason for asking: The code increases the accuracy of the ode function by setting rtol = 1e-6 and atol = 1e-6, which helps in obtaining more precise solutions for the differential equations.

## 7. Step 7: Goodness-of-Fit based on the Two-Compartment Model in R Studio Using Generative Model 
Based on Resutls.csv obtained from step 3, following the text below could be obtainded Goodness-of-Fit plot. 

### Text:

Based on the fact that I have a dataframe named datos created as follows: datos <- read.csv("Results.csv", header = TRUE).

This dataframe is composed of the following columns:
"ID", "time", "evid", "cmt", "amt", "rate", "mdv", "DV", "IPRED", "PRED", "CL", "V1", "V2", "Q", "ETA1", "ETA2", "ETA3", "ETA4". Each ETA plot filled the shape with different colour and in four different graphs. 

I would like to generate individual density plots for ETA1, ETA2, ETA3, and ETA4.
Additionally, I want to create a plot with DV (y-axis) versus IPRED (x-axis), including a trend line shaded in gray to indicate the trend. I want this plot to exclude rows with a value of 0. Dots in blue. Line in red and shade in grey.
could you add in tendency line the adj R2 value, Intercept value, slope value and P value

