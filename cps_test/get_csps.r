
# cps data at: https://github.com/open-source-economics/Tax-Calculator/blob/master/taxcalc/cps.csv.gz
# cps info at: http://open-source-economics.github.io/Tax-Calculator/#cli-spec-funits

#****************************************************************************************************
#                Libraries ####
#****************************************************************************************************
library("magrittr")
library("plyr") # needed for ldply; must be loaded BEFORE dplyr
library("tidyverse")
options(tibble.print_max = 60, tibble.print_min = 60) # if more than 60 rows, print 60 - enough for states
# ggplot2 tibble tidyr readr purrr dplyr

library("scales")
library("hms") # hms, for times.
library("stringr") # stringr, for strings.
library("lubridate") # lubridate, for date/times.
library("forcats") # forcats, for factors.
library("readxl") # readxl, for .xls and .xlsx files.
library("haven") # haven, for SPSS, SAS and Stata files.
library("vctrs")
library("precis")

library("grDevices")
library("knitr")

library("zoo") # for rollapply

library("btools") # library that I created (install from github)
library("bdata")

#****************************************************************************************************
#                Globals ####
#****************************************************************************************************
cps_dir <- "D:/Data/cps_puf/cps.csv/"
cps_file <- "cps.csv"

#****************************************************************************************************
#                Get cps data ####
#****************************************************************************************************
cps <- read_csv(paste0(cps_dir, cps_file))

glimpse(cps)
names(cps) %>% sort

saveRDS(cps, paste0(cps_dir, "cps.rds"))


#****************************************************************************************************
#                Explore cps data ####
#****************************************************************************************************
precis(cps)

count(cps, fips)

cps %>%
  group_by(agi_bin) %>%
  summarise(n=n(), weight=sum(s006))



