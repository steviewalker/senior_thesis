#code from Hem for how to upload to the cloud

variables <- c("tos","arag","calc","chl","intpp","no3","o2","ph","phyc","po4","si","sos","talk")

model.list.download  <- c("GFDL-CM4", "CNRM-CM6-1-HR","MPI-ESM1-2-HR","CMCC-CM2-SR5")
#model.list.download  <- c("CNRM-CM6-1-HR")

#ScenarioMIP

nc.dir <- "~/cmip6_goc/cmip6_data"

dir.create(nc.dir)


for(eachvariable in 1:length(variables)) {
  
  this.variable <- variables[eachvariable]
  
  nc.var.dir <- paste0(nc.dir,"/",this.variable,"/")
  
  if(dir.exists(nc.var.dir)==FALSE) dir.create(nc.var.dir)
  
  nc.test <- list.files(nc.var.dir, pattern="*.nc") %>%
    is_empty()
  
  if(nc.test==TRUE){
    
    data.cimp6.sc <- lapply(model.list.download, get_nc, model.var = this.variable) %>%
      bind_rows
    
    #Historical data
    #salinity is "sos"
    data.cimp6.hist <- lapply(model.list.download, get_historical_nc, model.var = this.variable) %>%
      bind_rows
    
    data.cimp6.table <- bind_rows(data.cimp6.hist, data.cimp6.sc)
    
    write_csv(data.cimp6.table, paste0(this.variable,"_data_cimp6_table.csv"))
    
    nc.files <- list.files(pattern=paste0(this.variable,"_*.*nc$"), full.names = FALSE)
    
    
    file.rename(from= paste0("~/cmip6_goc/",nc.files), to = paste0(nc.var.dir,nc.files))                    
    
    
  }
  
  nc.test <- list.files(nc.var.dir, pattern="*.nc") %>%
    is_empty()
  
  if(nc.test == FALSE){
    
    system(paste("azcopy", paste("--source ", nc.dir,"/",this.variable,sep=""), paste("--destination [https://walkerthesisserver.blob.core.windows.net/]",
                                                                                      this.variable," ",sep=""),"--dest-key [MByOnd8FML1Fl7Nz9i5ucbj57DQlyRRRemelibK+5T6l+rp1vJO+aaj69UtYSkih56AbHlSwdG3gvcozScPDsg==]", "--recursive", "--quiet", "--exclude-older",sep=" \\"), wait=TRUE)
    
  }
}

#another piece of code from Hem
system(paste("azcopy", paste("--source ", nc.dir,"/",this.variable,sep=""), paste("--destination [storage account name]/cmipdata/",this.variable," ",sep=""),"--dest-key [key number] ", "--recursive", "--quiet", "--exclude-older",sep=" \\"), wait=TRUE)
