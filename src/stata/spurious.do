clear all
set more off

/**************************************************************/
**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/spurious_data.csv", clear
browse

/**************************************************************/
**時系列データと
tsset time

/**************************************************************/
**変数の定義
gen dy = y-l.y
gen dx = x-l.x

/**************************************************************/
**16.1節の分析
*図16.1
twoway (line y x time), xtitle("年") ytitle("水準")

*見せかけの回帰
reg y x

*トレンド変数を追加する
reg y x time

*階差の分析
twoway (line dy dx time), xtitle("年") ytitle("階差")
reg dy dx