clear
use "D:\STATA code\merged_dataset.dta"
encode iso3, gen (ID)

/*PART 5: Data Cleansing*/
bysort ID: gen missGDP = missing(GDP)
bysort ID: gen missEF = missing(EF)
bysort ID: gen missPAT = missing(PAT)
bysort ID: gen missCAP = missing(CAP)
bysort ID: gen missLAB = missing(LAB)
bysort ID: gen missREC = missing(REC)
bysort ID: gen missBIO = missing(BIO)
bysort ID: gen missINC = missing(INC)
sum missGDP missEF missPAT missCAP missLAB missREC missBIO missINC
//drop fields with >80% missing value
bysort ID: egen total_obs = count(_n)
bysort ID: egen missPAT_count = count(missPAT) if missPAT == 1
sort ID year
bysort ID: replace missPAT_count = missPAT_count[_n-1] if missing( missPAT_count )
gsort ID -year
bysort ID: replace missPAT_count = missPAT_count[_n-1] if missing( missPAT_count )
replace missPAT_count = 0 if missing( missPAT_count )
gen missPAT_pct = missPAT_count / total_obs
tab iso3 if missPAT_pct == 1
drop if missPAT_pct == 1
bysort ID: egen missEF_count = count(missEF) if missEF == 1
sort ID year
bysort ID: replace missEF_count = missEF_count[_n-1] if missing( missEF_count )
gsort ID -year
bysort ID: replace missEF_count = missEF_count[_n-1] if missing( missEF_count )
replace missEF_count = 0 if missing( missEF_count )
gen missEF_pct = missEF_count / total_obs
tab iso3 if missEF_pct == 1
drop if missEF_pct == 1
//forward & backward replacement
xtset ID year 
sort ID year
bysort ID: replace GDP = GDP[_n-1] if missing( GDP )
bysort ID: replace EF = EF[_n-1] if missing( EF )
bysort ID: replace PAT = PAT[_n-1] if missing( PAT )
bysort ID: replace CAP = CAP[_n-1] if missing( CAP )
bysort ID: replace LAB = LAB[_n-1] if missing( LAB )
bysort ID: replace REC = REC[_n-1] if missing( REC )
bysort ID: replace BIO = BIO[_n-1] if missing( BIO )
bysort ID: replace INC = INC[_n-1] if missing( INC )
gsort ID -year
bysort ID: replace GDP = GDP[_n-1] if missing( GDP )
bysort ID: replace EF = EF[_n-1] if missing( EF )
bysort ID: replace PAT = PAT[_n-1] if missing( PAT )
bysort ID: replace CAP = CAP[_n-1] if missing( CAP )
bysort ID: replace LAB = LAB[_n-1] if missing( LAB )
bysort ID: replace REC = REC[_n-1] if missing( REC )
bysort ID: replace BIO = BIO[_n-1] if missing( BIO )
bysort ID: replace INC = INC[_n-1] if missing( INC )
bysort ID: gen miss = missing(GDP)
bysort ID: replace miss = 1 if missing(EF)
bysort ID: replace miss = 1 if missing(PAT)
bysort ID: replace miss = 1 if missing(CAP)
bysort ID: replace miss = 1 if missing(LAB)
bysort ID: replace miss = 1 if missing(REC)
bysort ID: replace miss = 1 if missing(BIO)
keep if miss == 0
//ln, quadratic and cubic form generation
gen lnGDP = ln(GDP)
gen lnGDP2 = lnGDP^2
gen lnGDP3 = lnGDP^3
gen lnEF = ln(EF)
gen lnPAT = ln(PAT + 1)
gen lnPAT2 = lnPAT^2
sort ID year
gen dLAB = d.LAB

/*PART 6: Descriptive Summary*/
sum lnGDP lnEF lnPAT CAP LAB REC BIO
sum lnGDP lnEF lnPAT CAP LAB REC BIO if REGION == 0
sum lnGDP lnEF lnPAT CAP LAB REC BIO if REGION == 1
corr lnGDP lnEF lnPAT CAP LAB REC BIO

tab iso3 if REGION == 0
tab iso3 if REGION == 1
tab iso3 if INC == 0
tab iso3 if INC == 1
tab iso3 if INC == 2

/*PART 7: Preliminary Tests*/
//CSD
xtcdf lnGDP lnEF lnPAT CAP LAB REC BIO
//unit root test
pescadf lnGDP, lags(1)
pescadf lnEF, lags(1)
pescadf lnPAT, lags(1)
pescadf CAP, lags(1)
pescadf LAB, lags(1) //
pescadf dLAB, lags(1) //
pescadf REC, lags(1)
pescadf BIO, lags(1)
//cointegration
xtcointtest pedroni lnGDP lnEF lnPAT lnPAT2 CAP LAB 
xtcointtest kao lnGDP lnEF lnPAT lnPAT2 CAP LAB 
xtcointtest westerlund lnGDP lnEF lnPAT lnPAT2 CAP LAB 
xtcointtest pedroni lnEF lnGDP lnGDP2 lnGDP3 lnPAT REC BIO  
xtcointtest kao lnEF lnGDP lnGDP2 lnGDP3 lnPAT REC BIO 
xtcointtest westerlund lnEF lnGDP lnGDP2 lnGDP3 lnPAT REC BIO 

/*PART 8: SEM analysis*/
//Analysis 1
reg3 (lnGDP l.lnGDP l2.lnGDP lnEF CAP dLAB ) (lnEF l.lnEF lnGDP lnGDP2 lnGDP3 REC BIO ) if REGION == 0, endog(lnGDP lnEF)
outreg2 using Phase1.xls, replace dec(3)
reg3 (lnGDP l.lnGDP l2.lnGDP lnEF CAP dLAB ) (lnEF l.lnEF lnGDP lnGDP2 lnGDP3 REC BIO ) if REGION == 1, endog(lnGDP lnEF)
outreg2 using Phase1.xls, dec(3)

//Analysis 2
reg3 (lnGDP l.lnGDP l2.lnGDP lnEF lnPAT CAP dLAB ) (lnEF l.lnEF lnGDP lnGDP2 lnGDP3 lnPAT REC BIO ) if INC == 1, endog(lnGDP lnEF)
outreg2 using Phase2.xls, replace dec(3)
reg3 (lnGDP l.lnGDP l2.lnGDP lnEF lnPAT CAP dLAB ) (lnEF l.lnEF lnGDP lnGDP2 lnGDP3 lnPAT REC BIO ) if INC == 0, endog(lnGDP lnEF)
outreg2 using Phase2.xls, dec(3)
reg3 (lnGDP l.lnGDP l2.lnGDP lnEF lnPAT CAP dLAB ) (lnEF l.lnEF lnGDP lnGDP2 lnGDP3 lnPAT REC BIO ) if INC == 2, endog(lnGDP lnEF)
outreg2 using Phase2.xls, dec(3)

save "clean_dataset.dta", replace