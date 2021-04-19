setwd("~/senior_thesis/combined_CESM_files")
nc_data <- nc_open('expc_Oyr_CESM2_ssp585_r10i1p1f1_gn_2015-2100.nc')

# Save the metadata to a text file
sink('expc_Oyr_CESM2_ssp585_r10i1p1f1_gn_2015-2100.txt')
print(nc_data)
setwd("~/senior_thesis/ncfile_metadata/")
sink()


#get longitude and latitude
lon <- ncvar_get(nc_data, "nlon")
lat <- ncvar_get(nc_data, "nlat")

#get time
time <- ncvar_get(nc_data, "time")

#listing units of time
tunits <- ncatt_get(nc_data,"time","units")
nt <- dim(time)

# convert time -- split the time units string into fields
tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth <- as.integer(unlist(tdstr)[2])
tday <- as.integer(unlist(tdstr)[3])
tyear <- as.integer(unlist(tdstr)[1])
time.corrected <- chron(time,origin=c(tmonth, tday, tyear))

#lists the dates for the averages that are being calculated
print(time.corrected)

#get depth
depth.cm <- ncvar_get(nc_data, "lev")
depth.m <- depth.cm/100
print(depth.m)

#get expc in 2014-2034
variable.st <- ncvar_get(nc_data,"expc",start= c(1,1,1,1), count = c(-1,-1,-1,20))

#get expc in 2079-2099
variable.lt <- ncvar_get(nc_data,"expc",start= c(1,1,1,66), count = c(-1,-1,-1,20))

#read in MLD max in short-term and long-term
mean_MLD_max_2014_2033 <- readRDS("~/senior_thesis/plotting_dataframes/mean_MLD_max_2014_2033.Rds")
mean_MLD_max_2014_2033 <- readRDS("~/senior_thesis/plotting_dataframes/mean_MLD_max_2014_2033.Rds")

POC_flux_max_st <- extract(variable.st, indices = )



#after interpolating along depth, apply
apply(variable.st,3, MLDmax ,na.rm=TRUE)


#calcuates short-term average POC flux over 20 years, still including the entire water column averages
avg_expc_st <- apply(variable.st,c(1,2,3),mean,na.rm=TRUE)

#calcuates short-term average POC flux over 20 years, still including the entire water column averages
avg_expc_lt <- apply(variable.lt,c(1,2,3),mean,na.rm=TRUE)

