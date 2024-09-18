# はじめに------------------------------------------------------------------------------------------------------------------------

# バージョンの確認(4.4.0で動作確認済)
R.version

# 使用するパッケージの呼び出し ---------------------------------------------------------------------------
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
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/star_data.csv",
  header = TRUE
)
head(df)

# 14.2.1節の推定結果---------------------------------------------------------------------------
model_1 <- lm_robust(
  formula = total_score ~ small + regular_aid + factor(school),
  data = df
)
pass_1 <- summary(model_1)
result_1 <- pass_1$coefficients
print(result_1[c(1:3), ]) #学校効果を非表示
model_1$adj.r.squared #調整済決定係数

model_2 <- lm_robust(
  formula = total_score ~ small + regular_aid + total_experience + factor(school),
  data = df
)
pass_2 <- summary(model_2)
result_2 <- pass_2$coefficients
print(result_2[c(1:4), ]) ##学校効果を非表示
model_2$adj.r.squared #調整済決定係数


# 追加推定：学校が同じ生徒であれば、誤差項が相互に相関している可能性がある。
# 学校をクラスターと考えて、クラスターロバスト標準誤差を用いる
model_3 <- lm_robust( # ロバスト標準誤差
  formula = total_score ~ small + regular_aid + total_experience + factor(school),
  clusters = school, # クラスターを指定
  se_type = "stata",
  data = df
)
pass_3 <- summary(model_3)
result_3 <- pass_3$coefficients
print(result_3[c(1:4), ])
model_3$adj.r.squared #調整済決定係数


# 練習問題
model_4 <- lm_robust( # ロバスト標準誤差
  formula = total_score ~ small + regular_aid + total_experience + black + boy + freelunch + factor(school),
  data = df
)
pass_4 <- summary(model_4)
result_4 <- pass_4$coefficients
print(result_4[c(1:7), ])

out_5 <- lm_robust( # ロバスト標準誤差
  formula = total_score ~ small + regular_aid + total_experience + black + boy + freelunch + factor(school),
  clusters = school, # クラスターを指定
  se_type = "stata",
  data = df
)
pass_5 <- summary(out_5)
result_5 <- pass_5$coefficients
print(result_5[c(1:7), ])