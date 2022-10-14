

	/*--------------------------------------------------------------------------	
			Author: Seyed Mohsen Alavi & Mohammad Mehdi Jafari
			Data: Cleaned data of (Tamliki.ir) sealed-bid first-price Auctions
			Last vesion : 1400/11/24 10 am
			
			steps of Descriptive analysis:
			
			step  1  |	Generate Tables
				  1-1|	Table1: N. of Actions cross Types
				  1-2|	Table2: Summary stats for WinPrice & Value
				  1-3|	Table3: N. of Actions cross provinces
				  1-4|	Table4: N. of Actions' repetition cross Types
				  1-5|	Table5: N. of Winner
			
			step  2  |	Generate Figures
				  2-1|	Fig1: Bar-plot: Mean of WinPrice & Value cross Types
				  2-2|	Fig2: Scatter-plot: WinPrice over Value
				  2-3|	Fig3: Histogram N. of bids cross auctions
			      2-4|	Fig4: Scatter-plot: WinPrice over N. of bids
	--------------------------------------------------------------------------*/
	
set more off
********************************************---Description---***************************
use "data/cleaned.dta" , clear

tempfile temp1
save `temp1', replace

//////////////////STEP1: TABLES


//table1: N. of Actions cross Types

	qui estpost tabulate type , sort //, nototal 
	esttab using "table/table1.tex", nomtitle ///
	cells("b(label(N) fmt(%9.0fc)) pct(fmt(%9.2f)) cumpct(fmt(%9.2f))") replace unstack nonumber label

//table2: Summary stats for WinPrice & Value

	qui estpost tabstat winprice value , statistics(mean median sd min max) columns(statistics) listwise
	esttab using "table/table2.tex", cells("mean(fmt(%9.0fc)) p50(fmt(%9.0fc) label(median)) sd(fmt(%9.0fc)) min(fmt(%9.0fc)) max(fmt(%9.0fc))") ///
	replace unstack nonumber nomtitle
	
//table3: N. of Actions cross provinces

	qui estpost tabulate deostan , nototal sort
	esttab using "table/table3.tex", nomtitle unstack nonumber label compress booktabs ///
	cells("b(label(N) fmt(%9.0g)) pct(fmt(%9.2f)) cumpct(fmt(%9.2f))") replace ///
	varlabels(1 "Azar. sharghi" 2 "Azar. Qarbi" 3 "Ardebil" 4 "Esfahan" ///
	 7 "Booshehr" 8 "Tehran" 6 "Ilam" 21 "Kohkilooye" ///
	 10 "Khorasan Raz." 11 "Khozestan" 12 "Zanjan" ///
	 14 "Sistan" 15 "Fars"  30 "Gilan" ///
	 18 "Kordestan" 19 "Kerman" 20 "Kermanshah" ///
	 22 "Lorestan" 23 "Mazandaran" 24 "Markazi" ///
	25 "Hormozgan" 26 "Hamedan" 27 "Yazd"  ///
	16 "Qazvin" 17 "Qom" 13 "Semnan" 9 "Khorasan j." ///
	 5 "Alborz"  28 "Charmahal" 29 "Golestan")  
	
//table4: N. of Actions' repetition cross Types

	qui estpost tabstat nbid , statistics(mean) columns(statistics)  by(type)
	esttab using "table/table4.tex", noobs type cells("mean(fmt(%9.2fc))") ///
	replace unstack nonumber nomtitle
	
//table5: N. of Winner

	gen nwin=1
	collapse (sum) nwin, by(debidder)
	qui estpost sum nwin, detail
	esttab using "table/table5.tex", type cells("mean(fmt(%9.2fc)) p50(fmt(%9.0fc) label(median)) sd(fmt(%9.2fc)) min(fmt(%9.0fc)) max(fmt(%9.0fc))")   ///
	replace unstack nomtitle nonumber varlabels(nwin "N. of wins")  //  noobs cells("mean(fmt(%9.2fc))") 
	use `temp1', clear
//////////////////STEP2: FIGURES
	
	grstyle init
	grstyle anglestyle vertical_tick horizontal

//Fig1: Bar-plot: Mean of WinPrice & Value cross Types

	replace winprice=winprice/1000
	replace value=value/1000
	qui graph hbar winprice value , over(type, sort(1) descending) label ///
	ytitle("Avg. of winning price(mToman)") name(g1,replace) legend(order(1 "Winning price" 2 "Value"))
	graph export "pic/fig1.png", replace

//Fig2: Scatter-plot: WinPrice over Value

	qui reg winprice value
	local r2: display %5.2f e(r2)
	qui graph twoway (scatter winprice value, msymbol(x)) (lfit winprice value) (line value value, color(red)), note(R-squared=`r2')  ///
	legend(order(1 "Winning price over value" 2 "Linear fitted line" 3 "45°line")) name(g2,replace) ytitle("Price (Million Toman)") xtitle("Value (Million Toman)") ///
	xscale(titlegap(2) noextend) yscale(titlegap(2))  aspectratio(1) //xlabel(0(2000)8000) ylabel(0(2000)8000)  
	graph export "pic/fig2.png", replace
	
//Fig3: Histogram: N. of bids cross auctions

	qui hist nbid, freq  discrete name(g3,replace) xtitle("N. of bids cross auctions")  color(olive)
	graph export "pic/fig3.png", replace

//Fig4: Scatter-plot: WinPrice over N. of bids

	qui reg winprice nbid
	local r2: display %5.2f e(r2)
	qui graph twoway (scatter winprice nbid, msymbol(x)) (lfit winprice nbid), note(R-squared=`r2')  ///
	legend(order(1 "Winning price over N. of bids" 2 "Linear fitted line")) name(g4,replace) ytitle("Price(Million Toman)") ///
	xscale(titlegap(2) noextend) yscale(titlegap(2)) //xlabel(0(2000)8000) ylabel(0(2000)8000)  aspectratio(1) 
	graph export "pic/fig4.png", replace
	replace winprice=winprice*1000
