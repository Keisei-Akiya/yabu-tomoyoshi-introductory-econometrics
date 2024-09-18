clear
set more off

/**************************************************************/
**　データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/monthlyint_data.csv", clear
browse

/**************************************************************/
** 月次データ
gen time = m(1991m4)+_n-1
tsset time, monthly

/**************************************************************/
**変数の定義(1兆円単位に変換する)
replace intj = intj/10000
replace intj_gaika = intj_gaika/10000
replace intj_taimin = intj_taimin/10000

/**************************************************************/
** 推定結果(外貨準備)
reg intj intj_gaika
test _b[intj_gaika]=1 
test _cons=0, accumulate


** 推定結果(対民収支)
reg intj intj_taimin
test _b[intj_taimin]=1 
test _cons=0, accumulate