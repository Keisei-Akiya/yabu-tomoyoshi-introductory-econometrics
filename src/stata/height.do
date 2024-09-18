clear
set more off

**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/height_data.csv", clear
browse

** データの定義と確認
gen parent = (father+1.08*mother)/2 /*両親の平均身長、男性換算するため、母親の身長を1.08倍する*/
gen height = 1.08*student*female+student*(1-female) /*女性なら1.08倍する*/
des /*変数の属性を確認*/
sum /*基本統計量を調べる*/

**2.6節と4.2.2節の推定結果
reg height parent /*被説明変数をheight、説明変数をparentとしたOLS推定をする*/
display _b[_cons]+_b[parent]*190
display _b[_cons]+_b[parent]*150
display _b[_cons]+_b[parent]*(180+1.08*158)/2

**散布図と回帰直線を描く
twoway (lfit height parent) (scatter height parent)

**5.3.2節の推定結果
gen mother2 = 1.08*mother  /*母親の身長を男性換算したのがmother2*/
reg height father mother2 /*被説明変数をheight、説明変数をfather、mother2としたOLS推定をする*/
reg height father /*被説明変数をheight、説明変数をfatherとしたOLS推定をする*/

**父親と母親の身長の散布図と標本相関係数
twoway scatter mother father
cor mother father


