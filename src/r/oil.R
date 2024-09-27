# はじめに------------------------------------------------------------------------------------------------------------------------

# バージョンの確認(4.4.0で動作確認済)
R.version

# 使用するパッケージの呼び出し ---------------------------------------------------------------------------
packages <- c(
  "lubridate",
  "dplyr",
  "sandwich",
  "lmtest",
  "ggplot2",
  "nlme",
  "dynlm",
  "orcutt",
  "prais"
)

for (package in packages) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

# データの準備 ---------------------------------------------------------------------------
# データの読み込み
url <- "https://www.fbc.keio.ac.jp/~tyabu/keiryo/oil_data.csv"
df <- read.csv(url, header = TRUE)
head(df)

# 月次データ(1987M6-2017M12)の生成
start_date <- ymd("1987-06-01")
end_date <- ymd("2017-12-01")
monthly_sequence <- seq.Date(
  from = start_date,
  to = end_date,
  by = "month"
)
df$date <- monthly_sequence
head(df)

# 変数の定義
df <- df %>%
  mutate(
    oil = brent * spot,
    y = 100 * (log(price) - log(lag(price))),
    x = 100 * (log(oil) - log(lag(oil))),
    l1.x = lag(x),
    l2.x = lag(x, 2),
    dx = x - lag(x),
    l.dx = lag(dx),
    d1 = as.integer(date == ymd("2008-04-01")), #暫定税率の影響を除くための一時的ダミー
    d2 = as.integer(date == ymd("2008-05-01")) #暫定税率の影響を除くための一時的ダミー
  )

# 6.4.1節の推定（2000年1月以降のデータを用いて推定する）----------------------------------------------------------

df2 <- df %>%
  filter(
    date >= as.Date("2000-01-01")
  )
model_1 <- lm(
  y ~ x + l1.x + l2.x + d1 + d2,
  data = df2
)
summary(model_1)

# 累積効果を推定する簡単な方法(練習問題参照)
model_2 <- lm(
  y ~ dx + l.dx + l2.x + d1 + d2,
  data = df2
)
summary(model_2)

# AICとBICを計算する(p=0,1,2の場合) ----------------------------------------------------------
# p = 0 の場合
model_3 <- lm(
  y ~ x + d1 + d2,
  data = df2
)
print(paste("AIC:", AIC(model_3)))
print(paste("BIC:", BIC(model_3)))

# p = 1 の場合
model_4 <- lm(
  y ~ x + l1.x + d1 + d2,
  data = df2
)
print(paste("AIC:", AIC(model_4)))
print(paste("BIC:", BIC(model_4)))

# p = 2 の場合
model_5 <- lm(
  y ~ x + l1.x + l2.x + d1 + d2,
  data = df2
)
print(paste("AIC:", AIC(model_5)))
print(paste("BIC:", BIC(model_5)))

# 10.3.4節の推定 -----------------------------------------------------------------------------------------
model_6 <- lm(
  y ~ x + l1.x + l2.x + d1 + d2,
  data = df2
)
coeftest(
  model_6,
  vcov = vcovHC(
    model_6,
    type = "HC1" # ロバスト標準誤差を用いる
  )
)
T <- length(residuals(model_6)) # サンプルサイズT
print(T)
m <- 0.75 * T ^ (1 / 3) # バンド幅m
print(m)
nw_cov <- NeweyWest( # HAC標準誤差を用いる
  model_6,
  lag = 5, # m = 5 とする．
  adj = TRUE,
  prewhite = FALSE
)
coeftest(
  model_6,
  vcov. = nw_cov
)

# 図10.4 -----------------------------------------------------------------------------------------
df2$resid <- residuals(model_6)
ggplot(
  df2,
  aes(
    x = date,
    y = resid
  )
) +
  geom_line() +
  theme_minimal() +
  labs(
    title = "Time Series Plot of Residuals",
    y = "Residuals",
    x = "date"
  )

# 10.4節の推定 -----------------------------------------------------------------------------------------
# コクランオーカット推定
model_7 <- lm(
  y ~ x + l1.x + l2.x + d1 + d2,
  data = df2
)
result_7 <- cochrane.orcutt(
  model_7,
  convergence = 1
)
summary(result_7)
print(result_7$rho)

# Prais_Winsten推定
model_8 <- prais_winsten(
  y ~ x + l1.x + l2.x + d1 + d2,
  data = df2,
  index = df2$date,
  twostep = TRUE
)
summary(model_8)
print(model_8$rho[2])

# コクラン=オーカット推定は以下のOLS推定と同じ -----------------------------------------------------------------------------------------
df <- df %>%
  mutate(
    rho = rho,
    l.y = lag(y),
    y_hat = y- rho * l.y,
    x0_hat = 1 - rho,
    x1_hat = x - rho * l1.x,
    x2_hat = l1.x - rho * l2.x,
    l3.x = lag(x, 3),
    x3_hat = l2.x - rho * l3.x,
    d1_hat = d1 - rho * lag(d1),
    d2_hat = d2 - rho * lag(d2),
  )
df2 <- df %>%
  filter(date >= as.Date("2000-01-01"))

model_9 <- lm(
  y_hat ~ 0 + x0_hat + x1_hat + x2_hat + x3_hat + d1_hat + d2_hat,
  data = df2
)
summary(model_9)

# 追加(繰り返しコクラン=オーカット法) -----------------------------------------------------------------------------------------
model_10 <- lm(
  y ~ x + l1.x + l2.x + d1 + d2,
  data = df2
)
result_10 <- cochrane.orcutt(
  model_10,
  convergence = 6
)
summary(result_10)

# Prais-Winsten推定
model_11 <- prais_winsten(
  y ~ x + l1.x + l2.x + d1 + d2,
  data = df2,
  index = df2$date,
  twostep = FALSE
)
summary(model_11)
