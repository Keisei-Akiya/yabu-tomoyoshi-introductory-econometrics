##はじめに------------------------------------------------------------------------------------------------------------------------
####作業ディレクトリ等については、サポートウェブサイトからダウンロードできる「同性愛者の割合」のRスクリプトを参照

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
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/demography_data.csv",
  header=TRUE
)
head(Dat)

str(Dat) #データの属性を確認する

Dat <-
  Dat %>%
  mutate(region_code = as.numeric(factor(region))) #regionが文字列(string)なので、これを数値に変換する

table(Dat$region_code) #region_codeは1から7までの数値であることを確認する

Dat$gdp2015 <- log(Dat$rgdp2015/Dat$pop2015)  #2015年の1人当たりGDPの対数
Dat$gdp1990 <- log(Dat$rgdp1990/Dat$pop1990)  #1990年の1人当たりGDPの対数
Dat$dgdp <- Dat$gdp2015 - Dat$gdp1990  #1990年から2015年にかけてのGDP変化率
Dat$ddepend <- Dat$depend2015 - Dat$depend1990  #高齢者割合の変化*/
Dat$lpop1990 <- log(Dat$pop1990)

summary(Dat) #基本統計量を調べる

##説明変数に人口比を用いた推定---------------------------------------------------------------------------
Out1 <- lm(dgdp~ddepend,data = Dat)
Out2 <- lm(dgdp~ddepend+gdp1990 ,data = Dat) #コントロール変数として、1990年のGDPを追加
Out3 <- lm(dgdp~ddepend+gdp1990+lpop1990+depend1990+factor(region_code) ,data = Dat) #1990年の人口、高齢者割合、地域ダミーを追加

summary(Out1)
summary(Out2)
summary(Out3) #地域別効果の係数が表示される


##練習問題、説明変数に平均年齢を用いた推定---------------------------------------------------------------------------

Dat$ddepend2 = Dat$depend2015_ave - Dat$depend1990_ave

Out4 <- lm(dgdp ~ ddepend2, data=Dat)
Out5 <- lm(dgdp ~ ddepend2 + gdp1990 + lpop1990 + depend1990_ave + factor(region_code), data=Dat)

summary(Out4)
summary(Out5)
mtable(Out4,Out5)
