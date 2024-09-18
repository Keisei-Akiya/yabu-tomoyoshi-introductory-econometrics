clear all
set more off

/**************************************************************/
**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/protection_data.csv", clear
browse

/**************************************************************/
**13.6節の推定結果
reg gdp protection, r
ivreg gdp (protection=mortality), r first

**13.7節の推定結果
ivreg gdp (protection=mortality europop) latitude, r first
reg protection mortality europop latitude
test mortality europop

/**************************************************************/
**過剰識別検定
ssc install overid
qui: ivreg gdp (protection=mortality europop) latitude
overid9

/*13.7.3節の過剰識別性検定を行う。p値が10%を上回れば、帰無仮説が採択され(操作変数の外生性が満たされる)、
p値が10%を下回れば、帰無仮説が棄却される(操作変数の外生性が満たされない)。*/
