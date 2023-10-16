### download a wikipedia nightly: https://dumps.wikimedia.org/other/cirrussearch/

### R can unzip the gz file without any additional code,
### but I find it's faster to unpack before running in R
### file can be .gz or .json

### this assumes there is only 1 language prefixed file per language in the nightly folder

lang <- "cy" ## the prefix, language short code

source("R/loading-step-1.R")
source("R/loading-step-2.R")
source("R/loading-step-3.R")
source("R/loading-step-4.R")
