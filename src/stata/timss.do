clear
set more off

**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/timss_data.csv", clear
browse

gen male = 1-female /*男性ダミー*/

**数学の点数を偏差値に換算する
egen mean_math = mean(math) /*平均点*/
egen sd_math = sd(math) /*標本標準偏差*/
gen score_math = 50+10*(math-mean_math)/sd_math /*偏差値*/

**理科の点数を偏差値に換算する
egen mean_science = mean(science)
egen sd_science = sd(science)
gen score_science = 50+10*(science-mean_science)/sd_science

**データの属性と基本統計量の確認
des /*変数の属性を確認*/
sum /*基本統計量を調べる*/

**4.5節の推定結果
reg score_math female /*被説明変数をscore_math、説明変数をfemaleとしたOLS推定*/
reg score_science female /*被説明変数をscore_science、説明変数をfemaleとしたOLS推定*/

**4章の練習問題
reg score_math male
reg score_science male

**5.9節の推定結果(2番目の推定では教育水準が不明のデータを除いた)
reg score_math birth_q2 birth_q3 birth_q4
reg score_math birth_q2 birth_q3 birth_q4 mother father if(mother>0)&(father>0)

**5章の練習問題：生まれ月を用いる、ただし、4月生まれダミーは除いた
reg score_math birth_m5 birth_m6 birth_m7 birth_m8 birth_m9 birth_m10 birth_m11 birth_m12 birth_m1 birth_m2 birth_m3
reg score_math birth_m5 birth_m6 birth_m7 birth_m8 birth_m9 birth_m10 birth_m11 birth_m12 birth_m1 birth_m2 birth_m3 mother father if(mother>0)&(father>0)

**追加推定1：学校ごとの違いを考慮するために、学校ダミーをいれた推定
reg score_math birth_q2 birth_q3 birth_q4 i.school




