##はじめに------------------------------------------------------------------------------------------------------------------------
###作業ディレクトリ等については、サポートウェブサイトからダウンロードできる「同性愛者の割合」のRスクリプトを参照

#バージョンの確認（4.4.0で動作確認済）
R.version

##事前準備（使用するパッケージの呼び出し）---------------------------------------------------------------------------
packages <- c(
  "tidyverse",
  "estimatr",
  "car",
)

for (package in packages) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

##データの読み込み---------------------------------------------------------------------------
Dat <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/monthlyint_data.csv",
  header=TRUE
)
head(Dat)

##月次データ
Dat$time <- 1:nrow(Data1)

##変数の定義(1兆円単位に変換する)---------------------------------------------------------------------------
Dat[,2] <- Dat[,2]/10000
Dat[,3] <- Dat[,3]/10000
Dat[,4] <- Dat[,4]/10000

##推定結果(外貨準備)---------------------------------------------------------------------------
Out1 <- lm(intj ~ intj_gaika , data = Dat)
summary(Out1)
linearHypothesis(Out1, "intj_gaika = 1")
linearHypothesis(Out1, c("intj_gaika = 1","(Intercept) = 0"))

##推定結果(対民収支)---------------------------------------------------------------------------
Out2 <- lm(intj ~ intj_taimin , data = Dat)
summary(Out2)
linearHypothesis(Out2, "intj_taimin = 1")
linearHypothesis(Out2, c("intj_taimin = 1","(Intercept) = 0"))