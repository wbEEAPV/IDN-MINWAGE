
* for minimum wage identifier

cd "C:\Users\wb594719\OneDrive - WBG\Minimum Wage\Data"

****
use minwage_v6.dta, clear
format %10.0g y2010 y2011 y2012 y2013 y2014 y2015 y2016 y2017 y2018 y2019 y2020 y2021 y2022 y2023

tempfile base
save `base'

* province level
use `base', clear
keep if province==1
gen idprov = int(id_code/100)

forval t=2010/2023 {
    ren y`t' prov`t'
    }
    
tempfile prov
save `prov', replace

* regency level
use `base', clear
keep if province==0
gen idprov = int(id_code/100)

forval t=2010/2023 {
    ren y`t' rege`t'
    }

merge m:1 idprov using `prov', nogen
greshape long prov rege, i(province id_code id_name idprov) j(year)

* identify regions when different from province mw
g diff = (prov!=reg)

* replace in 2010 (error in some regions)
xtset id_code year
g diff2 = D.diff
g rep =1 if diff2[_n+1]==-1
replace rege = prov if rep==1 & year==2010
drop diff diff2 rep

* identify regions when different from province mw (after fix)
g diff = (prov!=reg)

table (year) (), stat(sum diff)

* generate start to have difference
bys id_code: egen startdiffyr = min(year) if diff==1
    bys id_code: egen tempmin = min(startdiffyr)
    replace startdiffyr = tempmin
    drop tempmin
g startdifftag = (startdiff==year)
    replace startdifftag = 0 if startdiffyr==2010

table (year) (), stat(sum startdifftag)
    
* how much percentage change from province mw when regency mw decided?
g mwdiff = (rege-prov)/prov

table (year) (), stat(mean mwdiff)

* % changes in mw
bys id_code: g chmw = (rege[_n]-rege[_n-1])/rege[_n-1]

table (year) (diff), stat(mean chmw) nototals
table (year) (diff) if (startdiffyr==. | startdiffyr==2010), stat(mean chmw) nototals
