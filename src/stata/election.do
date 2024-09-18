clear
set more off

/**************************************************************/
**パッケージをインストールしていないなら、
net install rdrobust, from(https://raw.githubusercontent.com/rdpackages/rdrobust/master/stata) replace
net install rddensity, from(https://raw.githubusercontent.com/rdpackages/rddensity/master/stata) replace
net install rdlocrand, from(https://raw.githubusercontent.com/rdpackages/rdlocrand/master/stata) replace
net install lpdensity, from(https://raw.githubusercontent.com/nppackages/lpdensity/master/stata) replace

/**************************************************************/
**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/election_data.csv", clear
browse

/**************************************************************/
**変数の定義
gen W = diff_share
gen X = W>=0
gen Y = myoutcomenext

/**************************************************************/
**14.5節の推定結果
rdplot Y W if W>=-0.2 & W<=0.2, nbins(20 20) c(0) p(3) graph_options(xtitle("t期の得票率差")  ytitle("t+1期の当選確率"))

gen W2 = W^2
gen W3 = W^3
gen WX = W*X
gen WX2 = W2*X
gen WX3 = W3*X
reg Y X W W2 W3 WX WX2 WX3 if(W>=-0.2 & W<=0.2), r

/**************************************************************/
**練習問題
reg Y X W WX if(W>=-0.15 & W<=0.15), r

/**************************************************************/
**バンド幅と乗数を最適に選択するコマンド
rdrobust Y W, kernel(triangular) c(0) 
