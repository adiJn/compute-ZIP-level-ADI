# create 5-digit zip codes

blk_grp_pop_merge <- function(data){
  
  # data cleaning: ~30 sec
  tic('ADI data cleaning')
  # add 5-digit zip to data
  data <- data %>% 
    select(ZIP_4, FIPS, ADI_NATRANK) %>%
    mutate(zip = substr(ZIP_4, 1, 5)) %>%
    select(-ZIP_4)
  # there are 40,569 zipcodes in the data
  
  # remove block groups that fall into one of the suppression criteria:
  # - PH: less than 100 people, 
  # - PH: less than 30 housing units or
  # - GQ: more than 33% of the population living in group quarters and 
  # - KVM: Census data labeled as N/A or missing in the core component variables
  # - QDI: Missing a description
  
  # before filtering: 68864917 obs.
  data <- data %>% 
    filter(!ADI_NATRANK %in% SUPPRESSION_CODES) 
  # after filtering: 66938350 observations
  # after filtering: 39839 zipcodes 
  toc()
  
  # get the state FIPS codes from the ADI dataset
  state_FIPS <- data %>% 
    mutate(state_code = substr(FIPS,1,2)) %>%
    select(state_code) %>%
    na.omit() %>%
    unique()
  
  # remove invalid state FIPS codes
  state_FIPS <- state_FIPS %>%
    filter(!state_code %in% INVALID_STATE_FIPS)
  
  # get population data --------------------------------------------------------
  
  # use census API key
  census_api_key(KEY)
  
  # data pull for states in the ADI dataset: takes about a minute
  tic('Census Data pull')
  FIPS_pop <- get_acs(geography = "cbg", # census block group-level data
               variables = "B01003_001", # Total population
               year = 2020,
               state = state_FIPS %>% select(state_code) %>% pull(),
               survey = "acs5",
               show_call = T)
  toc()
  
  # merge with ADI data --------------------------------------------------------

  # clean population data
  FIPS_pop <- FIPS_pop %>%
    rename(FIPS = GEOID,
           blk_grp_pop = estimate) %>% 
    select(FIPS, blk_grp_pop)
  
  # merge
  data <- data %>%
    inner_join(FIPS_pop, by = "FIPS")
  # 66931492 observations left
  # 39837 zipcodes left: this is the no. of zipcodes in the final dataset.
  
  rm(FIPS_pop, state_FIPS)
  return(data)
}