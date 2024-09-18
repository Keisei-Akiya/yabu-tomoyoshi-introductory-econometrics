# はじめに------------------------------------------------------------------------------------------------------------------------

# バージョンの確認(4.4.0で動作確認済)
R.version

# 使用するパッケージの呼び出し ---------------------------------------------------------------------------
packages <- c(
  "languageserver",
  "estimatr",
  "sandwich",
  "lmtest",
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

# ## データの読み込み---------------------------------------------------------------------------
df <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/participation_data.csv",
  header = TRUE
)
head(df)

# 変数の定義 ---------------------------------------------------------------------------
df$full <- as.numeric(df$job == 1)
df$part <- as.numeric(df$job == 2)
df$work <- df$full + df$part
df$under6 <- as.numeric(df$yongest < 6)
head(df)

# 12.6節の推定結果(50歳以下の男性に限定した分析) ---------------------------------------------------------------------------
# 線形確率
male_lm <- lm_robust(
  formula = work ~ experience + undergrad + grad + partner + under6 + children,
  data = df,
  subset = (male == 1 & age <= 50) # 男性 & 50歳以下
)
summary(male_lm)

# プロビットモデル
male_probit <- glm(
  formula = work ~ experience + undergrad + grad + partner + under6 + children,
  data = df,
  subset = (male == 1 & age <= 50), # 男性 & 50歳以下
  family = binomial(link = "probit") # プロビットモデル
)
coeftest(
  male_probit,
  vcov = vcovHC(
    male_probit,
    type = "HC1" # ロバスト標準誤差
  )
)

# プロビットモデルの限界効果
male_probit_margins <- margins(male_probit)
summary(male_probit_margins)

# ロジットモデル
male_logit <- glm(
  formula = work ~ experience + undergrad + grad + partner + under6 + children,
  data = df,
  subset = (male == 1 & age <= 50), # 男性 & 50歳以下
  family = binomial(link = "logit") # ロジットモデル
)
coeftest(
  male_logit,
  vcov = vcovHC(
    male_logit,
    type = "HC0" # ロバスト標準誤差
  )
)

# ロジットモデルの限界効果
male_logit_margins <- margins(male_logit)
summary(male_logit_margins)

# 12.6節の推定結果(50歳以下の女性に限定した分析)---------------------------------------------------------------------------
# 線形確率
female_lm <- lm_robust(
  formula = work ~ experience + undergrad + grad + partner + under6 + children,
  data = df,
  subset = (male == 0 & age <= 50) # 女性 & 50歳以下
)
summary(female_lm) #Adjusted R-squared で調整済決定係数を確認（コード省略）

# プロビットモデル
female_probit <- glm(
  formula = work ~ experience + undergrad + grad + partner + under6 + children,
  data = df,
  subset = (male == 0 & age <= 50), # 女性 & 50歳以下
  family = binomial(link = "probit") # プロビットモデル
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

# ロジットモデル
female_logit <- glm(
  formula = work ~ experience + undergrad + grad + partner + under6 + children,
  data = df,
  subset = (male == 0 & age <= 50), # 女性 & 50歳以下
  family = binomial(logit) # ロジットモデル
)
coeftest(
  female_logit,
  vcov = vcovHC(
    female_logit,
    type = "HC0" # ロバスト標準誤差
  )
)

# ロジットモデルの限界効果
female_logit_margins <- margins(female_logit)
summary(female_logit_margins)