clear
set more off

/**************************************************************/
** データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/black_data.csv", clear
browse

/**************************************************************/
** 9.3節の推定結果
reg call black
reg call black, r
reg call black experience
reg call black experience, r

** 9.4.2節の推定結果
reg call black experience, r
predict p
gen h = sqrt((1-p)*p)
gen x0 = 1/h
gen call_h = call/h
gen black_h = black/h
gen experience_h = experience/h
reg call_h x0 black_h experience_h, noconstant
