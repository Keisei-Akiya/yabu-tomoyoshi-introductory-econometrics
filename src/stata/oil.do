clear
set more off

**データの読み込み
import delimited "https://www.fbc.keio.ac.jp/~tyabu/keiryo/oil_data.csv", clear
browse

**月次データ(1987M6-2017M12)
gen time = m(1987m6)+_n-1         
tsset time, monthly

**変数の定義
gen oil = brent*spot 
gen y=100*(ln(price)-ln(l.price))
gen x=100*(ln(oil)-ln(l.oil))
gen dx=x-l.x
gen d1 = (time == tm(2008m4))  /*暫定税率の影響を除くための一時的ダミー*/
gen d2 = (time == tm(2008m5))  /*暫定税率の影響を除くための一時的ダミー*/

** 6.4.1節の推定(2000年1月以降のデータを用いて推定する)
reg y x l.x l2.x d1 d2 if(time >= tm(2000m1))

** 累積効果を推定する簡単な方法(練習問題参照)
reg y dx l.dx l2.x d1 d2 if(time >= tm(2000m1))

** AICとBICを計算する(p=0,1,2の場合)
qui: reg y x d1 d2 if(time >= tm(2000m1))
estat ic
qui: reg y x l.x d1 d2  if(time >= tm(2000m1))
estat ic
qui: reg y x l.x l2.x d1 d2  if(time >= tm(2000m1))
estat ic

** 10.3.4節の推定
reg y x l1.x l2.x d1 d2 if(time >= tm(2000m1)), r
scalar T = e(N) /*サンプルサイズT*/
display T
scalar m = round(0.75*T^(1/3)) /*バンド幅m*/
display m
newey y x l1.x l2.x d1 d2 if(time >= tm(2000m1)), lag(5) /*m=5としたHAC標準誤差を用いる*/

** 図10.4
predict y_resid if(time >= tm(2000m1)), residuals
tsline y_resid if(time >= tm(2000m1))

** 10.4節の推定
prais y x l1.x l2.x d1 d2 if(time >= tm(2000m1)), corc twostep
gen rho = e(rho)
display e(rho)

**コクラン=オーカット推定は以下のOLS推定と同じ
gen y_hat = y-rho*l.y
gen x0_hat = 1-rho
gen x1_hat = x-rho*l.x
gen x2_hat = l.x-rho*l2.x
gen x3_hat = l2.x-rho*l3.x
gen d1_hat = d1-rho*l.d1
gen d2_hat = d2-rho*l.d2
reg y_hat x0_hat x1_hat x2_hat x3_hat d1_hat d2_hat if(time >= tm(2000m1)), noconstant

**追加(繰り返しコクラン=オーカット法)
prais y x l1.x l2.x d1 d2 if(time >= tm(2000m1)), corc


