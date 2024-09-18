clear
set more off

/**************************************************************/
**　データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/spread_data.csv", clear
browse

/**************************************************************/
** 四半期データ
gen time = q(1980q1)+_n-1
tsset time, quarterly

/**************************************************************/
** 変数の定義
gen spread = r_long-r_short
gen dspread = spread-l.spread

/**************************************************************/
**　15.2.2節の推定
*図15.3(a)(b)
twoway (line r_long r_short time), xtitle("年") ytitle("%")
twoway (line spread time), xtitle("年") ytitle("%")

reg spread l.spread

/**************************************************************/
**　16.2.4節
reg dspread l.spread

*同じ推定はdfullerコマンドを使ってできる。ラグ次数を増やしたいなら、lagsの中の数値を変える。0はAR(1)と同じ。
dfuller spread, lags(0)
dfuller spread, lags(0) trend /*トレンドを入れたケース*/

*ADF検定でラグを選択したいなら、以下のコマンドでAICやBICを計算できる。
varsoc spread

*GLS-DF検定は以下とする。ラグ次数の最大は10までとした(最初がトレンドなし、次がトレンドあり)。
dfgls spread, notrend maxlag(10)
dfgls spread, maxlag(10)   

/**************************************************************/
**練習問題
*短期金利と長期金利にはトレンドがあるので、ケース3を考える。DF-GLS検定は以下となる。
dfgls r_long, maxlag(10)   
dfgls r_short, maxlag(10)   


               
