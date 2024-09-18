clear
set more off

**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/stayhome_data.csv", clear
browse

**　パネルデータ
des /*変数の属性を確認*/
encode prefecture, gen(pref) /*文字列を数値に変換する*/ 
tabulate pref, nolabel 
sum /*記述統計を調べる*/
xtset pref time /*パネルデータのiとtを定義する*/

**変数の定義
gen drain = rain>0  /*雨ダミー*/
gen linfection = ln(infection+sqrt(infection^2+1)) /*逆双曲線正弦関数*/
gen emerg = emerg_start-emerg_end /*緊急事態宣言ダミー*/
gen close = close_start-close_end /*学校閉鎖ダミー*/

** 11.4.2節の推定結果
reg stay close emerg linfection drain i.pref i.time [aw=mobilephones], cluster(pref)
display e(r2_a)

