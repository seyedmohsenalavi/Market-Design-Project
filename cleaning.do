

********************************************---Cleaning---***************************
set more off

use "data/RawData.dta" ,clear

format bid value %20.0g

keep ostan-gr
destring gr, replace force
egen id = group(kala value)
egen auc = group(id ostan party)
order auc id , first
drop if bid==0 | bid==. | value==. | value==0
drop rank
sort id auc party bid 
egen rank=rank(-bid) , by(auc)
replace rank=1 if rank==1.5

duplicates drop bidder auc id , force
bys auc : g nbid = rank[1]
g winprice = bid if rank == 1
preserve
bys id : drop if party[_n] == party[_n-1]
g nauc = 1
replace nauc = nauc[_n-1] + 1 if id[_n]==id[_n-1] & party[_n]!=party[_n-1] & nauc[_n-1]!=.
tempfile temp
save `temp' , replace
restore
merge m:1 auc using `temp' ,  nogen
bys auc : egen nauc2 = max(nauc)
drop nauc
ren nauc2 Nauc
order Nauc , before(id)
bys id : egen tot = max(Nauc)
sort gr id auc party bid 

	foreach var of varlist kala {
	replace `var' = strrtrim(`var')
	replace `var' = ustrrtrim(`var')
	replace `var' = ustrregexra(`var',"ي", "ی")
	replace `var' = ustrregexra(`var',"ئ", "ی")
	replace `var' = ustrregexra(`var',"ك", "ک")
	replace `var' = ustrregexra(`var',"آ", "ا")
	replace `var' = ustrregexra(`var',"أ", "ا")
	}

	
gen type=.

replace type=1 if strpos(kala,"برنج")>0 | strpos(kala,"آرد")>0 | ///
 strpos(kala,"شیر")>0 | strpos(kala,"گندم")>0 | strpos(kala,"هل سبز")>0 | strpos(kala,"چای")>0

replace type=6 if strpos(kala,"تلویزیون")>0 | strpos(kala,"یخچال")>0 ///
 | strpos(kala,"لوازم خانگی")>0 | strpos(kala,"چرخ خیاطی")>0 ///
 | strpos(kala," کولرگازی")>0 | strpos(kala,"ظروف")>0 | ///
 strpos(kala,"کولر گازی")>0 | strpos(kala,"چمدان")>0 | ///
 strpos(kala,"لوازم برقی خانگی")>0 | strpos(kala,"لوازم تزیینی و دکوری")>0 | ///
 strpos(kala,"کولر")>0 | strpos(kala,"ماشین لباس شویی")>0 | strpos(kala,"ابمیوه گیری")>0 ///
 | strpos(kala,"اتوی بخار")>0 | strpos(kala,"جاروبرقی")>0 | strpos(kala,"جارو برقی")>0 | ///
 strpos(kala,"لباسشویی")>0 |  strpos(kala," زودپز")>0 | strpos(kala,"اسکاچ")>0 | strpos(kala,"مخلوط کن")>0 | ///
 strpos(kala,"ارام پز")>0 | strpos(kala,"استکان")>0 | strpos(kala,"بلور")>0 | strpos(kala,"کالای خانگی")>0 ///
 | strpos(kala,"میز")>0 | strpos(kala,"چاقو")>0 | strpos(kala,"کاسه")>0 | ///
 strpos(kala,"کالای تزیینی")>0 | strpos(kala,"ظروف")>0 | strpos(kala,"لیوان")>0 
 
replace type=7 if strpos(kala,"گوشی همراه")>0 | strpos(kala,"تلفن همراه")>0 ///
 | strpos(kala,"گوشی تلفن همراه")>0 | strpos(kala,"انواع تلفن")>0 |  strpos(kala,"موبایل")>0

replace type=7 if strpos(kala,"لوازم جانبی و قطعات الکتریکی و الکترونیکی ")>0 | strpos(kala,"فلش مموری")>0
replace type=7 if strpos(kala,"مانیتور")>0 | strpos(kala,"لوازم الکتریکی")>0 
replace type=7 if strpos(kala,"لپ تاپ")>0 | strpos(kala,"هارد ")>0 | ///
 strpos(kala,"لوازم برقی")>0 | strpos(kala,"لپ تاب")>0 | strpos(kala,"تبلت")>0 | ///
 strpos(kala,"اسپیکر")>0 | strpos(kala,"انتن مودم")>0 | strpos(kala,"کارت گرافیکی")>0 | strpos(kala,"کالای الکترونیکی")>0 ///
 | strpos(kala,"پاور بانک")>0 | strpos(kala,"کالای صوتی")>0  | strpos(kala,"چراغ قوه")>0 | ///
 strpos(kala,"لامپ")>0

replace type=2 if strpos(kala,"پوشاک")>0 | strpos(kala,"پوتین")>0 |  strpos(kala,"کیف")>0 ///
 | strpos(kala,"کفش")>0 | strpos(kala,"پارچه")>0 | strpos(kala,"البسه")>0  ///
 | strpos(kala,"پتو")>0 | strpos(kala,"کاپشن")>0 | strpos(kala,"ساپورت")>0 ///
 | strpos(kala,"عینک آفتابی")>0 | strpos(kala,"منسوج نبافته")>0 | ///
strpos(kala,"عینک افتابی")>0 | strpos(kala,"لباس زیر زنانه")>0 | strpos(kala,"منسوجات")>0 | ///
strpos(kala,"لباس زیر")>0 | strpos(kala,"روسری")>0 | strpos(kala,"حوله")>0 | ///
strpos(kala,"تیشرت")>0 | strpos(kala,"سیسمونی")>0 | strpos(kala,"پارجه")>0

replace type=9 if strpos(kala,"خودروی سواری")>0 | strpos(kala,"پژو 405 و 206")>0 ///
 | strpos(kala,"پژو 405")>0 | strpos(kala,"سمند")>0 | strpos(kala,"خودرو سواری")>0 | strpos(kala,"سواری سایپا")>0 | ///
 strpos(kala,"سواری سمندایکس")>0 | strpos(kala,"تویوتا")>0 |  strpos(kala,"خودروی")>0 | strpos(kala,"سواری پژو")>0 | ///
 strpos(kala,"سواری ال 90")>0 | strpos(kala,"خودرو سواري")>0 | ///
 strpos(kala,"سواری پراید")>0 | strpos(kala,"سواری پیکان")>0 | strpos(kala,"سواری چری")>0 | ///
 strpos(kala,"خودرو وانت")>0 | strpos(kala,"خودرو پیکان")>0 | strpos(kala,"پژو پرشیا")>0 | ///
 strpos(kala,"شماره انتظامی")>0 | strpos(kala,"پژو پارس")>0 | strpos(kala,"وانت نیسان")>0
 
replace type=5 if strpos(kala,"اسباب بازی")>0 | strpos(kala,"اسباب ازی")>0 | strpos(kala,"ورزشی")>0

replace type=11 if strpos(kala,"لوازم خودرو")>0 | strpos(kala,"روغن موتور")>0 ///
 | strpos(kala,"انواع لوازم یدکی")>0 | strpos(kala,"انواع چرخ دنده")>0 ///
 | strpos(kala,"انوع باک خودرو")>0 | strpos(kala,"باطری خودرو")>0 | strpos(kala,"باک")>0 ///
 | strpos(kala,"فندک")>0 | strpos(kala,"لاستیک")>0 |  strpos(kala,"جرم گیر")>0 | ///
 strpos(kala,"لنت ترمز")>0 | strpos(kala,"رادیو پخش خودرو")>0 | strpos(kala,"اسپری خودرو")>0 | ///
 strpos(kala,"استارت خودرو")>0 | strpos(kala,"باطری")>0 ///
 | strpos(kala,"روغن خودرو")>0 | strpos(kala,"ضبط خودرو")>0 | strpos(kala,"پخش خودرو")>0

replace type=4 if strpos(kala,"سکه طلا")>0 | strpos(kala,"سکه نقره")>0 ///
 |  strpos(kala,"انواع طلا")>0 | strpos(kala,"مصنوعات طلا")>0 | strpos(kala,"شمش طلا")>0 ///
 | strpos(kala,"طلای ساخته شده")>0 | strpos(kala,"زیورالات طلا")>0 | strpos(kala,"نگین")>0 ///
 | strpos(kala,"انگشتر")>0 | strpos(kala,"گوشواره")>0 | strpos(kala,"کمربند طلا")>0 | ///
 strpos(kala,"طلا و جواهرات")>0 | strpos(kala,"طلای ذوب شده")>0 | strpos(kala,"طلا (")>0

 replace type=8 if strpos(kala,"درب")>0| strpos(kala,"شاخه لوله")>0 ///
 | strpos(kala,"سقف کاذب")>0 | strpos(kala,"سنگ ساختمانی")>0 | ///
 strpos(kala,"لوله پلی اتیلن")>0 | strpos(kala,"کاغذ دیواری")>0

 replace type=12 if  strpos(kala,"تانکی")>0 | strpos(kala,"لنج")>0 | strpos(kala,"لیفتراک")>0 | ///
  strpos(kala,"کامیون")>0 | strpos(kala,"مینی بیل")>0 | strpos(kala,"لودر")>0 ///
  | strpos(kala,"تریلر")>0 | strpos(kala,"میکسر")>0 | strpos(kala,"وساِیط نقلیه و ابزار صنعتی")>0

  replace type=3 if strpos(kala,"لوازم ارایشی و بهداشتی")>0 | ///
  strpos(kala,"انواع ادکلن")>0 | strpos(kala,"انواع لوازم برقی آرایشی")>0 | ///
   strpos(kala,"لوازم ارایشگاهی")>0 | strpos(kala,"کالای ارایشی")>0 | strpos(kala,"دستمال")>0 | ///
  strpos(kala,"اسپری خوشبوکننده")>0 | strpos(kala,"ارایشی بهداشتی")>0 | strpos(kala,"شامپو")>0 | ///
  strpos(kala,"سشوار")>0 | strpos(kala,"ژیلت")>0 | strpos(kala,"تیغ اصلاح")>0


  replace type=10 if strpos(kala,"دوچرخه")>0 | strpos(kala,"اسکوتر")>0 | strpos(kala,"موتور سیکلت")>0 | strpos(kala,"موتورسیکلت")>0
 
   replace type=13 if strpos(kala,"متفرقه")>0       | type==.

   label define type 1 "Food" 2 "Clothing" 3 "cosmetics" 4 "Jewelry" 5 "Toy" ///
   6 "House Appliance" 7 "Electrical appliance" 8 "building equipment"  ///
   9 "Car" 10 "Bike" 11 "Car accessories" 12 "Heavy vehicles" 13 "others"
	label values type type
	
	replace winprice=winprice/10000
	replace value=value/10000
	
	unique auc
	duplicates drop auc rank, force
	unique auc
	drop if type==13
	unique auc
	drop if winprice==.
	unique auc
	winsor2 winprice value , cuts(5 95) trim by(type)
	drop if winprice_tr==. | value_tr==.
	unique auc
	drop winprice_tr value_tr
	
	encode ostan, gen(deostan) label(deostan)
	label define deostan1 1 "Azar. sharghi" 2 "Azar. Qarbi" 3 "Ardebil" 4 "Esfahan" ///
	 7 "Booshehr" 8 "Tehran" 6 "Ilam" 21 "Kohkilooye" ///
	 10 "Khorasan Raz." 11 "Khozestan" 12 "Zanjan" ///
	 14 "Sistan" 15 "Fars"  30 "Gilan" ///
	 18 "Kordestan" 19 "Kerman" 20 "Kermanshah" ///
	 22 "Lorestan" 23 "Mazandaran" 24 "Markazi" ///
	25 "Hormozgan" 26 "Hamedan" 27 "Yazd"  ///
	16 "Qazvin" 17 "Qom" 13 "Semnan" 9 "Khorasan j." ///
	 5 "Alborz"  28 "Charmahal" 29 "Golestan"
	label values deostan deostan1
	
	encode bidder, gen(debidder)
	gen logprice=log(winprice)
	gen logvalue=log(value)
	
save "data/cleaned.dta" , replace
