cd "D:\Kerjaan\Research Consultant\Project Cleaning 5 Million Data in STATA\Susenas Papua KOR dan KP"

*** Langkah 1: Import dan Simpan Sementara Data Susenas
* Import 
import dbase using "SSN2403_94_Kor.dbf", clear
save "temp\data_kor.dta", replace

import dbase using "SSN2403_94_KP.dbf", clear
save "temp\data_kp.dta", replace

*** Langkah 2: Gabungkan Data KOR dan KP
use "temp\data_kor.dta", clear
merge m:m urut r102 using "temp\data_kp.dta"
drop _merge

* Simpan data gabungan
save "output\susenas_full.dta", replace

* Buat variabel persentase ketahanan pangan
gen persentase_ketahanan = (food / expend) * 100
gen kecukupan_energi = kalori_kap/2100*100

* Buat variabel Pengeluaran Konsumsi (Y)
gen Y = 0
replace Y = 1 if persentase_ketahanan < 60 & kecukupan_energi >=80

* Variabel-variabel X sesuai nama yang kamu pakai
gen X1 = r2207   
gen X2 = r407    
gen X3 = r706    
gen X4 = r405    
gen X5 = r301    
gen X6 = r105    

label variable X1 "Partisipasi BPNT"
label variable X2 "Usia Kepala Rumah Tangga"
label variable X3 "Jenis Pekerjaan Kepala Rumah Tangga"
label variable X4 "Jenis Kelamin Kepala Rumah Tangga"
label variable X5 "Jumlah Anggota Keluarga"
label variable X6 "Lokasi Tempat Tinggal"
label variable Y "Pengeluaran Konsumsi (Y)"

* Simpan data final
save "output\susenas_clean.dta", replace

keep Y X1 X2 X3 X4 X5 X6
drop if missing(X3)
save "output\dataset_clean.dta", replace
