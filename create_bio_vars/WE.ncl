load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f1 = addfile("cru_ts4.03.1901.2018.pre.dat.nc","r")
f2 = addfile("cru_ts4.03.1901.2018.tmn.dat.nc","r")
f3 = addfile("cru_ts4.03.1901.2018.tmx.dat.nc","r")

time = calendar_decode2(f1->time,0)

n_WE = 10

WE_pre = new((/n_WE,12,360,720/), "float")
WE_tmn = new((/n_WE,12,360,720/), "float")
WE_tmx = new((/n_WE,12,360,720/), "float")

WE_years = (/1952,1953,1958,1969,1976,1977,1979,2004,2006,2014/)

do ii = 0, n_WE-1
    year_idx=ind(time(:,0).eq.WE_years(ii))
    WE_pre(ii,:,:,:) = f1->pre(year_idx(5):year_idx(5)+11,:,:)
    WE_tmn(ii,:,:,:) = f2->tmn(year_idx(5):year_idx(5)+11,:,:)
    WE_tmx(ii,:,:,:) = f3->tmx(year_idx(5):year_idx(5)+11,:,:)
    print(WE_years(ii)+" index: "+year_idx(5)+":"+(year_idx(5)+11))
end do 

WE_pre_ave = dim_avg_n_Wrap(WE_pre, 0)
WE_tmn_ave = dim_avg_n_Wrap(WE_tmn, 0)
WE_tmx_ave = dim_avg_n_Wrap(WE_tmx, 0)

system("rm -rf WE.nc")
out = addfile("WE.nc", "c")
out->pre = WE_pre_ave
out->tmn = WE_tmn_ave
out->tmx = WE_tmx_ave