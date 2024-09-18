clear
set more off

/**************************************************************/
**　データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/stockprice_data.csv", clear
browse
tsset time

/**************************************************************/
**　7.3.3節の推定
reg ds ds_1 ds_2 ds_3 s_ma