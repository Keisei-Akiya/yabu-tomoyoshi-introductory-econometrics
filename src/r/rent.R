##はじめに------------------------------------------------------------------------------------------------------------------------
###作業ディレクトリ等については、サポートウェブサイトからダウンロードできる「同性愛者の割合」のRスクリプトを参照

#バージョンの確認（4.4.0で動作確認済）
R.version

##事前準備（使用するパッケージの呼び出し）---------------------------------------------------------------------------
packages <- c(
  "tidyverse", 
  "modelsummary",
  "estimatr"
)

for (package in packages) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

##データの読み込み---------------------------------------------------------------------------
Dat <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/rent_data.csv",
  header=TRUE
)
head(Dat)

str(Dat) #データの属性を確認する
summary(Dat) #基本統計量を調べる

##3.5節の推定結果(724物件のデータを用いた推定)---------------------------------------------------------------------------
Out1 <- lm(rent~space,data=Dat) #被説明変数をrent、説明変数をspaceとしたOLS推定
summary(Out1)

par(family= "HiraKakuProN-W3")　#日本語表示を可能にするコマンド（2023/12/30時点での対処法）
plot(Dat$space,Data1$rent, main = "散布図と回帰直線",
     xlab = "space",ylab = "rent",col = "red", pch = 19) #横軸をspace、縦軸をrentとした散布図
abline(Out1,col="blue") #散布図に回帰直線をいれる

##5.3.2節の推定結果---------------------------------------------------------------------------
Out2 <- lm(rent~distance+space,data=Dat) #被説明変数をrent、説明変数をdistance、spaceとしたOLS推定
Out3 <- lm(rent~distance,data=Dat) #被説明変数をrent、説明変数をdistanceとしたOLS推定

summary(Out2)
summary(Out3)

results1 <- list(
  "Out2"=Out2,
  "Out3"=Out3) #出力結果の名前をそれぞれOut2とOut3とする
modelsummary(results1,stars = T,fmt = '%.4f')

cor(Data1$distance,Data1$space) #distanceとspaceの標本相関係数

##5.6.2節の推定結果---------------------------------------------------------------------------
Out4 <- lm(rent~space,data=Dat)
Out5 <- lm(rent~space+distance,data=Dat)
Out6 <- lm(rent~space+distance+age+floor,data=Dat)

summary(Out4)
summary(Out5)
summary(Out6)

results2 <- list(
  "Out4"=Out4,
  "Out5"=Out5,
  "Out6"=Out6)
modelsummary(results2,stars = T,fmt = '%.4f') #教科書表5-2と同じ表示

##6.6節の推定結果(測定単位を変更する)---------------------------------------------------------------------------
Dat$rent_10000 <- Dat$rent*10000 #rentの単位を変更

Out7<-lm(rent~space,data=Dat)
Out8<-lm(rent_10000~space,data=Dat)

summary(Out7)
summary(Out8)
result3<-list(
  "Out7"=Out7,
  "Out8"=Out8
)
msummary(result3,stars = T,fmt = '%.4f')

##9.3節の推定結果---------------------------------------------------------------------------
Out9<-lm(rent~space,data=Dat)
Out10<-lm_robust(rent~space,data=Dat)　#ロバスト標準語差

summary(Out9)
summary(Out10)

results4<-list(
  "Out9"=Out9,
  "Out10"=Out10)
msummary(results4, stars = T, fmt = '%.4f')



