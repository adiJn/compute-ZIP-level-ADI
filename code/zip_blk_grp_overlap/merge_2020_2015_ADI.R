# define code directory --------------------------------------------------------

# get the path to this file (master.R)
root <- rstudioapi::getSourceEditorContext()$path

# until the last path separator is the name of the root directory, shorten the 
# file path to get the root
while (basename(root) != "OneDrive-NorthwesternUniversity") {
  root <- dirname(root)
}

# define code directory 
cdir <- file.path(root, "code")

# packages, preferences, directories -------------------------------------------

# source the setup script
source(file.path(cdir, "setup", "setup.R")) 
rdir <- file.path(rdir, "national_ADI")

# constants --------------------------------------------------------------------

# vector of probabilities to define
PROB <- c(0.2,0.4,0.6,0.8)

# analysis ---------------------------------------------------------------------

# source functions
source(file.path(cdir, "zip_blk_grp_overlap/functions/gen_quintiles.R"))
source(file.path(cdir, "zip_blk_grp_overlap/functions/gen_categories_export_data.R"))

tic('total time to run')

# read ADI data from 2020 and merge with 2015 data -----------------------------

data <- read_csv(file.path(ddir, "national_adi/crosswalk/ADI_zip_crosswalk.csv")) %>%
  inner_join(read_csv(file.path(ddir, "national_adi/2015/crosswalk/ADI_zip_crosswalk.csv")),
             by = "zip",
             suffix = c(".2020", ".2015")) %>%
  # remove ADI quinitles and ADI categories
  select(-c(contains("ADI_")))
# 1,101 zip codes lost

# create quintiles and categories after averaging 2015, 2020 ADIs
data %>%
  mutate(average_zip_ADI = (zip_ADI.2020 + zip_ADI.2015)/2) %>%
  select(-c(zip_ADI.2020, zip_ADI.2015)) %>%
  rename(zip_ADI = average_zip_ADI) %>%
  # generate quintiles
  gen_quintiles() %>%
  # categorize weighted ADIs into 5 categories (normal dist. quintiles); export
  # crosswalk
  gen_categories_export_data(paste0(ddir, "/national_adi/2015_2020/crosswalk"))
toc()
