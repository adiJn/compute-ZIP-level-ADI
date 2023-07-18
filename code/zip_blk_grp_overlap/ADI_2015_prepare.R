# define code directory --------------------------------------------------------

# get the path to this file (master.R)
root <- rstudioapi::getSourceEditorContext()$path

# until the last path separator is the name of the root directory, shorten the 
# file path to get the root
while (basename(root) != "OneDrive - Northwestern University") {
  root <- dirname(root)
}

# define code directory 
cdir <- file.path(root, "code")

# packages, preferences, directories -------------------------------------------

# source the setup script
source(file.path(cdir, "setup", "setup.R")) 
rdir <- file.path(rdir, "national_ADI/2015")

# constants --------------------------------------------------------------------

# census API key
KEY <- ""

# suppression criteria codes for census block group 
SUPPRESSION_CODES <- c('PH', 'GQ', 'GQ-PH', 'QDI', "NONE")

# vector of probabilities to define quintiles
PROB <- c(0.2,0.4,0.6,0.8)

# analysis ---------------------------------------------------------------------

# source functions
source(file.path(cdir, "zip_blk_grp_overlap/functions/2015/read.R"))
source(file.path(cdir, "zip_blk_grp_overlap/functions/2015/clean_raw_ADI.R"))
source(file.path(cdir, "zip_blk_grp_overlap/functions/2015/blk_grp_pop_merge.R"))
source(file.path(cdir, "zip_blk_grp_overlap/functions/zip_level_pop_weighted_ADI.R"))
source(file.path(cdir, "zip_blk_grp_overlap/functions/gen_quintiles.R"))
source(file.path(cdir, "zip_blk_grp_overlap/functions/gen_categories_export_data.R"))

tic('total time to run')
# read ADI data
read() %>%
  # clean ADI data
  clean_raw_ADI() %>%
  # pull population data from 5-year ACS 2020, and merge on FIPS
  blk_grp_pop_merge() %>%
  # computed a zip-level block group level population weighted ADI
  zip_level_pop_weighted_ADI() %>%
  # estimate the quintiles of the distribution of weighted ADIs
  gen_quintiles() %>%
  # categorize weighted ADIs into 5 categories (normal dist. quintiles); export
  # crosswalk
  gen_categories_export_data(paste0(ddir, "/national_adi/2015/crosswalk"))
toc()
