# clean raw data for 2015 ADI

clean_raw_ADI <- function(data){
  
  # select and rename variables, extract zipcodes
  data <- data %>% 
    # extract zip
    mutate(zip = substr(ZIPID, 2, 6)) %>%
    
    # how many digits in each of the FIPS variables
    mutate(FIPS.x_length = nchar(FIPS.x),
           FIPS.y_length = nchar(FIPS.y)) %>%
    
    # out of FIPS vars, retain only FIPS.y because it has 12 digit FIPS codes
    # for observations with check = F, the difference between FIPS.x and FIPS.y
    # is just a leading zero
    select(11, 7:8) %>%
    rename("FIPS" = "FIPS.y") 

  # count zipcodes in dataset: 39870, 66790166 observations
  data %>% summarize(n_distinct(zip))
  
  # remove observations with invalid ADI
  data <- data %>% 
    filter(!ADI_NATRANK %in% SUPPRESSION_CODES) %>%
    filter(!is.na(ADI_NATRANK))
  
  # count zipcodes in dataset: 39,283, 65356171 observations
  data %>% summarize(n_distinct(zip))
  
  return(data)
}