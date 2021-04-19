#open nc file
setwd("~/senior_thesis/combined_CESM_files")
nc_data <- nc_open('epc100_Omon_CESM2_ssp585_r10i1p1f1_gn_201501-210012.nc')

var_year1 <- readRDS("~/senior_thesis/plotting_dataframes/epc100_avg_st.Rds")
var_year2 <- readRDS("~/senior_thesis/plotting_dataframes/epc100_avg_lt.Rds")
var_difference_yr <- readRDS("~/senior_thesis/plotting_dataframes/epc100_diff.Rds")


# #basic plot of downward POC flux at the beginning of the 21st ce --------


#plot average POC flux for early 21st century
ret <- list()
ret$lat <- ncvar_get(nc_data, "nlat")
ret$lon <- ncvar_get(nc_data, "nlon") # - 360 # we need them as negative values
ret$time <- ncvar_get(nc_data, "time")
ret$epc100 <- var_year1

file_info <- ret

#melt data so I can plot it in ggplot
melt_epc100 <- function(L) {
  dimnames(L$epc100) <- list(lon = L$nlon, lat = L$nlat)
  ret <- melt(L$epc100, value.name = "epc100")
}

mepc100 <- melt_epc100(file_info)

basic.plot<- ggplot(data = mepc100, aes(x = lon, y = lat, fill = epc100)) + 
  geom_raster(interpolate = TRUE) +
  scale_fill_cmocean(limits = c(0,8), oob = squish, name = "deep", direction = 1) +
  theme_bw() +
  labs(title = expression(paste("a) Short-term (2014-2034) POC Flux (mol ",m^-2," ",y^-1,")", sep = ""))) +
  theme(axis.title = element_text(size = 9),
        plot.title = element_text(face = "bold"),
        legend.title = element_blank())


basic.plot

# #basic plot of downward POC flux at the end of the 21st ce --------



#plot average POC flux for early 21st century
ret <- list()
ret$lat <- ncvar_get(nc_data, "nlat")
ret$lon <- ncvar_get(nc_data, "nlon") # - 360 # we need them as negative values
ret$time <- ncvar_get(nc_data, "time")
ret$epc100 <- var_year2

file_info <- ret

#melt data so I can plot it in ggplot
melt_epc100 <- function(L) {
  dimnames(L$epc100) <- list(lon = L$nlon, lat = L$nlat)
  ret <- melt(L$epc100, value.name = "epc100")
}

mepc100 <- melt_epc100(file_info)

basic.plot2<- ggplot(data = mepc100, aes(x = lon, y = lat, fill = epc100)) + 
  geom_raster(interpolate = TRUE) +
  scale_fill_cmocean(limits = c(0,8), oob = squish, name = "deep", direction = 1) +
  theme_bw() +
  labs(title = expression(paste("b) Long-term (2079-2099) POC Flux (mol ",m^-2," ",y^-1,")", sep = ""))) +
  theme(axis.title = element_text(size = 9),
        plot.title = element_text(face = "bold"),
        legend.title = element_blank())

basic.plot2


# Plot of change in POC flux in 21st c ------------------------------------


ret <- list()
ret$lat <- ncvar_get(nc_data, "nlat")
ret$lon <- ncvar_get(nc_data, "nlon") # - 360 # we need them as negative values
ret$time <- ncvar_get(nc_data, "time")
ret$epc100 <- var_difference_yr

file_info <- ret

#melt data so I can plot it in ggplot
melt_epc100 <- function(L) {
  dimnames(L$epc100) <- list(lon = L$nlon, lat = L$nlat)
  ret <- melt(L$epc100, value.name = "epc100")
}

mepc100 <- melt_epc100(file_info)

basic.plot3<- ggplot(data = mepc100, aes(x = lon, y = lat, fill = epc100)) + 
  geom_raster(interpolate = TRUE) +
  scale_fill_cmocean(limits = c(-2,2), oob = squish, name = "balance", direction = -1)+
  theme_bw() +
  labs(title = expression(paste("c) Change in POC Flux (mol ",m^-2," ",y^-1,")", sep = ""))) +
  theme(axis.title = element_text(size = 9),
        plot.title = element_text(face = "bold"),
        legend.title = element_blank())


basic.plot3

figure <- ggarrange(basic.plot, basic.plot2, basic.plot3,
                    ncol = 1, nrow = 3)
figure

ggsave("epc100_global_map.png", plot = figure, path = "~/senior_thesis/figures", width = 22, height = 30, units = "cm", dpi = 400)

