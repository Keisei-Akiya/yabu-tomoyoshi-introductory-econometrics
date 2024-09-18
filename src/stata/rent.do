clear
set more off

**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/rent_data.csv", clear
browse
des /*変数の属性を確認*/
sum /*基本統計量を調べる*/

**3.5節の推定結果(724物件のデータを用いた推定)
reg rent space  /*被説明変数をrent、説明変数をspaceとしたOLS推定*/

**散布図
twoway scatter rent space /*横軸をspace、縦軸をrentとした散布図*/
twoway (lfit rent space) (scatter rent space) /*散布図に回帰直線をいれる*/

*5.3.2節の推定結果
reg rent distance space  /*被説明変数をrent、説明変数をdistance、spaceとしたOLS推定*/
reg rent distance  /*被説明変数をrent、説明変数をdistanceとしたOLS推定*/
cor distance space /*distanceとspaceの標本相関係数*/

*5.6.2節の推定結果
reg rent space
reg rent space distance 
reg rent space distance age floor

*6.6節の推定結果(測定単位を変更する)
gen rent_10000 = rent*10000
reg rent space
reg rent_10000 space

*9.3節の推定結果
reg rent space
reg rent space, r  /*最後にrを入れるとロバスト標準誤差が計算される*/


