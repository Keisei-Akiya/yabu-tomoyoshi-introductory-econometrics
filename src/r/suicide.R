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
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/suicide_data.csv",
  header = TRUE
)
head(df)

# 11.3.1節の推定 ---------------------------------------------------------------------------
out_1 <- lm_robust(
  suicide ~ unemployment, # プールド回帰
  data = df
)
result_1 <- summary(out_1)
print(result_1) # 結果の表示
result_1$adj.r.squared # 調整済決定係数

out_2 <- lm_robust(
  suicide ~ unemployment + factor(country_name), # 国効果を考慮
  clusters = country_name, # 国
  se_type = "stata",
  data = df
)
pass_2 <- summary(out_2)
result_2 <- pass_2$coefficients[
  !grepl("factor\\(country_name\\)",
  rownames(pass_2$coefficients)), ,
  drop = FALSE
]
### 上のコマンドは地域ダミーの推定結果を出力しない
###  \\　の記号は、() をRで文字列として読ませるための記号
print(result_2)
pass_2$adj.r.squared


## 11.4.2節の推定---------------------------------------------------------------------------
out_3 <- lm_robust(
  suicide ~ unemployment + factor(country_name), # 国効果を考慮
  clusters = country_name, # 国
  se_type = "stata",
  data = df
)
pass_3 <- summary(out_3)
result_3 <- pass_3$coefficients[
  !grepl("factor\\(country_name\\)",
  rownames(pass_3$coefficients)), ,
  drop = FALSE
]
print(result_3)
pass_3$adj.r.squared

## 個別効果と時間効果を考慮した固定効果モデル
out_4 <- lm_robust(
  suicide ~ unemployment + factor(country_name) + factor(year), # 国効果と年効果を考慮
  clusters = country_name,
  se_type = "stata",
  data = df
)
result_4 <- summary(out_4)
pass_4 <- summary(out_4)
result_4 <- pass_4$coefficients[
  !grepl("factor\\(country_name\\)",
  rownames(pass_4$coefficients)),  ,
  drop = FALSE
]  #国効果を非表示
print(result_4[c(1, 2), ]) #変数の推定結果のみ表示
pass_4$adj.r.squared