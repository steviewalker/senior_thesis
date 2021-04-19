setwd("~/senior_thesis/combined_CESM_files")
nc_data <- nc_open('mlotst_Omon_CESM2_ssp585_r10i1p1f1_gn_201501-210012.nc')

mean_MLD_max_2079_2099 <- readRDS("~/senior_thesis/plotting_dataframes/mean_MLD_max_2079_2099.Rds")
mean_MLD_max_2014_2033 <- readRDS("~/senior_thesis/plotting_dataframes/mean_MLD_max_2014_2033.Rds")
MLD_change <- readRDS("~/senior_thesis/plotting_dataframes/MLD_change.Rds")

## Beginning of 21st century -------

ret <- list()
ret$lat <- ncvar_get(nc_data, "nlat")
ret$lon <- ncvar_get(nc_data, "nlon") # - 360 # we need them as negative values
ret$time <- ncvar_get(nc_data, "time")
ret$MLD <- mean_MLD_max_2014_2033

file_info <- ret

melt_mld <- function(L) {
  dimnames(L$MLD) <- list(lon = L$nlon, lat = L$nlat)
  ret <- melt(L$MLD, value.name = "mlotst")
}

melt_MLD_max_2014_2033 <- melt_mld(file_info)

MLD_max_2014_2033<- ggplot(data = melt_MLD_max_2014_2033, aes(x = lon, y = lat, fill = mlotst)) + 
  geom_raster(interpolate = TRUE) +
  scale_fill_cmocean(limits = c(0,400), oob = squish, name = "deep", direction = 1) +
  theme_bw() +
  labs(title = expression(paste("a) Short-term (2014-2034)"," MLD"[max]," (m)",sep=""))) +
  theme(axis.title = element_text(size = 9),
        plot.title = element_text(face = "bold"),
        legend.title = element_blank())

MLD_max_2014_2033

## End of 21st century -------


ret <- list()
ret$lat <- ncvar_get(nc_data, "nlat")
ret$lon <- ncvar_get(nc_data, "nlon") # - 360 # we need them as negative values
ret$time <- ncvar_get(nc_data, "time")
ret$MLD <- mean_MLD_max_2079_2099

file_info <- ret

melt_mld <- function(L) {
  dimnames(L$MLD) <- list(lon = L$nlon, lat = L$nlat)
  ret <- melt(L$MLD, value.name = "mlotst")
}

melt_MLD_max_2079_2099 <- melt_mld(file_info)

MLD_max_2079_2099<- ggplot(data = melt_MLD_max_2079_2099, aes(x = lon, y = lat, fill = mlotst)) + 
  geom_raster(interpolate = TRUE) +
  scale_fill_cmocean(limits = c(0,400), oob = squish, name = "deep", direction = 1) +
  theme_bw() +
  labs(title = expression(paste("b) Long-term (2079-2099)"," MLD"[max]," (m)",sep=""))) +
  theme(axis.title = element_text(size = 9),
        plot.title = element_text(face = "bold"),
        legend.title = element_blank())

MLD_max_2079_2099

## Change in MLD ----------


#difference, taken from calc_MLD_max.R
MLD_change = mean_MLD_max_2079_2099 - mean_MLD_max_2014_2033


ret <- list()
ret$lat <- ncvar_get(nc_data, "nlat")
ret$lon <- ncvar_get(nc_data, "nlon") # - 360 # we need them as negative values
ret$time <- ncvar_get(nc_data, "time")
ret$MLD <- MLD_change

file_info <- ret

melt_mld <- function(L) {
  dimnames(L$MLD) <- list(lon = L$nlon, lat = L$nlat)
  ret <- melt(L$MLD, value.name = "mlotst")
}

melt_MLD_change <- melt_mld(file_info)


MLD_max_change<- ggplot(data = melt_MLD_change, aes(x = lon, y = lat, fill = mlotst)) + 
  geom_raster(interpolate = TRUE) +
  scale_fill_cmocean(limits = c(-150,150), oob = squish, name = "balance", direction = -1) +
  theme_bw() +
  labs(title = expression(paste("c) Change in"," MLD"[max]," (m)",sep=""))) +
  theme(axis.title = element_text(size = 9),
        plot.title = element_text(face = "bold"),
        legend.title = element_blank())

MLD_max_change

figure <- ggarrange(MLD_max_2014_2033,MLD_max_2079_2099, MLD_max_change,
                    ncol = 1, nrow = 3)

ggsave("MLD_max_global_map.png", plot = figure, path = "~/senior_thesis/figures", width = 22, height = 30, units = "cm", dpi = 400)
