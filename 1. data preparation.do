/*DATA PREPARATION WORKFLOW*/
clear all
cd "D:\STATA code"

/*PART 1: World Bank Data*/

* Install package (only needed once)
* ssc install wbopendata, replace

* Download WDI data
wbopendata, language(en - English) ///
    country(AFG;AGO;ARE;ARM;AZE;BDI;BEN;BFA;BGD;BHR;BRN;BTN;BWA;CAF;CHN;CIV;CMR;COD;COG;COM;CPV;CYP;DJI;DZA;EGY;ERI;ETH;GAB;GEO;GHA;GIN;GMB;GNB;GNQ;IDN;IND;IRN;IRQ;ISR;JOR;JPN;KAZ;KEN;KGZ;KHM;KOR;KWT;LAO;LBN;LBR;LBY;LKA;LSO;MDG;MDV;MLI;MMR;MNG;MOZ;MRT;MUS;MWI;MYS;NAM;NER;NGA;NPL;OMN;PAK;PHL;PRK;PSE;QAT;RUS;RWA;SAU;SDN;SEN;SGP;SLE;SOM;SSD;STP;SWZ;SYC;SYR;TCD;TGO;THA;TJK;TKM;TLS;TUN;TUR;TZA;UGA;UZB;VNM;YEM;ZAF;ZMB;ZWE) ///
    indicator(EG.FEC.RNEW.ZS; SL.TLF.CACT.ZS; NE.GDI.TOTL.ZS; NY.GDP.PCAP.KD; NY.GNP.PCAP.CD) ///
    year(2000:2023) clear long nometadata

* Rename and label variables
rename ny_gdp_pcap_kd GDP
rename ne_gdi_totl_zs CAP
rename sl_tlf_cact_zs LAB
rename eg_fec_rnew_zs REC
rename ny_gnp_pcap_cd GNI
gen byte region_num = .
replace region_num = 1 if inlist(region, "EAS", "ECS", "SAS")
replace region_num = 0 if inlist(region, "MEA", "SSF")
drop region
rename region_num REGION

* Label
label define region_lbl 0 "African" 1 "Asian"
label values REGION region_lbl
label variable REGION "Region (1=Asian, 0=African)"
label variable CAP "Capital Formation"
label variable LAB "Labor Force"
label variable GDP "GDP per capita"
label variable REC "Renewable energy consumption"
label variable GNI "GNI per capita, Atlas method"

/*PART 2: Income Classification*/

* Create income threshold data
preserve
clear
input int year double lm double mh
2000  755   9265
2001  745   9205
2002  735   9075
2003  765   9385
2004  825  10065
2005  875  10725
2006  905  11115
2007  935  11455
2008  975  11905
2009  995  12195
2010 1005  12275
2011 1025  12475
2012 1035  12615
2013 1045  12745
2014 1045  12735
2015 1025  12475
2016 1005  12235
2017  995  12055
2018 1026  12375
2019 1036  12535
2020 1046  12695
2021 1086  13205
2022 1136  13845
2023 1146  14005
end
tempfile thr
save `thr'
restore

* Merge with thresholds
merge m:1 year using `thr', keep(master match) nogen

* Classify income levels
gen byte INC = .
replace INC = 0 if !missing(GNI, lm, mh) & GNI <  lm
replace INC = 1 if !missing(GNI, lm, mh) & GNI >= lm & GNI < mh
replace INC = 2 if !missing(GNI, lm, mh) & GNI >= mh

label define INC_lbl 0 "Low income" 1 "Middle income" 2 "High income", replace
label values INC INC_lbl
label variable INC "Income classification"

drop lm mh

* Check classification
tab year INC, missing

* Standardize country code variable
rename countrycode iso3
sort iso3 year

* Save WDI data
save "data_WDI.dta", replace

/*PART 3: Merge Ecological Footprint Data*/

* Prepare master (WDI data)
use "data_WDI.dta", clear
sort iso3 year
save "temp_master.dta", replace

* Prepare using (Footprint data)
clear
import excel "Footprint_Biosiversity_GFN.xlsx", sheet("national_data") firstrow

* Keep only needed variables
rename country_ISO3 iso3
rename efc_total_percapita EF
rename biocap_total_percapita BIO

keep iso3 year EF BIO

label variable EF "Ecological Footprint per capita (gha)"
label variable BIO "Biocapacity per capita (gha)"

sort iso3 year
tempfile footprint
save `footprint'

* Merge
use "temp_master.dta", clear
merge 1:1 iso3 year using `footprint', keep(master match) gen(_merge_footprint)
tab _merge_footprint

* Save intermediate file
save "merged_with_footprint.dta", replace

/*PART 4: Merge Patent Data*/

* Prepare master
use "merged_with_footprint.dta", clear
sort iso3 year
save "temp_master.dta", replace

* Prepare using (Patent data)
clear
import excel "Total patent applications_WIPO.xlsx", sheet("patent_data") firstrow

* Reshape from wide to long
drop if missing(OfficeISO3)
reshape long y, i(OfficeISO3) j(year)
rename y PAT
rename OfficeISO3 iso3

drop if missing(iso3)
drop if missing(PAT)

label variable PAT "Total patent applications"

sort iso3 year
tempfile patent
save `patent'

* Merge
use "temp_master.dta", clear
merge 1:1 iso3 year using `patent', keep(master match) gen(_merge_patent)
tab _merge_patent

* Save final dataset
save "merged_dataset.dta", replace
erase "data_WDI.dta"
erase "merged_with_footprint.dta"