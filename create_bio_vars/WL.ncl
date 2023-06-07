load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f1 = addfile("cru_ts4.03.1901.2018.pre.dat.nc","r")
f2 = addfile("cru_ts4.03.1901.2018.tmn.dat.nc","r")
f3 = addfile("cru_ts4.03.1901.2018.tmx.dat.nc","r")

time = calendar_decode2(f1->time,0)

n_WL = 11

WL_pre = new((/n_WL,12,360,720/), "float")
WL_tmn = new((/n_WL,12,360,720/), "float")
WL_tmx = new((/n_WL,12,360,720/), "float")

WL_years = (/1954,1964,1971,1974,1983,1984,2000,2005,2008,2016,2017/)

do ii = 0, n_WL-1
    year_idx=ind(time(:,0).eq.WL_years(ii))
    WL_pre(ii,:,:,:) = f1->pre(year_idx(5):year_idx(5)+11,:,:)
    WL_tmn(ii,:,:,:) = f2->tmn(year_idx(5):year_idx(5)+11,:,:)
    WL_tmx(ii,:,:,:) = f3->tmx(year_idx(5):year_idx(5)+11,:,:)
    print(WL_years(ii)+" index: "+year_idx(5)+":"+(year_idx(5)+11))
end do 

WL_pre_ave = dim_avg_n_Wrap(WL_pre, 0)
WL_tmn_ave = dim_avg_n_Wrap(WL_tmn, 0)
WL_tmx_ave = dim_avg_n_Wrap(WL_tmx, 0)

system("rm -rf WL.nc")
out = addfile("WL.nc", "c")
out->pre = WL_pre_ave
out->tmn = WL_tmn_ave
out->tmx = WL_tmx_ave