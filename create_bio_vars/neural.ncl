load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

f1 = addfile("cru_ts4.03.1901.2018.pre.dat.nc","r")
f2 = addfile("cru_ts4.03.1901.2018.tmn.dat.nc","r")
f3 = addfile("cru_ts4.03.1901.2018.tmx.dat.nc","r")

time = calendar_decode2(f1->time,0)

n_neural = 21

neural_pre = new((/n_neural,12,360,720/), "float")
neural_tmn = new((/n_neural,12,360,720/), "float")
neural_tmx = new((/n_neural,12,360,720/), "float")

neural_years = (/1950,1956,1959,1960,1961,1962,1966,  \
                 1967,1978,1980,1981,1985,1989,1990,  \
                 1992,1993,1996,2001,2003,2012,2013/)

do ii = 0, n_neural-1
    year_idx=ind(time(:,0).eq.neural_years(ii))
    neural_pre(ii,:,:,:) = f1->pre(year_idx(5):year_idx(5)+11,:,:)
    neural_tmn(ii,:,:,:) = f2->tmn(year_idx(5):year_idx(5)+11,:,:)
    neural_tmx(ii,:,:,:) = f3->tmx(year_idx(5):year_idx(5)+11,:,:)
    print(neural_years(ii)+" index: "+year_idx(5)+":"+(year_idx(5)+11))
end do 

neural_pre_ave = dim_avg_n_Wrap(neural_pre, 0)
neural_tmn_ave = dim_avg_n_Wrap(neural_tmn, 0)
neural_tmx_ave = dim_avg_n_Wrap(neural_tmx, 0)

system("rm -rf neural.nc")
out = addfile("neural.nc", "c")
out->pre = neural_pre_ave
out->tmn = neural_tmn_ave
out->tmx = neural_tmx_ave