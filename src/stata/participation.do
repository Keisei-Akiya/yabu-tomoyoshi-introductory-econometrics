clear
set more off

/**************************************************************/
**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/participation_data.csv", clear
browse

/**************************************************************/
**変数の定義
gen full = job==1
gen part = job==2
gen work = full+part
gen under6 = yongest<6

/**************************************************************/
**12.6節の推定結果(50歳以下の男性に限定した分析)
reg work experience undergrad grad partner under6 children if(male==1 & age<=50), r
display e(r2_a)
probit work experience undergrad grad partner under6 children if(male==1 & age<=50), r
margins, dydx(experience undergrad grad partner under6 children)
logit work experience undergrad grad partner under6 children if(male==1 & age<=50), r
margins, dydx(experience undergrad grad partner under6 children)

/**************************************************************/
**12.6節の推定結果(50歳以下の女性に限定した分析)
reg work experience undergrad grad partner under6 children if(male==0 & age<=50), r
display e(r2_a)
probit work experience undergrad grad partner under6 children if(male==0 & age<=50), r
margins, dydx(experience undergrad grad partner under6 children)
logit work experience undergrad grad partner under6 children if(male==0 & age<=50), r
margins, dydx(experience undergrad grad partner under6 children)

