##はじめに-----------------------------------------------------------------------------------------------------------
###作業ディレクトリ等については、サポートウェブサイトからダウンロードできる「同性愛者の割合」のRスクリプトを参照

#バージョンの確認（4.4.0で動作確認済）
R.version

##事前準備（使用するパッケージの呼び出し）---------------------------------------------------------------------------
packages <- c(
  "ggplot2", 
  "urca",
  "vars"
)

for (package in packages) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

##データの読み込み----------------------------------------------------------------------------------------------------
#rData1にcsvファイルの内容を格納。header=TRUEで１行目をヘッダーとする
rData <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/spread_data.csv",
  header=TRUE
)
head(rData)

##データの定義と確認---------------------------------------------------------------------------------------------------------
##データセットの加工
r_short <- rData[,1]
r_long <- rData[,2]
spread <- r_long - r_short　#変数spread（金利スプレッド）を定義
dspread <- c(NA, diff(spread))　#変数dspread（前年度との金利スプレッド差分）を定義
rData$time <- seq(as.Date("1980-01-01"), by="quarter", length.out=152) #データセットにtime列を追加
rData$spread <- spread
rData$dspread <- dspread
rData$l.spread <- spread-dspread

rData <- rData[,c("time","r_short","r_long","spread","dspread","l.spread")]　#データセットの再整形
head(rData, n=10)#n＝kで上からk番目まで表示、データが正しく定義できたか確認


##15.2.2節の推定-------------------------------------------------------------------------------------------------

# 長期金利と短期金利の折れ線グラフを描画
ggplot(rData, aes(x = time)) +
  geom_line(aes(y = r_long), color = "blue") +  # r_longの折れ線グラフ（青色）
  geom_line(aes(y = r_short), color = "red") +  # r_shortの折れ線グラフ（赤色）
  labs(x = "年", y = "%") + # x軸とy軸のラベルを設定
  theme_minimal() # グラフの見た目をシンプルにする

# 金利スプレッドの折れ線グラフを描画
ggplot(rData, aes(x = time)) +
  geom_line(aes(y = spread), color = "green") +  # spreadの折れ線グラフ（緑色）
  labs(x = "年", y = "%") +  # x軸とy軸のラベルを設定
  theme_minimal()  # グラフの形状をシンプルにする

model <- lm(spread ~ l.spread, data = rData)　# データを準備して線形回帰モデルを推定する
summary(model)　# 回帰モデルの要約を表示する


##16,2,4節の推定------------------------------------------------------------------------------------
adf_test_1 <- ur.df(rData$spread, type = "drift", lags = 0)　# 定数項のみを考慮した単位根検定を実行。Stata版と表示が異なるがT値は等しい。
summary(adf_test_1)
adf_test_2 <- ur.df(rData$spread, type = "trend", lags = 0)　#/*トレンドを入れたケース*/
summary(adf_test_2)　　　　　　　　　　　　　　　　　　　　　# 定数項と傾きを考慮した単位根検定を実行。Stata版と表示が異なるがT値は等しい。

#ADF検定でラグを選択したいなら、以下のコマンドでAICやBICを計算できる。
lag_selection <- VARselect(diff(rData$spread), lag.max=10, type="const")
print(lag_selection)

##DF-GLS検定---------------------------------------------------------------------------------
#現状RでできるDF-GLS検定を採用
#臨界値は近い値をとる
adf_test_notrend <- ur.ers(rData$spread, type = "DF-GLS", model = "constant", lag.max = 10)
summary(adf_test_notrend)　#定数項ありトレンド無しのDF-GLS検定
adf_test_withtrend <- ur.ers(rData$spread, type = "DF-GLS", model = "trend", lag.max = 10)
summary(adf_test_withtrend)　#定数項ありトレンドありのDF-GLS検定


##DF-GLS検定の練習問題--------------------------------------------------------------------
#現状RでできるDF-GLS検定を採用
#臨界値は近い値をとる
adf_test_r_long <- ur.ers(rData$r_long, type = "DF-GLS", model = "trend", lag.max = 10)
summary(adf_test_r_long)　#長期金利のDF-GLS検定 
adf_test_r_short <- ur.ers(rData$r_short, type = "DF-GLS", model = "trend", lag.max = 10)
summary(adf_test_r_short)　#短期金利のDF-GLS検定