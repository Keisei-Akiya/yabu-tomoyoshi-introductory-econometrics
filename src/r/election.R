# はじめに------------------------------------------------------------------------------------------------------------------------

# バージョンの確認(4.4.0で動作確認済)
R.version

# 使用するパッケージの呼び出し ---------------------------------------------------------------------------
packages <- c(
  "languageserver",
  "estimatr",
  "rdrobust"
)

for (package in packages) {
  if (!require(
    package,
    character.only = TRUE
  )) {
    install.packages(package)
    library(
      package,
      character.only = TRUE
    )
  }
}

# データの読み込み---------------------------------------------------------------------------
df <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/election_data.csv",
  header = TRUE
)
head(df)

# 変数の定義 ---------------------------------------------------------------------------
df$W <- df$diff_share
df$X <- as.numeric(df$W >= 0)
df$Y <- as.numeric(df$myoutcomenext)
df <- na.omit(df)

# 14.4節の推定結果 ---------------------------------------------------------------------------
rdplot(
  y = df$Y,
  x = df$W,
  x.lim = c(-0.2, 0.2)
)

df$W2 <- (df$W)^2
df$W3 <- (df$W)^3
df$WX <- (df$W) * (df$X)
df$WX2 <- (df$W2) * (df$X)
df$WX3 <- (df$W3) * (df$X)

model_1 <- lm_robust(
    Y ~ X + W + W2 + W3 + WX + WX2 + WX3,
    data = df,
    subset = (W >= -0.2 & W <= 0.2)
)
summary(model_1)

# 練習問題 ---------------------------------------------------------------------------
model_2 <- lm_robust(
    Y ~ X + W + WX,
    data = df,
    subset = (W >= -0.15 & W <= 0.15)
)
summary(model_2)

# バンド幅と乗数を最適に選択するコマンド ---------------------------------------------------------------------------
rd <- rdrobust(
    df$Y,
    df$W,
    kernel = "tri",
    c = 0
)
summary(rd)