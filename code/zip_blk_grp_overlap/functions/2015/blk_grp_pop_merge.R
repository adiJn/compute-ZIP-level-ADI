# add census block group population data to ADI data using FIPS code

blk_grp_pop_merge <- function(data){
  
  # get the state FIPS codes from this ADI dataset, store them in separate dataset
  state_FIPS <- data %>% 
    mutate(state_code = substr(FIPS,1,2)) %>%
    select(state_code) %>%
    na.omit() %>%
    unique()
  
  # get population data --------------------------------------------------------
  
  # use census API key
  census_api_key(KEY)
  
  # data pull for states in the ADI dataset: takes about a minute
  tic('Census Data pull') # about 1.25 min to run
  FIPS_pop <- get_acs(geography = "cbg", # census block group-level data
                      variables = "B01003_001", # Total population
                      year = 2015,
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
  # no zipcodes lost by merging with population data
  
  rm(FIPS_pop, state_FIPS)
  return(data)
}