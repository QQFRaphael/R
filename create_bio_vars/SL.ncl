load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f1 = addfile("cru_ts4.03.1901.2018.pre.dat.nc","r")
f2 = addfile("cru_ts4.03.1901.2018.tmn.dat.nc","r")
f3 = addfile("cru_ts4.03.1901.2018.tmx.dat.nc","r")

time = calendar_decode2(f1->time,0)

n_SL = 7

SL_pre = new((/n_SL,12,360,720/), "float")
SL_tmn = new((/n_SL,12,360,720/), "float")
SL_tmx = new((/n_SL,12,360,720/), "float")

SL_years = (/1973,1975,1988,1998,1999,2007,2010/)

do ii = 0, n_SL-1
    year_idx=ind(time(:,0).eq.SL_years(ii))
    SL_pre(ii,:,:,:) = f1->pre(year_idx(5):year_idx(5)+11,:,:)
    SL_tmn(ii,:,:,:) = f2->tmn(year_idx(5):year_idx(5)+11,:,:)
    SL_tmx(ii,:,:,:) = f3->tmx(year_idx(5):year_idx(5)+11,:,:)
    print(SL_years(ii)+" index: "+year_idx(5)+":"+(year_idx(5)+11))
end do 

SL_pre_ave = dim_avg_n_Wrap(SL_pre, 0)
SL_tmn_ave = dim_avg_n_Wrap(SL_tmn, 0)
SL_tmx_ave = dim_avg_n_Wrap(SL_tmx, 0)

system("rm -rf SL.nc")
out = addfile("SL.nc", "c")
out->pre = SL_pre_ave
out->tmn = SL_tmn_ave
out->tmx = SL_tmx_ave