library('ncdf4')
library('dismo')

cases<-c("ME","WE","SE", "VSE","ML","WL","SL","neural","clim")

for(case in cases)
{
nc<-nc_open(paste(case,".nc",sep=""))

pre<-ncvar_get( nc = nc, varid = 'pre')
tmn<-ncvar_get( nc = nc, varid = 'tmn')
tmx<-ncvar_get( nc = nc, varid = 'tmx')
lat<-ncvar_get( nc = nc, varid = 'lat')
lon<-ncvar_get( nc = nc, varid = 'lon')

bio<-array(1:4924800,dim=c(720,360,19))

for(jj in 1:360)
{
for(kk in 1:720)
{
bio[kk,jj,1:19]<-biovars(pre[kk,jj,1:12],tmn[kk,jj,1:12],tmx[kk,jj,1:12])
print(paste("deal with ",case,": ",jj,"-",kk))
}
}

t <- ncdim_def( name = 'bio', units = 'index', vals = 1:19 )
longitude <- ncdim_def( name = 'lon', units = 'degrees_east', vals = lon )
latitude <- ncdim_def( name = 'lat', units = 'degrees_north', vals = lat )
bioclim <- ncvar_def( name = 'bioclim', units = 'None', dim = list(longitude,latitude,t), missval = NA, prec = 'double' )
ncnew <- nc_create( filename = paste(case,"-bio.nc",sep=""), vars = bioclim )
ncvar_put( nc = ncnew, varid = bioclim, vals = bio )
nc_close(ncnew)
}
