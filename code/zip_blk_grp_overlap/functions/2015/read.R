# Read all the ADI data files and return a dataset with all the compiled data

read <- function(){
  # files to be read
  ADI_files <- list.files(file.path(ddir, "national_adi/2015"),
                          pattern = '.txt',
                          full.names = T)

  # readin: 
  tic('Read in ADI files') # 100 sec to run
  ADI_list <- lapply(ADI_files, 
                     function(file) {
                       read_csv(file,
                                # d - double,
                                # c- character
                                # read-in the first two columns as double, and
                                # the rest of the columns as character type
                                col_types = c("ddccccccc")) %>%
                         mutate(check_FIPS = FIPS.x == FIPS.y)
                     })
  toc()
  
  # specify filenames
  names(ADI_list) <- substr(ADI_files, 86, 87)
  
  # convert list to data: ~12 min to run
  tic('Bind data')
  ADI_data <- reduce(ADI_list, rbind)
  toc()
  
  rm(ADI_list)
  
  # export for faster use in the future
  write_parquet(ADI_data, file.path(ddir, "national_adi/2015", "ADI_compiled.parquet"))
  
  return(ADI_data)
}