# はじめに------------------------------------------------------------------------------------------------------------------------

# バージョンの確認(4.4.0で動作確認済)
R.version

# 使用するパッケージの呼び出し ---------------------------------------------------------------------------
packages <- c(
  "languageserver",
  "estimatr",
  "AER",
  "lmtest"
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
df_1 <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/protection_data.csv",
  header = TRUE
)
head(df_1)

# 13.6節の推定結果 ---------------------------------------------------------------------------
out_1 <- lm_robust(
  formula = gdp1995 ~ protection,
  data = df_1
)
summary(out_1)
out_2 <- iv_robust(
  formula = gdp1995 ~ protection | mortality,
  se_type = "stata",
  data = df_1
)
summary(out_2)

# 13.7節の推定結果 ---------------------------------------------------------------------------
out_3 <- iv_robust(
  formula = gdp1995 ~ protection + latitude | mortality + europop + latitude,
  se_type = "stata",
  data = df_1
)
summary(out_3)

out_4 <- lm(
  formula = protection ~ mortality + europop + latitude,
  data = df_1
)
summary(out_4)
waldtest(
  out_4,
  terms = c("mortality", "europop")
)

# 過剰識別検定 ---------------------------------------------------------------------------
out_5 <- ivreg(
  formula= gdp1995 ~ protection + latitude | mortality + europop + latitude,
  data = df_1
)
summary(out_5, diagnostics = TRUE)
#Weak-instruments 弱相関検定
#Wu-Hausman ハウスマン検定
#Sargan 過剰識別検定

###13.7.3節の過剰識別性検定を行う。p値が10%を上回れば、帰無仮説が採択され(操作変数の外生性が満たされる)、
###p値が10%を下回れば、帰無仮説が棄却される(操作変数の外生性が満たされない)