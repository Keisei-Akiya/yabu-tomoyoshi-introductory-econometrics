##はじめに------------------------------------------------------------------------------------------------------------------------
###作業ディレクトリ等については、サポートウェブサイトからダウンロードできる「同性愛者の割合」のRスクリプトを参照

#バージョンの確認（4.4.0で動作確認済）
R.version

##事前準備（使用するパッケージの呼び出し）---------------------------------------------------------------------------
packages <- c(
  "tidyverse", 
  "modelsummary",
  "estimatr",
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
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/cons_data.csv",
  header=TRUE
)
head(Dat)

##9.4.1節の推定結果---------------------------------------------------------------------------
Out1r <- lm_robust(cons~income,data=Dat)
Out2 <- lm(cons~income,weights = number,data=Dat)
Out2r <- lm_robust(cons~income,weights = number,data=Dat)

result9.4.1<-list(
  "Out1r" = Out1r,
  "Out2" = Out2,
  "Out2r" = Out2r
)

msummary(result9.4.1,stars = TRUE,fmt = '%.4f')
