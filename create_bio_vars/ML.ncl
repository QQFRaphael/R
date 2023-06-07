load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f1 = addfile("cru_ts4.03.1901.2018.pre.dat.nc","r")
f2 = addfile("cru_ts4.03.1901.2018.tmn.dat.nc","r")
f3 = addfile("cru_ts4.03.1901.2018.tmx.dat.nc","r")

time = calendar_decode2(f1->time,0)

n_ML = 4

ML_pre = new((/n_ML,12,360,720/), "float")
ML_tmn = new((/n_ML,12,360,720/), "float")
ML_tmx = new((/n_ML,12,360,720/), "float")

ML_years = (/1955,1970,1995,2011/)

do ii = 0, n_ML-1
    year_idx=ind(time(:,0).eq.ML_years(ii))
    ML_pre(ii,:,:,:) = f1->pre(year_idx(5):year_idx(5)+11,:,:)
    ML_tmn(ii,:,:,:) = f2->tmn(year_idx(5):year_idx(5)+11,:,:)
    ML_tmx(ii,:,:,:) = f3->tmx(year_idx(5):year_idx(5)+11,:,:)
    print(ML_years(ii)+" index: "+year_idx(5)+":"+(year_idx(5)+11))
end do 

ML_pre_ave = dim_avg_n_Wrap(ML_pre, 0)
ML_tmn_ave = dim_avg_n_Wrap(ML_tmn, 0)
ML_tmx_ave = dim_avg_n_Wrap(ML_tmx, 0)

system("rm -rf ML.nc")
out = addfile("ML.nc", "c")
out->pre = ML_pre_ave
out->tmn = ML_tmn_ave
out->tmx = ML_tmx_ave