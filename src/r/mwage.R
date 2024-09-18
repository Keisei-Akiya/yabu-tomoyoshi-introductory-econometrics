# はじめに------------------------------------------------------------------------------------------------------------------------

# バージョンの確認(4.4.0で動作確認済)
R.version

# 事前準備（使用するパッケージの呼び出し）---------------------------------------------------------------------------
packages <- c(
  "languageserver",
  "estimatr"
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
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/mwage_data.csv",
  header = TRUE
)
head(df)

# 変数を定義する---------------------------------------------------------------------------
df$timestate <- df$time * df$state
head(df)

# 14.3.1節の推定結果---------------------------------------------------------------------------
mean(
  df$fulltime[
    df$state == 1 & df$time == 0
  ],
  na.rm = TRUE
) #NJ州介入前
mean(
  df$fulltime[
    df$state == 1 & df$time == 1
  ],
  na.rm = TRUE
) #NJ州介入後
mean(
  df$fulltime[
    df$state == 0 & df$time == 0
  ],
  na.rm = TRUE
) #PA州介入前
mean(
  df$fulltime[
    df$state == 0 & df$time == 1
  ],
  na.rm = TRUE
) #PA州介入後

model_1 <- lm_robust(
  fulltime ~ state + time + timestate,
  clusters = store,
  se_type = "stata",
  data = df
)
summary(model_1)

model_2 <- lm_robust(
  fulltime ~ time + timestate + factor(store) - 1,
  clusters = store,
  se_type = "stata",
  data = df
)
pass_2 <- summary(model_2)
result_2 <- pass_2$coefficients
print(result_2[c(1:2), ])

## 練習問題の推定結果(営業時間とレジ台数を加える)
model_3 <- lm_robust(
  fulltime ~ state + time + timestate + hours + register,
  clusters = store,
  se_type = "stata",
  data = df
)
summary(model_3)

model_4 <- lm_robust(
  fulltime ~ time + timestate + hours + register + factor(store) - 1,
  clusters = store,
  se_type = "stata",
  data = df
)
pass_4 <- summary(model_4)
result_4 <- pass_4$coefficients
print(result_4[c(1:4), ])