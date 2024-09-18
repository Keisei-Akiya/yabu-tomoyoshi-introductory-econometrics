clear
set more off

**　データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/money_data.csv", clear
browse

** 四半期データ(1980Q1-2013Q4)
gen time = q(1980q1)+_n-1 /*データの開始時点は1980年第1四半期*/
tsset time, quarterly /*tは、四半期quarterly*/

**　変数の定義
gen lnm = ln(m1/ngdp)
gen lnr = ln(interest)

des /*変数の属性*/
sum /*変数の基本統計量*/

*　6.3.2節の推定
reg lnm lnr /*対数対数モデル*/
reg lnm interest /*対数線形モデル*/
