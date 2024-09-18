##はじめに------------------------------------------------------------------------------------------------------------------------
###作業ディレクトリ等については、サポートウェブサイトからダウンロードできる「同性愛者の割合」のRスクリプトを参照

#バージョンの確認（4.4.0で動作確認済）
R.version

##事前準備（使用するパッケージの呼び出し）---------------------------------------------------------------------------
packages <- c(
  "tidyverse",
  "memisc"
)

for (package in packages) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

##データの読み込み---------------------------------------------------------------------------
Dat <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/timss_data.csv",
  header = TRUE
)
head(Dat)

##データの生成---------------------------------------------------------------------------
Dat$male <- 1 - Dat$female #男性ダミーの生成

###数学の点数を偏差値に換算する
mean_math <- mean(Dat$math) #平均値
sd_math <- sd(Dat$math) #標本標準偏差
Dat$score_math <- 50 + 10 * (Dat$math - mean_math) / sd_math #偏差値

###理科の点数を偏差値に換算する
mean_science <- mean(Dat$science) #平均値
sd_science <- sd(Dat$science) #標本標準偏差
Dat$score_science <- 50 + 10 * (Dat$science - mean_science) / sd_science #偏差値

##データの属性と基本統計量の確認---------------------------------------------------------------------------

str(Dat) #データの属性を確認する
summary(Dat) #基本統計量を調べる

##4.5節の推定結果---------------------------------------------------------------------------
Out1 <- lm(
  score_math ~ female, #被説明変数をscore_math、説明変数をfemaleとしたOLS推定
  data = Dat
)
Out2 <- lm(
  score_science ~ female, #被説明変数をscore_science、説明変数をfemaleとしたOLS推定
  data = Dat
)

summary(Out1)
summary(Out2)

###参考　結果を並べて表示
mtable(Out1,Out2) #Out2とOut3の結果を並べて表示

##4章の練習問題---------------------------------------------------------------------------
Out3 <- lm(score_math~male,data=Dat)
Out4 <- lm(score_science~male,data=Dat)

summary(Out3)
summary(Out4)
###参考　結果を並べて表示
mtable(Out3,Out4)
mtable(Out1,Out2,Out3,Out4)


##5.9節の推定結果(2番目の推定では教育水準が不明のデータを除いた)---------------------------------------------------------------------------
Out5 <- lm(
  score_math ~ birth_q2 + birth_q3 + birth_q4,
  data = Dat
)
Dat2 <- subset(
  Dat,
  mother > 0 & father > 0 # mother = 0 かつ father = 0 のデータを取り除く処理
)
Out6 <- lm(
  score_math ~ birth_q2 + birth_q3 + birth_q4 + mother + father,
  data = Dat2 #取り除いたデータセットで分析
)

summary(Out5)
summary(Out6)
mtable(Out5, Out6)

##5章の練習問題：生まれ月を用いる、ただし、4月生まれダミーは除いた---------------------------------------------------------------------------

Out7 <- lm(
  score_math ~ birth_m5 + birth_m6 + birth_m7 + birth_m8 + birth_m9 + birth_m10 + birth_m11 + birth_m12 + birth_m1 + birth_m2 + birth_m3,
  data = Dat
)
Out8 <- lm(
  score_math ~ birth_m5 + birth_m6 + birth_m7 + birth_m8 + birth_m9 + birth_m10 + birth_m11 + birth_m12 + birth_m1 + birth_m2 + birth_m3
  + mother + father,
  data = Dat2
)

summary(Out7)
summary(Out8)
mtable(Out7,Out8)

##追加推定1：学校ごとの違いを考慮するために、学校ダミーをいれた推定---------------------------------------------------------------------------

Out9 <- lm(score_math~birth_q2+birth_q3+birth_q4+factor(school),data = Dat)

Dat3 <- summary(Out9) # Data3 に推定結果を格納
Result <- Dat3$coef[!grepl("factor\\(school\\)", rownames(Dat3$coef)), , drop = FALSE]
### 上のコマンドは学校ダミーの推定結果を出力しない
###  \\　の記号は、() をRで文字列として読ませるための記号

Result #学校ダミーの推定結果以外の推定結果を表示