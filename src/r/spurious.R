# はじめに ------------------------------------------------------------------------------------------------------------------------

# バージョンの確認(4.4.0で動作確認済)
R.version

# 使用するパッケージの呼び出し ---------------------------------------------------------------------------
packages <- c(
  "languageserver",
  "tidyverse",
  "memisc"
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

# データの読み込み ----------------------------------------------------------------------------------------------------
df <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/spurious_data.csv",
  header = TRUE
)
head(df)

# 変数の定義 ----------------------------------------------------------------------------------------------------
df$dy <- df$Y - lag(df$Y)
df$dx <- df$X - lag(df$X)

# 16.1節の分析 ----------------------------------------------------------------------------------------------------
#図16.1
par(family = "HiraKakuProN-W3")
plot(
  df$time,
  df$X,
  xlab = "年",
  ylab = "水準",
  type = "l",
  col = "red",
  ylim = c(-10, 20),
  main = "変数XとYの推移"
)
par(new = TRUE)
plot(
  df$time,
  df$Y,
  xlab = "年",
  ylab = "水準",
  type = "l",
  col = "blue",
  ylim = c(-10, 20)
)


# 見せかけの回帰 ----------------------------------------------------------------------------------------------------
model_1 <- lm(
  Y ~ X,
  data = df
)
summary(model_1)

# トレンド変数を追加する ----------------------------------------------------------------------------------------------------
model_2 <- lm(
  Y ~ X + time,
  data = df
)
summary(model_2)

# 階差の分析 ----------------------------------------------------------------------------------------------------
par(family = "HiraKakuProN-W3")
plot(
  df$time,
  df$dx,
  xlab = "年",
  ylab = "水準",
  type = "l",
  col = "red",
  ylim = c(-4, 4),
  main = "変数XとYの各階差の推移"
)
par(new = TRUE)
plot(
  df$time,
  df$dy,
  xlab = "年",
  ylab = "水準",
  type = "l",
  col = "blue",
  ylim = c(-4, 4)
)

out_3 <- lm(
  dy ~ dx,
  data = df
)
summary(out_3)