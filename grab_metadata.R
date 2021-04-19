#function to get and save metadata from combined nc files to assist with plotting later

grab_metadata <- function(model.files, data.path, save.path) {

setwd(data.path)
nc_data <- nc_open(model.files)

  these.files <-  grep(model.files, value=TRUE)  
  
  
#need to fix this  
metadata.filename <- file.rename(model.files
  
# Save the metadata to a text file
sink(metadata.filename)
print(nc_data)
setwd(save.path)
sink()

#change back to current working directory
setwd(data.path)

nc_close(nc_data)

}