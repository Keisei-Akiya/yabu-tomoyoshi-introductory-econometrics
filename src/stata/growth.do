clear
set more off

/**************************************************************/
**　データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/growth_data.csv", clear
browse
gen time = q(1981q1)+_n-1
tsset time, quarterly

/**************************************************************/
**　変数の定義
gen d1991 = (time>q(1991Q1))
gen d1991growth = d1991*l.growth

/**************************************************************/
**　作図
line growth time

**7.4.1節の推定結果
reg growth l.growth
reg growth l.growth d1991 d1991growth
test d1991 d1991growth

** 同じ検定はestatを用いてもできる
reg growth l.growth
estat sbknown, break(tq(1991Q2)) 
/* 
・　注意点(1) estatでは、ワルド統計量が計算される。
　　　ワルド統計量=F統計量×制約数q
　したがって、F値は
　　　ワルド統計量÷制約数q
　として計算できる。この場合、制約数qは2である。
・　注意点(2) STATAでは、構造変化日はTB+1として定義される。このため、構造変化日はtq(1991Q2)とした。
*/

** 7.4.2節の推定結果
reg growth l.growth
estat sbsingle, trim(15)
