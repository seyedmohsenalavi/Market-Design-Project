

********************************************---Importing---***************************
set more off
cd "/Users/htm/Desktop/econ/MD/project/data/raw/" 
local list : dir "/Users/htm/Desktop/econ/MD/project/data/raw/" files "*.csv"
scalar x = 1
local j = 1
foreach i of local list {

import delimited using "`i'" , delimiter(";") clear encoding(UTF-8) // stringcols(_all)
drop v1 
ren (v2 v3 v4 v5 v6 v7 v8) (ostan party kala rank bidder bid value)


 capture confirm string variable v9
     if !_rc {
				
		destring bidder,gen(tempbid) force
		replace bidder=bid if tempbid!=.
		replace bid=value if tempbid!=.
		replace value=v9 if tempbid!=.
		drop tempbid          
                }
                else {

                }
destring rank bid value , replace dpcomma ignore("",illegal) force
tostring bidder, replace force
gen gr=substr("`i'",1,3)
tempfile s`j'
save `s`j'' , replace
local j = x + 1
scalar x = x + 1

}

local j = 1
use `s`j'' , clear
forvalues j=2(1)54 {
append using `s`j'' 
}

save "/Users/htm/Desktop/econ/MD/project/data/RawData.dta" , replace
