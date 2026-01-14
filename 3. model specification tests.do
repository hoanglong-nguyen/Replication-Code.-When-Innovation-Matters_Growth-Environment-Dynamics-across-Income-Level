clear
use "D:\STATA code\clean_dataset.dta"

/*PART 9: Model Specification Tests*/
//Heteroskedasticity
reg3 (lnGDP l.lnGDP l2.lnGDP lnEF lnPAT CAP dLAB ) (lnEF l.lnEF lnGDP lnGDP2 lnGDP3 lnPAT REC BIO ), endog(lnGDP lnEF)
lmhreg3
*Run system without dfk
reg3 (lnGDP l.lnGDP l2.lnGDP lnEF lnPAT CAP dLAB) (lnEF l.lnEF lnGDP lnGDP2 lnGDP3 lnPAT REC BIO), endog(lnGDP lnEF) 3sls
estimates store no_dfk
*Run system with dfk option
reg3 (lnGDP l.lnGDP l2.lnGDP lnEF lnPAT CAP dLAB) (lnEF l.lnEF lnGDP lnGDP2 lnGDP3 lnPAT REC BIO), endog(lnGDP lnEF) 3sls dfk
estimates store with_dfk
*Compare results side by side
esttab no_dfk with_dfk, se(%9.4f) b(%9.4f) ///
    title("reg3 estimates with and without dfk") label
*Export to Excel
outreg2 [no_dfk with_dfk] using dfk_comparison.xls, replace ///
    ctitle(No-DFK With-DFK)

//Autocorrelation
reg3 (lnGDP l.lnGDP l2.lnGDP lnEF lnPAT CAP dLAB) (lnEF l.lnEF lnGDP lnGDP2 lnGDP3 lnPAT REC BIO), endog(lnGDP lnEF) 3sls
lmareg3

//Endogeneity
reg lnEF REC BIO lnPAT CAP dLAB
predict lnEF_hat
gen lnEF_resid = lnEF - lnEF_hat
reg lnGDP l.lnGDP lnEF lnPAT CAP dLAB lnEF_resid
test lnEF_resid

//Optimal lag test
program define manual_lag_selection_EF
    args max_lags
    
    matrix results = J(`max_lags', 4, .)
    matrix colnames results = Lag AIC BIC LogLik
    
    forvalues p = 1/`max_lags' {
        quietly {
            reg lnEF l(1/`p').lnEF l(1/`p').lnGDP lnPAT REC BIO
            
            local k = e(df_m) + 1   // number of regressors + constant
            local n = e(N)          // number of observations
            local rss = e(rss)      // residual sum of squares
            local sigma2 = `rss' / `n'
            
            local ll = -`n'/2 * (ln(2*_pi*`sigma2') + 1)
            
            local aic = -2*`ll' + 2*`k'
            local bic = -2*`ll' + ln(`n')*`k'
            
            matrix results[`p', 1] = `p'
            matrix results[`p', 2] = `aic'
            matrix results[`p', 3] = `bic'
            matrix results[`p', 4] = `ll'
        }
        display "Lag `p': AIC = " %9.2f `aic' ", BIC = " %9.2f `bic'
    }
    
    matrix list results, format(%10.2f)
end

manual_lag_selection_EF 4

program define manual_lag_selection_GDP
    args max_lags
    
    matrix results = J(`max_lags', 4, .)
    matrix colnames results = Lag AIC BIC LogLik
    
    forvalues p = 1/`max_lags' {
        quietly {
            reg lnGDP l(1/`p').lnGDP l(1/`p').lnEF lnPAT CAP dLAB
            
            local k = e(df_m) + 1   // number of regressors + constant
            local n = e(N)          // number of observations
            local rss = e(rss)      // residual sum of squares
            local sigma2 = `rss' / `n'
            
            local ll = -`n'/2 * (ln(2*_pi*`sigma2') + 1)
            
            local aic = -2*`ll' + 2*`k'
            local bic = -2*`ll' + ln(`n')*`k'
            
            matrix results[`p', 1] = `p'
            matrix results[`p', 2] = `aic'
            matrix results[`p', 3] = `bic'
            matrix results[`p', 4] = `ll'
        }
        display "Lag `p': AIC = " %9.2f `aic' ", BIC = " %9.2f `bic'
    }
    
    matrix list results, format(%10.2f)
end

manual_lag_selection_GDP 4