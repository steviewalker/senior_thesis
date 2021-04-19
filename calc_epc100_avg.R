#code from https://www.researchgate.net/post/How-can-I-extract-a-time-series-of-variable-for-a-specific-location-specific-longitude-and-latitude-from-a-CMIP5-experiment-netCDF-data-set


## Calculating short term average (2014-2034) ---------------

#open nc file
setwd("~/senior_thesis/combined_CESM_files")
nc_data <- nc_open('epc100_Omon_CESM2_ssp585_r10i1p1f1_gn_201501-210012.nc')

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

#use time.corrected to see the actual dates for the average you are calculating

#get variable at specified time range (12 months x 20 years = 240 months, aka 240 time count)
variable_st <- ncvar_get(nc_data,"epc100",start= c(1,1,5), count = c(-1,-1, 240))

#calculate average global POC flux for every month between 2014-2034 NOTE: come back and try and plot this later for selected regions
var_ts <- apply(variable_st,3,mean,na.rm=TRUE)

#calculate average POC flux for each grid cell over the years 2014-2034
var_average1 <- apply(variable_st, c(1,2),mean,na.rm=TRUE)

#converted value to plot
var_year1 = var_average1*31536000

## Calculating long-term average (2079-2099) and change in epc100 -----------


#get variable at specified time range (12 months x 20 years = 240 months, 1023 months - 240 months)
#starting at Jan 2079
variable_lt <- ncvar_get(nc_data,"epc100",start= c(1,1,786), count = c(-1,-1,240))

#calculate average POC flux for each grid cell over the years 2013-2033
var_average2 <- apply(variable_lt, c(1,2),mean,na.rm=TRUE)

#convert from mol/m2/s to mol/m2/yr I need help here
var_year2 = var_average2*31536000

#calculate change in average POC flux between beginning and end of 21st c
var_difference = var_average2 - var_average1

#for plotting
var_difference_yr = var_difference*31536000

setwd("~/senior_thesis/plotting_dataframes/")
saveRDS(var_year1, file = "epc100_avg_st.Rds", ascii = TRUE)
saveRDS(var_year2, file = "epc100_avg_lt.Rds", ascii = TRUE)
saveRDS(var_difference_yr, file = "epc100_diff.Rds", ascii = TRUE)
