##はじめに------------------------------------------------------------------------------------------------------------------------
###作業ディレクトリ等については、サポートウェブサイトからダウンロードできる「同性愛者の割合」のRスクリプトを参照

#バージョンの確認（4.4.0で動作確認済）
R.version

##事前準備（使用するパッケージの呼び出し）---------------------------------------------------------------------------
packages <- c(
  "tidyverse",
  "estimatr",
  "strucchange"
)

for (package in packages) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

##データの読み込み---------------------------------------------------------------------------
Dat <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/dailyint_data.csv",
  header=TRUE
)
head(Dat)

Dat$time <- 1:nrow(Dat)

##変数の定義(ドル円レートは変化率に、介入額(単位億円)は介入額(単位兆円)に変換)---------------------------------------------------------------------------
Dat$ds <- 100*(log(Dat$spot)-log(lag(Dat$spot)))
Dat$intj <- Dat$intervention/10000

head(Dat)

## 7.4.2節の推定結果(supF検定と構造変化日の特定)---------------------------------------------------------------------------
Out1 <- lm(ds ~ intj , data=Dat)
summary(Out1)

fs1 <- Fstats(ds~intj, data = Dat, from = 0.15, to = 0.85)
fs <- fs1$Fstats
Dat2 <- Dat[(459:2596),] #両端15％をカット
Dat3 <- cbind(Dat2,fs)
Dat3[,1] <- as.Date(Dat3[,1],"%m/%d/%Y")
Dat3
plot(Dat3$date,Dat3$fs,type="l") #wald統計量の推移
max(Dat3$fs) #最大値を求める
  ##33.899と計算されるが制約数が２であるため、２で除すと16.945となり教科書と一致
Dat3[Dat3$fs >= 33.8,] #構造変化点


##前半(1995/4/18まで)と後半(1995/4/19から)で分けて、別々に推定する---------------------------------------------------------------------------
Out2 <- lm(ds ~ intj , subset = (time <= 1056), data=Dat)
Out3 <- lm(ds ~ intj , subset = (time > 1056), data=Dat)

mtable(Out2,Out3)

##推定結果の頑健性を調べるため、説明変数に新たにdsの1期前の値を加える---------------------------------------------------------------------------
Out4 <- lm(ds ~ intj + lag(ds) , data=Dat)
summary(Out4)
 
fs2 <- Fstats(ds~intj+lag(ds), data = Dat1, from = 0.15 , to = 0.85)
fs2_1 <- fs2$Fstats
Dat4 <- Dat1[(459:2597),] #両端15％をカット
Dat5 <- cbind(Dat4, fs2_1)
Dat5[,1] <- as.Date(Dat5[,1],"%m/%d/%Y")
plot(Dat5$date, Dat5$fs2_1, type="l")
max(Dat5$fs2_1)
Dat5[Dat5$fs2_1 >= 39.4,] #構造変化点

##構造変化日は1072(1995/5/10)となっているので、TBは1071(1995/5/9)下では、構造変化前後で別々に推定する
Out5 <- lm(ds ~ intj + lag(ds),subset = (time <= 1071),data=Dat1)
Out6 <- lm(ds ~ intj + lag(ds),subset = (time > 1071),data=Dat1)

mtable(Out5,Out6)


