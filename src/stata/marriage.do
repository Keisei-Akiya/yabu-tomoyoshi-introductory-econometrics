clear
set more off

/**************************************************************/
**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/marriage_data.csv", clear
browse

/**************************************************************/
**12.1.1節の推定結果(50歳以下の男性に限定した分析)
reg partner age if(male==1 & age<=50)
display _b[_cons]+_b[age]*25
display _b[_cons]+_b[age]*50

*12.1.2節の推定結果(50歳以下の男性に限定した分析)
probit partner age if(male==1 & age<=50)
display normal(_b[_cons]+_b[age]*25)
display normal(_b[_cons]+_b[age]*50)

*12.1.3節の図
probit partner age if(male==1 & age<=50)
gen p_partner = normal(_b[_cons]+_b[age]*age)
scatter p_partner age

*12.1.3節の推定結果(50歳以下の男性に限定した分析)
reg partner age undergrad grad if(male==1 & age<=50),r
display e(r2_a)
probit partner age undergrad grad if(male==1 & age<=50), r
margins, dydx(age undergrad grad)       

*12.1.3節の推定結果(50歳以下の女性に限定した分析)
reg partner age undergrad grad if(male==0 & age<=50),r
display e(r2_a)
probit partner age undergrad grad if(male==0 & age<=50), r
margins, dydx(age undergrad grad)       

*練習問題の推定結果(50歳以下の男性)
probit partner age undergrad grad if(male==1 & age<=50), r
gen p_grad = normal(_b[_cons]+_b[age]*age+_b[undergrad]*0+_b[grad]*1)
gen p_no = normal(_b[_cons]+_b[age]*age+_b[undergrad]*0+_b[grad]*0)
scatter  p_grad  p_no  age
