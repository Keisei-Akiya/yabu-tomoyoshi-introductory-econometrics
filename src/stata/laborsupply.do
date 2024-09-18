clear all
set more off

/**************************************************************/
**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/laborsupply_data.csv", clear
browse

/**************************************************************/
**13.6節の推定結果
reg weeks morekids, r
ivreg weeks (morekids=samesex), r first

**練習問題他のコントロール変数を含めた分析
reg weeks morekids age black hispan othrace, r
ivreg weeks (morekids=samesex) age black hispan othrace, r first
