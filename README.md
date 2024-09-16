# Assessing the Potential of Generative AI Models as Tools to Assist Experts in the Development of Pharmacokinetic Models in R Studio
·	This repository has been created to showcase the results of the development of a Two-Compartment Antibody Population PK Single-Dose Intra-Venous model with Generative Artificial Intelligence. Different Generative Artificial Intelligence models have been used to validate a Two-Compartment Antibody Population PK Single-Dose Intra-Venous model. Real data comes from Hosseini et al 2018.

# Index

### 1. Step 1: Developing a Two-Compartment Model in R Studio Using Generative Model
### 2. Step 2: 
### 3. Step 3: 
### 4. Step 4: 
### 5. Step 5: 
### 6. Step 6: 

# Content

## 1. Step 1:
In the first results section, various AI generative models were tasked with generating a two-compartment model based on Hosseini et al. 2018 model. The generated models were compared with simulations from this publication and real data. To accomplish this, different generative AI models, including Microsoft Copilot, Gemini, and ChatGPT, were asked to produce the model in R.

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

## 2. Step 2:
The same code and asking text were adapted by AI generative models using the Shiny package to create a user interface. 

### Text:

The code you generate, I want it in Shiny, with inputs for the parameter definition and the time.

## 3. Step 3:
The same code and asking text were adapted by AI generative models using the Shiny package to create a user interface. 

### Text:
