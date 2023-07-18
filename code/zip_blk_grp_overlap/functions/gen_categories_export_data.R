# generate a variable to note the category in which zip-level ADI falls

gen_categories_export_data <- function(data, ddir_folder_path){
  
  data <- data %>% 
    mutate(ADI_category = case_when(
      zip_ADI >= 0 & zip_ADI < 20 ~ "C1",
      zip_ADI >= 20 & zip_ADI < 40 ~ "C2",
      zip_ADI >= 40 & zip_ADI < 60 ~ "C3",
      zip_ADI >= 60 & zip_ADI < 80 ~ "C4",
      zip_ADI >= 80 & zip_ADI <= 100 ~ "C5"))
  
  # convert variable to categorical type
  data <- data %>% 
    mutate(ADI_category = factor(ADI_category))
  
  # save the zip-ADI crosswalk
  tic('Export data')
  write_csv(data, file.path(ddir_folder_path, "ADI_zip_crosswalk.csv"))
  write_dta(data, file.path(ddir_folder_path, "ADI_zip_crosswalk.dta"))
  toc()
}