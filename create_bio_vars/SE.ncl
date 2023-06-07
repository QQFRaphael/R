load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f1 = addfile("cru_ts4.03.1901.2018.pre.dat.nc","r")
f2 = addfile("cru_ts4.03.1901.2018.tmn.dat.nc","r")
f3 = addfile("cru_ts4.03.1901.2018.tmx.dat.nc","r")

time = calendar_decode2(f1->time,0)

n_SE = 5

SE_pre = new((/n_SE,12,360,720/), "float")
SE_tmn = new((/n_SE,12,360,720/), "float")
SE_tmx = new((/n_SE,12,360,720/), "float")

SE_years = (/1957,1965,1972,1987,1991/)

do ii = 0, n_SE-1
    year_idx=ind(time(:,0).eq.SE_years(ii))
    SE_pre(ii,:,:,:) = f1->pre(year_idx(5):year_idx(5)+11,:,:)
    SE_tmn(ii,:,:,:) = f2->tmn(year_idx(5):year_idx(5)+11,:,:)
    SE_tmx(ii,:,:,:) = f3->tmx(year_idx(5):year_idx(5)+11,:,:)
    print(SE_years(ii)+" index: "+year_idx(5)+":"+(year_idx(5)+11))
end do 

SE_pre_ave = dim_avg_n_Wrap(SE_pre, 0)
SE_tmn_ave = dim_avg_n_Wrap(SE_tmn, 0)
SE_tmx_ave = dim_avg_n_Wrap(SE_tmx, 0)

system("rm -rf SE.nc")
out = addfile("SE.nc", "c")
out->pre = SE_pre_ave
out->tmn = SE_tmn_ave
out->tmx = SE_tmx_ave