# はじめに------------------------------------------------------------------------------------------------------------------------

# バージョンの確認(4.4.0で動作確認済)
R.version

# 使用するパッケージの呼び出し ---------------------------------------------------------------------------
packages <- c(
  "estimatr",
  "tidyverse",
  "sandwich",
  "lmtest",
  "dplyr",
  "margins"
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
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/marriage_data.csv",
  header = TRUE
)
head(df)

# 12.1.1節の推定結果(50歳以下の男性に限定した分析) ---------------------------------------------------------------------------
# 線形確率
male_lm <- lm(
  partner ~ age,
  data = df,
  subset = (male == 1 & age <= 50)
)

summary(male_lm)

predict_25 <- predict(
  male_lm,
  newdata = data.frame(age = 25)
)

predict_50 <- predict(
  male_lm,
  newdata = data.frame(age = 50)
)

print(c(predict_25, predict_50))

# 12.1.2節の推定結果(50歳以下の男性に限定した分析) ---------------------------------------------------------------------------
# プロビットモデル
male_probit <- glm(
  partner ~ age,
  subset = (male == 1 & age <= 50),
  data = df,
  family = binomial( # 二項分布
    link = "probit" # プロビット
  )
)

summary(male_probit)
predict_25pr <- predict(
  male_probit,
  newdata = data.frame(age = 25),
  type = "response"
)

predict_50pr <- predict(
  male_probit,
  newdata = data.frame(age = 50),
  type = "response"
)

print(c(predict_25pr, predict_50pr))

# 12.1.3節の図 ---------------------------------------------------------------------------
df2 <- df %>%
  dplyr::filter(age <= 50, male == 1)

df2$p_partner <- pnorm(
  predict(
    male_probit,
    type = "link"
  )
)

# プロットの作成
dev.off()
par(family = "")
plot(
  x = df2$age,
  y = df2$p_partner,
  main = "Marginal Effects in Probit Model",
  xlab = "Age",
  ylab = "Predicted Value",
  col = "blue",
  pch = 18
)


# 12.1.3節の推定結果(50歳以下の男性に限定した分析) ---------------------------------------------------------------------------

# 線形確率
male_lm <- lm_robust(
  partner ~ age + undergrad + grad,
  data = df,
  subset = (male == 1 & age <= 50)
)

summary(male_lm) # Adjusted R-squaredで調整済決定係数を確認(コード省略)

# プロビットモデル
male_probit <- glm(
  partner ~ age + undergrad + grad,
  data = df,
  subset = (male == 1 & age <= 50),
  family = binomial( # 二項分布
    link = "probit" # プロビット
  )
)

coeftest(
  male_probit,
  vcov = vcovHC(
    male_probit,
    type = "HC0" # ロバスト標準誤差
  )
)

# プロビットモデルの限界効果
male_probit_margins <- margins(male_probit)
summary(male_probit_margins)

# 12.1.3節の推定結果(50歳以下の女性に限定した分析) ---------------------------------------------------------------------------

# 線形確率
female_lm <- lm_robust(
  partner ~ age + undergrad + grad,
  data = df,
  subset = (male == 0 & age <= 50)
)

summary(female_lm) # Adjusted R-squaredで調整済決定係数を確認(コード省略)

# プロビットモデル
female_probit <- glm(
  partner ~ age + undergrad + grad,
  data = df,
  subset = (male == 0 & age <= 50),
  family = binomial( # 二項分布
    link = "probit" # プロビット
  )
)

coeftest(
  female_probit,
  vcov = vcovHC(
    female_probit,
    type = "HC0" # ロバスト標準誤差
  )
)

# プロビットモデルの限界効果
female_probit_margins <- margins(female_probit)
summary(female_probit_margins)

# 練習問題の推定結果(50歳以下の男性) ---------------------------------------------------------------------------

# プロビットモデル
male_probit <- glm(
  partner ~ age + undergrad + grad,
  data = df,
  subset = (male == 1 & age <= 50),
  family = binomial( # 二項分布
    link = "probit" # プロビットモデル
  )
)

coeftest(
  male_probit,
  vcov = vcovHC(
    male_probit,
    type = "HC0" # ロバスト標準誤差
  )
)

coefficients <- coef(male_probit)

p_grad <- pnorm(
  coefficients["(Intercept)"] + coefficients["age"] * df$age + coefficients["undergrad"] * 0 + coefficients["grad"] * 1
)

p_no <- pnorm(
  coefficients["(Intercept)"] + coefficients["age"] * df$age + coefficients["undergrad"] * 0 + coefficients["grad"] * 0
)

plot(
  x = df$age,
  y = p_grad,
  xlab = "age",
  ylab = "p_grad",
  main = "Scatter Plot of p_grad and p_no against age",
  col = "blue"
)

points(
  x = df$age,
  y = p_no,
  col = "red"
)

legend(
  "bottomright",
  legend = c(
    "p_grad",
    "p_no"
  ),
  col = c(
    "blue",
    "red"
  ),
  pch = 1
)