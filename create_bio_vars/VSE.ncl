load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f1 = addfile("cru_ts4.03.1901.2018.pre.dat.nc","r")
f2 = addfile("cru_ts4.03.1901.2018.tmn.dat.nc","r")
f3 = addfile("cru_ts4.03.1901.2018.tmx.dat.nc","r")

time = calendar_decode2(f1->time,0)

n_VSE = 3

VSE_pre = new((/n_VSE,12,360,720/), "float")
VSE_tmn = new((/n_VSE,12,360,720/), "float")
VSE_tmx = new((/n_VSE,12,360,720/), "float")

VSE_years = (/1982,1997,2015/)

do ii = 0, n_VSE-1
    year_idx=ind(time(:,0).eq.VSE_years(ii))
    VSE_pre(ii,:,:,:) = f1->pre(year_idx(5):year_idx(5)+11,:,:)
    VSE_tmn(ii,:,:,:) = f2->tmn(year_idx(5):year_idx(5)+11,:,:)
    VSE_tmx(ii,:,:,:) = f3->tmx(year_idx(5):year_idx(5)+11,:,:)
    print(VSE_years(ii)+" index: "+year_idx(5)+":"+(year_idx(5)+11))
end do 

VSE_pre_ave = dim_avg_n_Wrap(VSE_pre, 0)
VSE_tmn_ave = dim_avg_n_Wrap(VSE_tmn, 0)
VSE_tmx_ave = dim_avg_n_Wrap(VSE_tmx, 0)

system("rm -rf VSE.nc")
out = addfile("VSE.nc", "c")
out->pre = VSE_pre_ave
out->tmn = VSE_tmn_ave
out->tmx = VSE_tmx_ave