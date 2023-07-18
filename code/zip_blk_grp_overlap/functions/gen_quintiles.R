# generate a variable to store the quintiles within which zip-level ADI falls

gen_quintiles <- function(data){
  
  # bring data to zip-level from zip-FIPS level
  data <- data %>% 
    select(zip, zip_ADI) %>%
    distinct(zip, .keep_all = T)
  
  data$ADI_quintile <- with(data, 
                            # create a factor variable with quantile labels
                            factor(
                              # find which interval an observatoin falls in
                              findInterval(zip_ADI, 
                                           # estimate quintiles from from distribution of ADI
                                           c(-Inf, quantile(zip_ADI, probs=PROB), Inf)), 
                              # label intervals as quintiles
                              labels=c("Q1","Q2","Q3","Q4","Q5")))
  
  # return the updated data
  return(data)
}