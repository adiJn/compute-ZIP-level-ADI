# computed a zip-level block group level population weighted ADI

zip_level_pop_weighted_ADI <- function(data){
  
  tic('Compute weighted average') 
  data <- data %>% 
    # only keep one FIPS-zip combination
    distinct(FIPS, zip, .keep_all = TRUE) %>%
    group_by(zip) %>%
    arrange(zip) %>%
    # add a weighted average of ADI ranks with the weights being block 
    # group populations
    mutate(ADI_NATRANK = as.numeric(ADI_NATRANK),
           zip_ADI = weighted.mean(ADI_NATRANK,
                                    blk_grp_pop)) %>% # weights
    ungroup() 
  toc()
  
  return(data)
}