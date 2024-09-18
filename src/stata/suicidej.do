clear
set more off

/**************************************************************/
**　データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/suicidej_data.csv", clear
browse

/**************************************************************/
**　パネルデータ
encode prefecture, gen(pref)
xtset pref year

/**************************************************************/
**　11.4.2節の推定結果
reg suicide unemployment i.pref, vce(cluster pref)
display e(r2_a)
reg suicide unemployment i.pref i.year, vce(cluster pref)
display e(r2_a)


