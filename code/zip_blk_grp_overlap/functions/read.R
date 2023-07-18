# Read all the ADI data files and return a dataset with all the compiled data

read <- function(){
  # files to be read
  ADI_files <- list.files(file.path(ddir, "national_adi"),
                          pattern = '.csv',
                          full.names = T)
  
  # readin: 30 sec to run
  tic('Read in ADI files')
  ADI_list <- lapply(ADI_files, read_csv)
  toc()
  
  # specify filenames
  names(ADI_list) <- substr(ADI_files, 81, 87)
  
  # remove US wide blk grp data
  ADI_list <- ADI_list[names(ADI_list) %in% "US2020" == F]
  
  # convert list to data: 12 min to run
  tic('Bind data')
  ADI_data <- reduce(ADI_list, rbind)
  toc()
  
  rm(ADI_list)
  
  # export for faster use in the future
  write_parquet(ADI_data, file.path(ddir, "national_adi", "ADI_compiled.parquet"))
  
  return(ADI_data)
 }