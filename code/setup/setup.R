#===============================================================================
# Install and load required packages. Define different data directories
#===============================================================================

# define data directories ------------------------------------------------------# define code directory 

ddir <- file.path(root, "data", "use_data")
rdir <- file.path(root, "data", "raw_data")

# install and load packages-----------------------------------------------------

# source function to install packages
source(file.path(cdir, "setup", "functions", "check_install.R")) 

# define required packages
packages <- c('readr', 
              'magrittr',
              'dplyr',
              'tidyr',
              'tictoc',
              'purrr',
              'arrow',
              'haven',
              'tidycensus',
              'readxl')

# Install R packages
sapply(packages, check_install)

# Load required libraries
sapply(c(packages), library, character.only = T)

# cleanup
rm(packages) 

# Preferences ------------------------------------------------------------------

# turn off scientific notation
options(scipen = 999)

