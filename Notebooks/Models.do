clear all
set more off
import excel "C:\Users\User\Desktop\Earthquake EC\Data\data_set_new_cantons.xlsx", sheet("Sheet1") firstrow

tab zona , gen(d_zn)
tab quartile, gen(d_qt)
/**
	first -qt1
	second - qt3
	third - qt4
	fourth - qt2

	norte -z2
	centro - z1
	sur - z3
**/

** new scale **
gen internal_migartion_miles= (internal_migartion)/1000
gen poblacion2016_miles= (poblacion2016)/1000
gen pib_miles= (pib)/1000

** log transformations **
gen log_res = log(Median_res)
gen log_con = log(Median_con)
gen log_pob_hog = log(Poberty_hogar_total)
gen log_pob_hog_urb= log(Poberty_hogar_urbano)
gen log_pob_hog_rur= log(Poberty_hogar_rural)
gen log_tasa_analfab = log(illiteracy_rate)
gen log_escolar = log(escolaridad)
gen log_casas_afect = log(Nrocasasafectadas)
gen log_centros_salud= log(NúmerodeCentrosdeSalud)
gen log_cobert = log(NúmerodeSitiosdeCobertura)
gen log_distance = log(distance)
gen log_pob= log(poblacion2016_miles)
gen log_pib = log(pib_miles)
gen porc_mig= abs(internal_migartion/poblacion2016)


gen sect_numb= 1 if zona == "Norte"
replace sect_numb= 2 if zona == "Centro"
replace sect_numb= 3 if zona == "Sur"

gen pib_quartile = 1 if quartile == "first quartile"
replace pib_quartile= 2 if quartile == "second quartile "
replace pib_quartile= 3 if quartile == "third quartile"
replace pib_quartile= 4 if quartile == "more third quartile"


eststo: reg log_casas_afect i.sect_numb , r 
eststo: reg log_casas_afect i.sect_numb i.quartile, r 
eststo: reg log_casas_afect  log_res log_con i.sect_numb , r 
eststo: reg log_casas_afect log_res log_con distance i.sect_numb , r
eststo: reg log_casas_afect log_res log_con distance NúmerodeSitiosdeCobertura i.sect_numb , r
eststo: reg log_casas_afect log_res log_con distance NúmerodeSitiosdeCobertura internal_migartion_miles i.sect_numb, r
eststo: reg log_casas_afect log_res log_con distance NúmerodeSitiosdeCobertura internal_migartion_miles log_pob_hog i.sect_numb, r 
eststo: reg log_casas_afect log_res log_con distance NúmerodeSitiosdeCobertura internal_migartion_miles log_pob_hog i.sect_numb log_pob, r
eststo: reg log_casas_afect log_res log_con distance NúmerodeSitiosdeCobertura internal_migartion_miles log_pob_hog i.sect_numb log_pob log_pib, r

esttab, r2 ar2 se


//esttab using "C:\Users\User\Desktop\Earthquake EC\Data\first_result.doc" , r2 ar2 p

**
eststo clear

**** Models includings interactions *****
eststo: reg log_casas_afect i.sect_numb c.distance##sect_numb c.log_res##sect_numb c.log_con##sect_numb c.porc_mig##sect_numb, r 

eststo: reg log_casas_afect i.sect_numb c.log_res##sect_numb log_con c.distance##sect_numb NúmerodeSitiosdeCobertura c.porc_mig##sect_numb log_pob_hog, r

eststo: reg log_casas_afect i.sect_numb c.log_res##sect_numb log_con c.distance##sect_numb NúmerodeSitiosdeCobertura c.porc_mig##sect_numb log_pob_hog log_pob, r

esttab, r2 ar2 se

outreg2 [*]  using "C:\Users\User\Desktop\Earthquake EC\Data\result.doc", append title("Tabla de Resultados") addstat(Adjusted R-squared, e(r2_a))
