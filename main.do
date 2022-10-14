

	/*--------------------------------------------------------------------------	
			Author: Seyed Mohsen Alavi & Mohammad Mehdi Jafari
			Data: Cleaned data of (Tamliki.ir) sealed-bid first-price Auctions
			Last vesion : 1400/11/24 10 am
			
			steps:
			
			step  1  |	Importing data
			step  2  | 	Cleaning  data
			step  3  | 	Descriptive analysis
			step  4  |	Regression
	--------------------------------------------------------------------------*/
	

set more off
clear 

cd "/Users/htm/Desktop/econ/MD/project/" 

do "code/stata/importing.do"

cd "/Users/htm/Desktop/econ/MD/project/" 

do "code/stata/cleaning.do"

do "code/stata/descriptive.do"

do "code/stata/regression.do"



