#===============================================================================
# Description:
# Check and install R packages if not already installed
#===============================================================================

check_install <- function(pkg){
  
  if(!(pkg %in% installed.packages())){
    
    install.packages(pkg, repos="http://cran.rstudio.com/", dependencies = T)
    return(paste(pkg, "is now installed"))
    
    } 
  else {
    
    return(paste(pkg, "is already installed"))
    
  }
}

