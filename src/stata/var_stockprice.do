clear
set more off

/**************************************************************/
**　データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/var_stockprice_data.csv", clear
browse

/**************************************************************/
** 時系列データ
tsset time

/**************************************************************/
** 15.3.2節の推定結果

*ラグ次数の決定(AICとSBICをみよう)
varsoc nikkei dow, maxlag(12)

*p=4としたVARとグレンジャーの因果性検定
reg nikkei l.nikkei l2.nikkei l3.nikkei l4.nikkei l.dow l2.dow l3.dow l4.dow, r
test l.dow l2.dow l3.dow l4.dow

reg dow l.nikkei l2.nikkei l3.nikkei l4.nikkei l.dow l2.dow l3.dow l4.dow, r
test l.nikkei l2.nikkei l3.nikkei l4.nikkei

/**************************************************************/
**15.4節の推定結果
var nikkei dow, lag(1 2 3 4)
irf create order, step(10) set(myirf) replace
irf graph oirf, irf(order) impulse(nikkei dow) response(dow nikkei)

/**************************************************************/
**15章の練習問題
*p=1としたVARとグレンジャーの因果性検定
reg nikkei l.nikkei l.dow , r
test l.dow

reg dow l.nikkei l.dow, r
test l.nikkei

var nikkei dow, lag(1)
irf create order, step(10) set(myirf) replace
irf graph oirf, irf(order) impulse(nikkei dow) response(dow nikkei)
