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

##データの読み込み----------------------------------------------------------------------------------------------------
#Datにcsvファイルの内容を格納。header=TRUEで１行目をヘッダーとする
Dat <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/height_data.csv",
  header=TRUE
)
head(Dat)

##データの定義と確認---------------------------------------------------------------------------------------------------------
Dat$parent <- (Dat$father+1.08*Dat$mother)/2 #元データ$項目名<-(両親の平均身長) ←男性換算するため、母親の身長を1.08倍する
Dat$height <- 1.08*Dat$student*Dat$female + Dat$student*(1-Dat$female) #女性なら1.08倍する
head(Dat, n=10) #n＝kで上からk番目まで表示、データが正しく定義できたか確認

str(Dat) #データの属性を確認する
summary(Dat) #基本統計量を調べる

##2.6節と4.2.2節の推定結果---------------------------------------------------------------------------------------------
Out1<-lm(height~parent,data=Dat) #被説明変数をheight、説明変数をparentとしたOLS推定をする

summary(Out1) #上記のOLS推定の結果を表示

predict(Out1,newdata=data.frame(parent=190)) #parent=190としたときの予測値
predict(Out1,newdata=data.frame(parent=150)) #parent=150としたときの予測値
predict(Out1,newdata=data.frame(parent=(180+1.08*158)/2) )

##散布図と回帰直線を描く---------------------------------------------------------------------------------------------
par(family= "HiraKakuProN-W3")　#日本語表示を可能にするコマンド（2023/12/21時点での対処法）
plot(Data1$height,Data1$parent,main = "散布図と回帰直線",
     xlab = "height",ylab = "parent", col = "red", pch = 19)
abline(Out1,col="blue")

##5.3.2節の推定結果---------------------------------------------------------------------------------------------
Data1$mother2<-1.08*Data1$mother #母親の身長を男性換算したものがmother2
Out2<-lm(height~father+mother2,data=Data1) #被説明変数をheight、説明変数をfather、mother2としたOLS推定をする
Out3<-lm(height~father,data=Data1) #被説明変数をheight、説明変数をfatherとしたOLS推定をする

summary(Out2) #上記のOLS推定の結果を表示
summary(Out3) #上記のOLS推定の結果を表示

 ##　参考 ~結果を並べる~
mtable(Out2,Out3) #Out2とOut3の結果を並べて表示

##父親と母親の身長の散布図と標本相関係数---------------------------------------------------------------------------------------------
plot(Data1$mother,Data1$father,main = "父親と母親の身長の散布図",
     xlab="母親の身長",ylab = "父親の身長", col = "red", pch = 19)
cor(Data1$mother,Data1$father)


