# unzip and save ADI files

all_unzip <- function(){
  # files to be unzipped
  zip_files <- list.files(file.path(rdir),
                          pattern = '.zip',
                          full.names = T)
  
  # unzip and save
  zip_files <- lapply(zip_files, function(x){
    unzip(x, exdir = file.path(ddir, "national_adi"))
  })
  
  # cleanup
  rm(zip_files)
}