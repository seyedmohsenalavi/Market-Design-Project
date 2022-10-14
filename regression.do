

	/*--------------------------------------------------------------------------	
			Author: Seyed Mohsen Alavi & Mohammad Mehdi Jafari
			Data: Cleaned data of (Tamliki.ir) sealed-bid first-price Auctions
			Last vesion : 1400/11/24 10 am
			
			steps of  regression:
			step  1  |	main OLS & FE regressions
			
			step  2  |	Robustness Check
				  2-1|  Regressions cross Types(Objects' categories)
				  2-2|	Quantile Regressions
	--------------------------------------------------------------------------*/
	
set more off
estimates clear

use "data/cleaned.dta" , clear

set matsize 10000
********************************************---Regression---***************************

/////Step1: main OLS & FE regressions	
	qui  eststo: reg logprice nbid logvalue , vce(robust)
	estadd local type No
	estadd local ostan No
	estadd local gr No
	estadd local bidder No
	est store r1
	
	qui  eststo: reg logprice nbid logvalue i.deostan i.gr , vce(robust)
	estadd local type No
	estadd local ostan Yes
	estadd local gr Yes
	estadd local bidder No
	est store r2

	qui  eststo: reg logprice nbid logvalue i.deostan i.gr i.type , vce(robust)
	estadd local type Yes
	estadd local ostan Yes
	estadd local gr Yes
	estadd local bidder No
	est store r3
	
	qui eststo: reg logprice nbid logvalue i.deostan i.gr i.type i.debidder , vce(robust)
	estadd local type Yes
	estadd local ostan Yes
	estadd local gr Yes
	estadd local bidder Yes
	est store r4
	
	qui eststo: qreg logprice nbid logvalue i.type i.gr i.deostan , vce(robust) q(0.5)
	estadd local type Yes
	estadd local ostan Yes
	estadd local gr Yes
	estadd local bidder No
	est store r5
	
	qui eststo: reg logprice nbid logvalue i.deostan i.gr i.type i.debidder if tot==1 , vce(robust)
	estadd local type Yes
	estadd local ostan Yes
	estadd local gr Yes
	estadd local bidder Yes
	est store r6
	
	esttab r1 r2 r3 r4 r5 r6 using "table/reg1.tex",replace compress label b(%9.3f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01)  ///
	s(gr ostan type bidder N, label("Group FE" "Ostan FE" "Type FE" "Winner FE" "N. of Obs") fmt(%9.0g)) mtitles("OLS" "FE" "FE" "FE" "Median" "Nauc=1") ///
    keep(nbid logvalue) title("OLS regression with fixed effects \label{reg1}") ///
	longtable eqlabels(none) noomitted nobaselevels varlabels(_cons "Constant" nbid "N. of bid" logvalue "Log(value)") ///
	collabels(" ",lhs("Log(WinPrice)")) booktabs ///
	addnotes("Notes: Type FE: categorical dummy var. for 12 categories of objects," "Group FE: categorical var. for categories of auctions, Ostan FE: Province FE," "Winner FE: Winning bidder's FE. Median: Quantile reg. for dep. var's Median." "Nauc=1: only non-recurring auctions have been considered.")


/////Step2-1: Regressions cross Types(Objects' categories)

	forvalues k=1/12 {
	qui  eststo: reg logprice nbid logvalue i.deostan i.gr i.debidder if type==`k' , vce(robust)
	estadd local type Yes
	estadd local ostan Yes
	estadd local gr Yes
	estadd local bidder Yes
	est store h`k'
	}
	
	esttab h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 h12 using "table/reg2.tex", replace compress label b(%9.3f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01)  ///
	s(gr ostan type bidder N, label("Group FE" "Ostan FE" "Type FE" "Winner FE" "N. of Obs") fmt(%9.0g)) mtitles("T1" "T2" "T3" "T4" "T5" "T6" "T7" "T8" "T9" "T10" "T11" "T12") ///
    keep(nbid logvalue) title("Robustness check \label{reg2}") ///
	longtable eqlabels(none) noomitted nobaselevels varlabels(_cons "Constant" nbid "N. of bid" logvalue "Log(value)") ///
	collabels(" ",lhs("Log(WinPrice)")) booktabs ///
	//addnotes("Notes: Type FE: categorical var. for 12 categories of objects," "Group FE: categorical var. for categories of auctions, Ostan FE: Province FE," "Winner FE: Winning bidder's FE,TJ means regression runs for jth category of objects;" "for example T10 means Car & T2 means Clothing")


/////Step2-2: Quantile Regressions

	qui eststo: qreg logprice nbid logvalue i.deostan i.gr i.type , vce(robust) q(0.1)
	estadd local type Yes
	estadd local ostan Yes
	estadd local gr Yes
	estadd local bidder No
	est store q1

	qui eststo: qreg logprice nbid logvalue i.deostan i.gr i.type , vce(robust) q(0.25)
	estadd local type Yes
	estadd local ostan Yes
	estadd local gr Yes
	estadd local bidder No
	est store q2
	
	qui eststo: qreg logprice nbid logvalue i.deostan i.gr i.type , vce(robust) q(0.75)
	estadd local type Yes
	estadd local ostan Yes
	estadd local gr Yes
	estadd local bidder No
	est store q3
	
	qui eststo: qreg logprice nbid logvalue i.deostan i.gr i.type , vce(robust) q(0.9)
	estadd local type Yes
	estadd local ostan Yes
	estadd local gr Yes
	estadd local bidder No
	est store q4

	esttab q1 q2 r5 q3 q4 using "table/reg3.tex",replace compress label b(%9.3f) se(%9.2f) star(* 0.1 ** 0.05 *** 0.01)  ///
	s(gr ostan type bidder N, label("Group FE" "Ostan FE" "Type FE" "Winner FE" "N. of Obs") fmt(%9.0g)) mtitles("P10" "P25" "P50" "P75" "P90") ///
    keep(nbid logvalue) title("Quantile regression with fixed effects \label{reg3}") ///
	longtable eqlabels(none) noomitted nobaselevels varlabels(_cons "Constant" nbid "N. of bid" logvalue "Log(value)") ///
	collabels(" ",lhs("Log(WinPrice)")) booktabs type ///
	addnotes("Notes: Type FE: categorical dummy var. for 12 categories of objects," "Group FE: categorical var. for categories of auctions, Ostan FE: Province FE," "Winner FE: Winning bidder's FE. P* means Percentile * for dep. var.")
