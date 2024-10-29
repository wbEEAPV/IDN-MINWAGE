*** additional

clear all
set more off
set maxvar 120000
set seed 10051990 

* Define username
local suser = upper(c(username))

*Please update directories for the following dofile:

*Will
if (inlist("`suser'","wb454594", "WB454594")) {
	global msLocal 	= "C:\Users\WB454594\OneDrive - WBG\EEAPV Documents\Countries\Indonesia\Informality\Analysis"
    global min "C:\Users\WB454594\OneDrive - WBG\Indonesia\Informality\Data"
    global sak "C:\Users\WB454594\WBG\EEAPV IDN Data Files - EEAPV IDN Documents\SAKERNAS\Coded Data"
    global dat "C:\Users\WB454594\OneDrive - WBG\Indonesia\Data\SAKERNAS"
    global minwa "C:\Users\WB454594\OneDrive - WBG\Indonesia\Minimum Wage\Data"
	global shp "C:\Users\WB454594\OneDrive - WBG\Indonesia\Minimum Wage/shapefile/"    
    }
* Sam
else if (inlist("`suser'","wb594719","WB594719")) {
    global msLocal = "C:\Users\wb594719\OneDrive - WBG\Informality\Analysis"
    global min "C:\Users\wb594719\OneDrive - WBG\Informality\Data"
    global sak "C:\Users\wb594719\OneDrive - WBG\EEAPV IDN Documents\SAKERNAS\Coded Data"
    global dat "C:\Users\wb594719\OneDrive - WBG\Minimum Wage\Data"
    global minwa "C:\Users\wb594719\OneDrive - WBG\Minimum Wage\Data"        
	global shp "C:\Users\wb594719\OneDrive - WBG\Minimum Wage\Shapefile"    
    }    
    
    
*** match with regency minimum wage data

    use "$minwa/minwage_clean.dta", clear
    ren prov mw_prov
    ren rege mw_dist
    ren diff provdist_mwdiff
    ren id_code district_code 
    
    * Surakarta fix (3372)
        replace mw_dist = 785000 if district_code==3372 & year==2010
        replace mw_dist = 826252 if district_code==3372 & year==2011
        
    * Cirebon fix (3209)
        replace mw_dist = 825000 if district_code==3209 & year==2010
    
    * Cirebon city fix (3274)
        replace mw_dist = 840000 if district_code==3274 & year==2010
    

    
    drop if year==2023
    keep district_code year mw_prov mw_dist provdist_mwdiff startdiffyr startdifftag chmw
    
    tempfile minwagedat
    save `minwagedat', replace
    
    
* merge 
    use "${dat}/SakernasWillPanel@1.dta", clear
    merge m:1 district_code year using `minwagedat'
    

g realmwage_