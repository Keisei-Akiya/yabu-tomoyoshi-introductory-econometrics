clear all
set more off

/**************************************************************/
**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/star_data.csv", clear
browse

/**************************************************************/
**14.2.1節の推定結果
reg total_score small regular_aid  i.school, r
display e(r2_a)
reg total_score small regular_aid total_experience i.school, r
display e(r2_a)

/**************************************************************/
**追加推定：学校が同じ生徒であれば、誤差項が相互に相関している可能性がある。学校をクラスターと考えて、
** クラスターロバスト標準誤差を用いる
reg total_score small regular_aid total_experience i.school, cluster(school)
display e(r2_a)

/**************************************************************/
**練習問題
reg total_score small regular_aid total_experience black boy freelunch i.school, r
display e(r2_a)
reg total_score small regular_aid total_experience black boy freelunch i.school, cluster(school)
display e(r2_a)



