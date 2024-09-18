# はじめに------------------------------------------------------------------------------------------------------------------------

# バージョンの確認(4.4.0で動作確認済)
R.version

# 使用するパッケージの呼び出し ---------------------------------------------------------------------------
packages <- c(
  "languageserver",
  "estimatr",
  "AER"
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
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/laborsupply_data.csv",
  header = TRUE
)
head(df)

# 13.6節の推定結果 ---------------------------------------------------------------------------
out_1 <- lm_robust(
  weeks ~ morekids,
  data = df,
  se_type = "stata"
)
out_2 <- iv_robust(
  weeks ~ morekids
  | samesex,
  data = df,
  se_type = "stata"
)
summary(out_1)
summary(out_2)


# 練習問題他のコントロール変数を含めた分析 ---------------------------------------------------------------------------
out_3 <- lm_robust(
  weeks ~ morekids + age + black + hispan + othrace,
  data = df,
  se_type = "stata"
)
out_4 <- iv_robust(
  weeks ~ morekids + age + black + hispan + othrace
  | samesex + age + black + hispan + othrace ,
  data = df,
  se_type = "stata"
)
summary(out_3)
summary(out_4)