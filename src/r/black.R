##はじめに------------------------------------------------------------------------------------------------------------------------
###作業ディレクトリ等については、サポートウェブサイトからダウンロードできる「同性愛者の割合」のRスクリプトを参照

#バージョンの確認（4.4.0で動作確認済）
R.version

##事前準備（使用するパッケージの呼び出し）---------------------------------------------------------------------------
packages <- c(
  "tidyverse", 
  "modelsummary",
  "estimatr",
  "lmtest"
)

for (package in packages) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

##データの読み込み---------------------------------------------------------------------------
Dat <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/black_data.csv",
  header=TRUE
)
head(Dat)

## 9.3節の推定結果---------------------------------------------------------------------------
Out1<-lm(call~black,data=Data1)
Out1r<-lm_robust(call~black,data=Dat)
Out2<-lm(call~black+experience,data=Dat)
Out2r<-lm_robust(call~black+experience,data=Dat)

result9.3<-list(
  "Out1"=Out1,
  "Out1r"=Out1r,
  "Out2"=Out2,
  "Out2r"=Out2r
)
msummary(result9.3 , stars = TRUE ,fmt = '%.4f') #結果の一括表示

##9.4.2節の推定結果---------------------------------------------------------------------------
Out3r<-lm_robust(call~black+experience,data=Dat)
summary(Out3r)

Dat$p <- Out3r$fitted.values
Dat$h <- sqrt((1-Dat$p)*Dat$p)
Dat$x0 <- 1/Dat$h
Dat$call_h <- Dat$call/Dat$h
Dat$black_h <- Dat$black/Dat$h
Dat$experience_h <- Dat$experience/Dat$h

Out4 <- lm(call_h~x0+black_h+experience_h-1,data=Dat)
summary(Out4)
