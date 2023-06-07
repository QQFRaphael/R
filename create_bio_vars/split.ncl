load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

cases = (/"neural","WL","ML","SL","WE","ME","SE","VSE"/)
varid = (/"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19"/)
ncases = dimsizes(cases)

do ii = 0, ncases-1
    case = cases(ii)

    f = addfile(case+"-bio.nc", "r")
    bio = f->bioclim

    system("rm -rf bio/"+case)
    system("mkdir -p bio/"+case)

    do jj = 0, 18
        out = addfile("bio/"+case+"/"+"bio"+varid(jj)+".nc", "c")
        out->bio = bio(jj,:,:)
	system("gdal_translate -ot Float32 bio/"+case+"/"+"bio"+varid(jj)+".nc bio/"+case+"/"+"bio"+varid(jj)+".asc")
    end do 
end do       
