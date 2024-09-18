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
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/stayhome_data.csv",
  header = TRUE
)
head(df)

# 変数の定義 ---------------------------------------------------------------------------
df$drain <- as.numeric(df$rain > 0)
df$linf <- log(df$infection + sqrt((df$infection)^2 + 1))
df$emerg <- df$emerg_start - df$emerg_end
df$close <- df$close_start - df$close_end
head(df)

# 11.4.2節の推定結果 ---------------------------------------------------------------------------
out_1 <- lm_robust(
  formula = stay ~ close + emerg + linf + drain + factor(prefecture) + factor(date),
  clusters = prefecture,
  se_type = "stata",
  weights = mobilephones,
  data = df
)
pass_1 <- summary(out_1)
result_1 <- pass_1$coefficients[
  !grepl("factor\\(prefecture\\)",
  rownames(pass_1$coefficients)), ,
  drop = FALSE
]
print(result_1[2:5, ]) #推定結果