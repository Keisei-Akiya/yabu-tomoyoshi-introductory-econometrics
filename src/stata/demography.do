clear all
set more off

**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/demography_data.csv", clear
browse

des /*変数の属性を確認*/
egen region_code=group(region)  /*regionが文字列(string)なので、これを数値に変換する*/
tabulate region_code, nolabel /*region_codeは1から7までの数値であることを確認する*/

gen gdp2015=ln(rgdp2015/pop2015)  /*2015年の1人当たりGDPの対数*/
gen gdp1990=ln(rgdp1990/pop1990)  /*1990年の1人当たりGDPの対数*/
gen dgdp = gdp2015-gdp1990  /*1990年から2015年にかけてのGDP変化率*/
gen ddepend = depend2015-depend1990  /*高齢者割合の変化*/
gen lpop1990=ln(pop1990)

sum  /*変数の基本統計量*/ 

** 説明変数に人口比を用いた推定
reg dgdp ddepend
reg dgdp ddepend gdp1990  /*コントロール変数として、1990年のGDPを追加*/
reg dgdp ddepend gdp1990 lpop1990 depend1990 i.region_code  /*1990年の人口、高齢者割合、地域ダミーを追加*/

** 練習問題、説明変数に平均年齢を用いた推定
gen ddepend2=depend2015_ave-depend1990_ave
reg dgdp ddepend2
reg dgdp ddepend2 gdp1990 lpop1990 depend1990_ave i.region_code

