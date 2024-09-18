clear
set more off

/**************************************************************/
**　データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/mwage_data.csv", clear
browse

/**************************************************************/
**　パネルデータ
xtset store time

/**************************************************************/
**　変数を定義する
gen timestate = time*state

/**************************************************************/
** 14.3.1節の推定結果
mean fulltime if(state==1 & time==0)
mean fulltime if(state==1 & time==1)
mean fulltime if(state==0 & time==0)
mean fulltime if(state==0 & time==1)

reg fulltime state time timestate, vce(cluster store)
reg fulltime time timestate i.store, vce(cluster store)

/**************************************************************/
** 練習問題の推定結果
reg fulltime state time timestate hours register, vce(cluster store)
reg fulltime time timestate hours register i.store, vce(cluster store)

