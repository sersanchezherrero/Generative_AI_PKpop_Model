library(mapbayr)
library(mrgsolve)

code <- "
$PARAM @annotated
TVCL: 7 : Clearance
TVV1: 40 : Central volume
TVV2  : 30 : Peripheral volume of distribution
TVQ   :  50 : Intercompartmental clearance
Vmax:  0.0 : Maximum elimination rate constant (mg/h)
Km  :  0.005 : Michaelis-Menten constant (mg/L)

ETA1: 0 : Clearance (L/h)
ETA2: 0 : Central volume (L)
ETA3: 0 : Peripheral volume of distribution (L)
ETA4: 0 : Intercompartmental clearance (L/h)


$OMEGA 0.1 0.1 0.1 0.1
$SIGMA 
0.05 // proportional
0.1 // additive

$CMT @annotated
CENT  : Central compartment (mg/L)[ADM, OBS]
PERIPH: Peripheral compartment ()

$TABLE
double DV = (CENT/V1) *(1 + EPS(1)) + EPS(2)+ EPS(3)+EPS(4);

$MAIN
double CL = TVCL * exp(ETA1 + ETA(1)) ;
double V1 = TVV1 * exp(ETA2 + ETA(2)) ;
double V2 = TVV2 * exp(ETA3 + ETA(3)) ; 
double Q = TVQ  * exp(ETA4 + ETA(4)) ;
double K12 = Q / V1  ;
double K21 = Q / V2  ;
double K10 = CL / V1 ;


$ODE
dxdt_CENT   = (K12 * PERIPH - (K10 + K12) * CENT) - (Vmax * CENT) / (Km + CENT);
dxdt_PERIPH =  K21 * CENT - K21 * PERIPH ;


$CAPTURE DV CL V1 V2 Q
"

my_model <- mcode("Example_model_with_nonlinear_elimination", code)

# Lee el archivo de texto plano
my_data <- read.table("Hosseini_et_al_2018.txt", header = TRUE, sep = "\t")
print(my_data)


#my_est <- my_model %>% 
  #adm_rows(time = 0, amt = 10000, rate = 0.25) %>% 
  #obs_rows(time = 0.01047, DV = 191.34) %>% 
  #obs_rows(time = 0.3333333, DV = 150.63) %>% 
  #obs_rows(time = 1, DV = 103.53) %>% 
  #obs_rows(time = 4, DV = 93.39) %>% 
  #obs_rows(time = 7, DV = 60.67) %>% 
  #obs_rows(time = 10, DV = 37.98) %>% 
  #obs_rows(time = 14, DV = 33.48) %>% 
  #obs_rows(time = 21, DV = 26.19) %>% 
  #obs_rows(time = 28, DV = 15.33) %>% 
  #obs_rows(time = 35, DV = 5, mdv = 1) %>% 
  #mapbayest()

my_est <- mapbayest(my_model, data = my_data)

print(my_est)

plot(my_est)

#hist(my_est)  

get_eta(my_est)

get_param(my_est, "CL", "V1", "V2", "Q")
get_phi(my_est)
get_cov(my_est)
h <- hist(my_est)
print(my_est)
# see also plot(my_est) and hist(my_est)
# Use your estimation
get_eta(my_est)
get_param(my_est)
as.data.frame(my_est)
use_posterior(my_est)

my_est %>% 
  use_posterior() %>% 
  data_set(expand.ev(amt = c(50, 100, 200, 500), dur = c(5, 24)) %>% mutate(rate = amt/dur)) %>% 
  carry_out(dur) %>% 
  mrgsim() %>% 
  plot(DV~time|factor(dur), scales = "same")

summary(my_est)

# Easily extract a posteriori parameter values to compute outcomes of interest
get_eta(my_est)
#>      ETA1      ETA2 
#> 0.3872104 0.1569604
get_param(my_est, "CL")
#> [1] 1.79217
#> 
my_model <- house() %>%
mapbayr_vpc(my_model, my_data, nrep = 30) # prediction-corrected by default
mapbayr_vpc(my_model, my_data, idv = "tad", start = 72, nrep = 30)
mapbayr_vpc(my_model, my_data, pcvpc = FALSE, nrep = 30)
mapbayr_vpc(my_model, my_data, stratify_on = "SEX", nrep = 30)
