load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f1 = addfile("cru_ts4.03.1901.2018.pre.dat.nc","r")
f2 = addfile("cru_ts4.03.1901.2018.tmn.dat.nc","r")
f3 = addfile("cru_ts4.03.1901.2018.tmx.dat.nc","r")

time = calendar_decode2(f1->time,0)

n_clim = 68

clim_pre = new((/n_clim,12,360,720/), "float")
clim_tmn = new((/n_clim,12,360,720/), "float")
clim_tmx = new((/n_clim,12,360,720/), "float")

clim_years = ispan(1950,2017,1)

do ii = 0, n_clim-1
    year_idx=ind(time(:,0).eq.clim_years(ii))
    clim_pre(ii,:,:,:) = f1->pre(year_idx(5):year_idx(5)+11,:,:)
    clim_tmn(ii,:,:,:) = f2->tmn(year_idx(5):year_idx(5)+11,:,:)
    clim_tmx(ii,:,:,:) = f3->tmx(year_idx(5):year_idx(5)+11,:,:)
    print(clim_years(ii)+" index: "+year_idx(5)+":"+(year_idx(5)+11))
end do 

clim_pre_ave = dim_avg_n_Wrap(clim_pre, 0)
clim_tmn_ave = dim_avg_n_Wrap(clim_tmn, 0)
clim_tmx_ave = dim_avg_n_Wrap(clim_tmx, 0)

system("rm -rf clim.nc")
out = addfile("clim.nc", "c")
out->pre = clim_pre_ave
out->tmn = clim_tmn_ave
out->tmx = clim_tmx_ave
