clear
set more off

/**************************************************************/
**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/cons_data.csv", clear
browse

/**************************************************************/
** 9.4.1節の推定結果
reg cons income, r
reg cons income [aw=number]
reg cons income [aw=number], r
