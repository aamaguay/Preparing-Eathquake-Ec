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

reg log_casas_afect log_res log_con log_escolar d_zn1 d_zn2, r 


rate_internal_migrationlog_pob_hog log_pob_hog_urb log_pob_hog_rur log_tasa_analfab log_escolar d_zn1 d_zn2 , r
c.rate_internal_migration##c.log_res
c.log_con##d_zn1, r

4 a 5