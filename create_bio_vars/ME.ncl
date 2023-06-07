load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f1 = addfile("cru_ts4.03.1901.2018.pre.dat.nc","r")
f2 = addfile("cru_ts4.03.1901.2018.tmn.dat.nc","r")
f3 = addfile("cru_ts4.03.1901.2018.tmx.dat.nc","r")

time = calendar_decode2(f1->time,0)

n_ME = 7

ME_pre = new((/n_ME,12,360,720/), "float")
ME_tmn = new((/n_ME,12,360,720/), "float")
ME_tmx = new((/n_ME,12,360,720/), "float")

ME_years = (/1951,1963,1968,1986,1994,2002,2009/)

do ii = 0, n_ME-1
    year_idx=ind(time(:,0).eq.ME_years(ii))
    ME_pre(ii,:,:,:) = f1->pre(year_idx(5):year_idx(5)+11,:,:)
    ME_tmn(ii,:,:,:) = f2->tmn(year_idx(5):year_idx(5)+11,:,:)
    ME_tmx(ii,:,:,:) = f3->tmx(year_idx(5):year_idx(5)+11,:,:)
    print(ME_years(ii)+" index: "+year_idx(5)+":"+(year_idx(5)+11))
end do 

ME_pre_ave = dim_avg_n_Wrap(ME_pre, 0)
ME_tmn_ave = dim_avg_n_Wrap(ME_tmn, 0)
ME_tmx_ave = dim_avg_n_Wrap(ME_tmx, 0)

system("rm -rf ME.nc")
out = addfile("ME.nc", "c")
out->pre = ME_pre_ave
out->tmn = ME_tmn_ave
out->tmx = ME_tmx_ave