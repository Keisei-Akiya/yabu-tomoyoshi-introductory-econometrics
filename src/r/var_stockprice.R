# はじめに------------------------------------------------------------------------------------------------------------------------

# バージョンの確認(4.4.0で動作確認済)
R.version

# 使用するパッケージの呼び出し ---------------------------------------------------------------------------
packages <- c(
  "languageserver",
  "tidyverse",
  "lubridate",
  "vars",
  "xts",
  "dplyr",
  "sandwich",
  "lmtest",
  "car"
)

for (package in packages) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

# データの準備 ---------------------------------------------------------------------------
# データの読み込み
df <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/var_stockprice_data.csv",
  header = TRUE
)
head(df)

# データの加工
df$date <- ymd(df$date) # date列をDate型に変換
df <- df %>%
  dplyr::select(date, Dow, Nikkei) %>% # date列，Dow列，Nikkei列のみ使用
  arrange(date) # date列で並び替え
start_year <- year(min(df$date)) # データの開始年を取得
start_month <- month(min(df$date)) # データの開始月を取得
ts_data <- ts( # tsオブジェクトの作成
  df[, -1],
  start = c(start_year, start_month),
  frequency = 12
)
head(ts_data) # データの確認

# 15.3.2節の推定結果 ---------------------------------------------------------------------------

# ラグ次数の決定(AICとSBICをみよう)
var_select <- VARselect(
  ts_data,
  lag.max = 12,
  type = "const"
)
var_select

# p = 4 としたVARとグレンジャーの因果性検定

# ラグ変数の作成
df_data_lagged <- as.data.frame(ts_data) # tsオブジェクトをdfに変換
df_data_lagged <- df_data_lagged %>% # データフレームに対してmutateを使用してラグ変数を作成
  mutate(
    lag1_dow = lag(Dow, 1),
    lag2_dow = lag(Dow, 2),
    lag3_dow = lag(Dow, 3),
    lag4_dow = lag(Dow, 4),
    lag1_nikkei = lag(Nikkei, 1),
    lag2_nikkei = lag(Nikkei, 2),
    lag3_nikkei = lag(Nikkei, 3),
    lag4_nikkei = lag(Nikkei, 4)
  )
df_data_lagged <- na.omit(df_data_lagged) # 欠損値を含む行を除去
ts_data_lagged <- ts( # データフレームを再びtsオブジェクトに変換
  df_data_lagged,
  start = c(start_year, start_month),
  frequency = 12
)
head(ts_data_lagged)# データの確認

# 回帰分析
model_Nikkei <- lm(
  Nikkei ~
    lag1_nikkei + lag2_nikkei + lag3_nikkei + lag4_nikkei
    + lag1_dow + lag2_dow + lag3_dow + lag4_dow,
  data = ts_data_lagged
)
robust_se_Nikkei <- coeftest(
  model_Nikkei,
  vcov = vcovHC(
    model_Nikkei,
    type = "HC1"
  )
)
summary(model_Nikkei)
print(robust_se_Nikkei)
# F検定
f_test_result_Nikkei <- linearHypothesis(
  model_Nikkei,
  c(
    "lag1_dow = 0",
    "lag2_dow = 0",
    "lag3_dow = 0",
    "lag4_dow = 0"
  )
)
print(f_test_result_Nikkei)

# 回帰分析の実行
model_Dow <- lm(
  Dow ~
    lag1_nikkei + lag2_nikkei + lag3_nikkei + lag4_nikkei
    + lag1_dow + lag2_dow + lag3_dow + lag4_dow,
  data = ts_data_lagged
)
robust_se_Dow <- coeftest(
  model_Dow,
  vcov = vcovHC(
    model_Dow,
    type = "HC1"
  )
)
summary(model_Dow)
print(robust_se_Dow)
# F検定
f_test_result <- linearHypothesis(
  model_Dow,
  c(
    "lag1_nikkei = 0",
    "lag2_nikkei = 0",
    "lag3_nikkei = 0",
    "lag4_nikkei = 0"
  )
)
print(f_test_result)

# 15.4節の推定結果 ---------------------------------------------------------------------------
var_model <- VAR(
  ts_data,
  p = 4,
  type = "const"
) # VARモデルの推定
summary(var_model)

# インパルス応答関数の作成
irf_result <- irf(
  var_model,
  impulse = c(
    "Dow",
    "Nikkei"
  ),
  response = c(
    "Dow",
    "Nikkei"
  ),
  n.ahead = 10, # 予測期間
  boot = TRUE # ブートストラップ法
)

par(
  mfrow = c(2, 2)
) # グラフィックスウィンドウを2行2列に分割

# DowからDowへのショックに対するインパルス応答関数のプロット
plot(
  irf_result$irf$Dow[, "Dow"],
  type = "l",
  main = "Impulse from Dow to Dow",
  xlab = "Periods",
  ylab = "Response",
  xlim = c(0, 10),
  ylim = c(0, 1.5)
  )
lines(
  irf_result$Lower$Dow[, "Dow"],
  col = "red",
  lty = 2
)
lines(
  irf_result$Upper$Dow[, "Dow"],
  col = "red",
  lty = 2
)

# DowからNikkeiへのショックに対するインパルス応答関数のプロット
plot(
  irf_result$irf$Dow[, "Nikkei"],
  type = "l",
  main = "Impulse from Dow to Nikkei",
  xlab = "Periods",
  ylab = "Response",
  xlim = c(0, 10),
  ylim = c(0, 1.5)
  )
lines(
  irf_result$Lower$Dow[, "Nikkei"],
  col = "red",
  lty = 2
)
lines(
  irf_result$Upper$Dow[, "Nikkei"],
  col = "red",
  lty = 2
)

# NikkeiからDowへのショックに対するインパルス応答関数のプロット
plot(
  irf_result$irf$Nikkei[, "Dow"],
  type = "l",
  main = "Impulse from Nikkei to Dow",
  xlab = "Periods",
  ylab = "Response",
  xlim = c(0, 10),
  ylim = c(0, 1.5)
  )
lines(
  irf_result$Lower$Nikkei[, "Dow"],
  col = "red",
  lty = 2
)
lines(
  irf_result$Upper$Nikkei[, "Dow"],
  col = "red",
  lty = 2
)

# NikkeiからNikkeiへのショックに対するインパルス応答関数のプロット
plot(
  irf_result$irf$Nikkei[, "Nikkei"],
  type = "l",
  main = "Impulse from Nikkei to Nikkei",
  xlab = "Periods",
  ylab = "Response",
  xlim = c(0, 10),
  ylim = c(0, 1.5)
  )
lines(
  irf_result$Lower$Nikkei[, "Nikkei"],
  col = "red",
  lty = 2
)
lines(
  irf_result$Upper$Nikkei[, "Nikkei"],
  col = "red",
  lty = 2
)

par(mfrow = c(1, 1)) # デフォルトのグラフィックス設定に戻す

# 15章の練習問題 ---------------------------------------------------------------------------
# p=1としたVARとグレンジャーの因果性検定
# ラグ変数の作成
df_data_lagged <- as.data.frame(ts_data) # tsオブジェクトをdfに変換
df_data_lagged <- df_data_lagged %>% # データフレームに対してmutateを使用してラグ変数を作成
  mutate(
    lag1_dow = lag(Dow, 1),
    lag1_nikkei = lag(Nikkei, 1),
  )
df_data_lagged <- na.omit(df_data_lagged) # 欠損値を含む行を除去
ts_data_lagged <- ts( # データフレームを再びtsオブジェクトに変換
  df_data_lagged,
  start = c(start_year, start_month),
  frequency = 12
)
head(ts_data_lagged)# データの確認

# 回帰分析の実行
model <- lm(
  Nikkei ~ lag1_nikkei + lag1_dow,
  data = ts_data_lagged
)
robust_se <- coeftest(
  model,
  vcov = vcovHC(
    model,
    type = "HC1"
  )
) # ロバスト標準誤差
summary(model)
print(robust_se)
# F検定
f_test_result <- linearHypothesis(
  model,
  "lag1_dow = 0"
)
print(f_test_result)

# 回帰分析の実行
model <- lm(
  Dow ~ lag1_nikkei + lag1_dow,
  data = ts_data_lagged
)
robust_se <- coeftest(
  model,
  vcov = vcovHC(
    model,
    type = "HC1"
  )
) # ロバスト標準誤差
summary(model)
print(robust_se)
# F検定
f_test_result <- linearHypothesis(
  model,
  "lag1_nikkei = 0"
)
print(f_test_result)

# VARモデルの推定
var_model <- VAR(
  ts_data,
  p = 1,
  type = "const"
)
summary(var_model)
# インパルス応答関数の作成
irf_result <- irf(
  var_model,
  impulse = c("Dow", "Nikkei"),
  response = c("Dow", "Nikkei"),
  n.ahead = 10, # 予測期間
  boot = TRUE # ブートストラップ法
)

par(
  mfrow = c(2, 2)
) # グラフィックスウィンドウを2行2列に分割
# DowからDowへのショックに対するインパルス応答関数のプロット
plot(
  irf_result$irf$Dow[, "Dow"],
  type = "l",
  main = "Impulse from Dow to Dow",
  xlab = "Periods",
  ylab = "Response"
)
lines(
  irf_result$Lower$Dow[, "Dow"],
  col = "red",
  lty = 2
)
lines(
  irf_result$Upper$Dow[, "Dow"],
  col = "red",
  lty = 2
)
# DowからNikkeiへのショックに対するインパルス応答関数のプロット
plot(
  irf_result$irf$Dow[, "Nikkei"],
  type = "l",
  main = "Impulse from Dow to Nikkei",
  xlab = "Periods",
  ylab = "Response"
)
lines(
  irf_result$Lower$Dow[, "Nikkei"],
  col = "red",
  lty = 2
)
lines(
  irf_result$Upper$Dow[, "Nikkei"],
  col = "red",
  lty = 2
)
# NikkeiからDowへのショックに対するインパルス応答関数のプロット
plot(
  irf_result$irf$Nikkei[, "Dow"],
  type = "l",
  main = "Impulse from Nikkei to Dow",
  xlab = "Periods",
  ylab = "Response"
)
lines(
  irf_result$Lower$Nikkei[, "Dow"],
  col = "red",
  lty = 2
)
lines(
  irf_result$Upper$Nikkei[, "Dow"],
  col = "red",
  lty = 2
)
# NikkeiからNikkeiへのショックに対するインパルス応答関数のプロット
plot(
  irf_result$irf$Nikkei[, "Nikkei"],
  type = "l",
  main = "Impulse from Nikkei to Nikkei",
  xlab = "Periods",
  ylab = "Response"
)
lines(
  irf_result$Lower$Nikkei[, "Nikkei"],
  col = "red",
  lty = 2
)
lines(
  irf_result$Upper$Nikkei[, "Nikkei"],
  col = "red",
  lty = 2
)