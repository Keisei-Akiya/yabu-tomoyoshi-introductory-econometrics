clear
set more off

/**************************************************************/
**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/gay_data.csv", clear
browse

/**************************************************************/
** データの確認
des /*変数の属性を確認する*/
sum /*基本統計量を調べる*/

/**************************************************************/
** 2.4節の推定結果
reg gay support /*被説明変数をgay、説明変数をsupportとしたOLS推定をする*/
display _b[_cons]+_b[support]*100 /*support=100としたときの予測値*/

**散布図と標本相関係数
twoway scatter gay support /*横軸をsupport、縦軸をgayとした散布図を描く*/
twoway (lfit gay support) (scatter gay support)  /*散布図に回帰直線を入れる*/
cor gay support  /*標本相関係数*/