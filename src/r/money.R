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

##データの読み込み）---------------------------------------------------------------------------
Dat <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/money_data.csv",
  header=TRUE
)
head(Dat)

##変数の定義---------------------------------------------------------------------------
Dat$lnm <- log(Dat$M1 / Dat$NGDP)
Dat$lnr <- log(Dat$interest)

str(Dat) #データの属性を確認する
summary(Dat) #基本統計量を調べる

##四半期データ(1980Q1-2013Q4) ※変数の定義をしてから時系列データとして読み込みをする---------------------------------------------------------------------------
Dat <- ts(Dat, start = c(1980, 1),frequency = 4) #四半期データ

##6.3.2節の推定---------------------------------------------------------------------------
Out1<-lm(lnm ~ lnr, data = Dat) #対数対数モデル
Out2<-lm(lnm ~ interest, data = Dat) #対数線形モデル

summary(Out1)
summary(Out2)
mtable(Out1,Out2)
