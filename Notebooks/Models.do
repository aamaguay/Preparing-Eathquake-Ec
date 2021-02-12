clear all
set more off
import excel "C:\Users\User\Desktop\Earthquake EC\Data\data_set_new_cantons.xlsx", sheet("Sheet1") firstrow

tab zona, gen(d_zn)

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

gen sect_numb= 1 if zona == "Norte"
replace sect_numb= 2 if zona == "Centro"
replace sect_numb= 3 if zona == "Sur"

eststo: reg log_casas_afect i.sect_numb , r 
eststo: reg log_casas_afect  log_res log_con i.sect_numb , r 
eststo: reg log_casas_afect log_res log_con distance i.sect_numb , r
eststo: reg log_casas_afect log_res log_con distance NúmerodeSitiosdeCobertura i.sect_numb , r
eststo: reg log_casas_afect log_res log_con distance NúmerodeSitiosdeCobertura internal_migartion i.sect_numb, r
eststo: reg log_casas_afect log_res log_con distance NúmerodeSitiosdeCobertura internal_migartion log_pob_hog i.sect_numb, r 
esttab, r2 ar2 se

//esttab using "C:\Users\User\Desktop\Earthquake EC\Data\first_result.doc" , r2 ar2 p

**eststo clear

**** Models includings interactions *****
eststo: reg log_casas_afect i.sect_numb c.distance##sect_numb c.log_res##sect_numb c.log_con##sect_numb c.internal_migartion##sect_numb, r 

eststo: reg log_casas_afect i.sect_numb c.log_res##sect_numb log_con c.distance##sect_numb NúmerodeSitiosdeCobertura c.internal_migartion##sect_numb log_pob_hog, r

esttab, r2 ar2 se

outreg2 [*]  using "C:\Users\User\Desktop\Earthquake EC\Data\result.doc", append title("Tabla de Resultados") addstat(Adjusted R-squared, e(r2_a))
