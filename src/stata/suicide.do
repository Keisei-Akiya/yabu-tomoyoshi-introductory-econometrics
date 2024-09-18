clear
set more off

/**************************************************************/
**　データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/suicide_data.csv", clear
browse

/**************************************************************/
**　パネルデータ
encode country_name, gen(country)
xtset country year

/**************************************************************/
** 11.3.1節の推定
reg suicide unemployment, vce(cluster country)  /*プールド回帰、クラスターロバスト標準誤差*/
display e(r2_a)  /*自由度調整済み決定係数*/
reg suicide unemployment i.country, vce(cluster country) /*固定効果モデル*/
display e(r2_a) 

** 11.4.2節の推定
reg suicide unemployment i.country, vce(cluster country) /*固定効果モデル*/
display e(r2_a) 

/*個別効果と時間効果を考慮した固定効果モデル*/
reg suicide unemployment i.country i.year, vce(cluster country)
display e(r2_a)

