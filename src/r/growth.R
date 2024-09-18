##はじめに------------------------------------------------------------------------------------------------------------------------
###作業ディレクトリ等については、サポートウェブサイトからダウンロードできる「同性愛者の割合」のRスクリプトを参照

#バージョンの確認（4.4.0で動作確認済）
R.version

##事前準備（使用するパッケージの呼び出し）---------------------------------------------------------------------------
packages <- c(
  "tidyverse",
  "estimatr",
  "strucchange",
  "lmtest",
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
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/growth_data.csv",
  header=TRUE
)
head(Dat)

##　変数の定義---------------------------------------------------------------------------
which(Dat == "Mar-91") #1991年が何行目にあるか
Dat$d1991 <- ifelse(1:nrow(Dat) <= 41, 0, 1)
Dat$d1991growth <- Dat$d1991*lag(Dat$growth)

##　作図---------------------------------------------------------------------------
Growth <- ts(Dat$growth,start = c(1981,1), frequency = 4)
plot(Growth,type = "l", col = "blue", xlab = "year", ylab = "growth")

## 7.4.1節の推定結果
Out1<-lm(growth~lag(growth), data=Dat)
Out2<-lm(growth~lag(growth)+d1991+d1991growth,data=Dat)

summary(Out1)
summary(Out2)
mtable(Out1,Out2)

waldtest(Out2, terms = c("d1991", "d1991growth"))　#Out2のモデル式の"d1991", "d1991growth"について同時検定

 ###構造変化日はtq(1991Q2)とした。

## 7.4.2節の推定結果
fs <- Fstats(growth~lag(growth), data = Dat, from = 0.15, to = 0.85)
fstat <- ts(fs$Fstats,start = c(1985,1), frequency = 4)
print(fstat)
plot(fstat) #stataのsupFの値とは異なるものの、構造変化点となる時点は一致する。