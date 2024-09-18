# はじめに------------------------------------------------------------------------------------------------------------------------

# バージョンの確認(4.4.0で動作確認済)
R.version

# 使用するパッケージの呼び出し ---------------------------------------------------------------------------
package <- "estimatr"
if (!require(package, character.only = TRUE)) {
  install.packages(package)
  library(package = , character.only = TRUE)
}

# データの読み込み ---------------------------------------------------------------------------
df <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/suicidej_data.csv",
  header = TRUE
)
head(df)

# 11.4.2節 例11-3の推定結果 ---------------------------------------------------------------------------
out_1 <- lm_robust(
  suicide ~ unemployment + factor(prefecture), # 都道府県効果を考慮
  clusters = prefecture, # 都道府県
  se_type = "stata",
  data = df
)

pass_1 <- summary(out_1)

result_1 <- pass_1$coefficients[
  !grepl("factor\\(prefecture\\)",
  rownames(pass_1$coefficients)), ,
  drop = FALSE
]

print(result_1)

pass_1$adj.r.squared

out_2 <- lm_robust(
  suicide ~ unemployment + factor(prefecture) + factor(year), # 都道府県効果と年効果を考慮
  clusters = prefecture, # 都道府県
  se_type = "stata",
  data = df
)

pass_2 <- summary(out_2)

result_2 <- pass_2$coefficients[
  !grepl("factor\\(prefecture\\)",
  rownames(pass_2$coefficients)), ,
  drop = FALSE
]

print(result_2[c(1, 2), ])

pass_2$adj.r.squared