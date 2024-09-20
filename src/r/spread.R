##�͂��߂�-----------------------------------------------------------------------------------------------------------
###��ƃf�B���N�g�����ɂ��ẮA�T�|�[�g�E�F�u�T�C�g����_�E�����[�h�ł���u�������҂̊����v��R�X�N���v�g���Q��

#�o�[�W�����̊m�F�i4.4.0�œ���m�F�ρj
R.version

##���O�����i�g�p����p�b�P�[�W�̌Ăяo���j---------------------------------------------------------------------------
packages <- c(
  "ggplot2", 
  "urca",
  "vars"
)

for (package in packages) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

##�f�[�^�̓ǂݍ���----------------------------------------------------------------------------------------------------
#rData1��csv�t�@�C���̓��e���i�[�Bheader=TRUE�łP�s�ڂ��w�b�_�[�Ƃ���
rData <- read.csv(
  "https://www.fbc.keio.ac.jp/~tyabu/keiryo/spread_data.csv",
  header=TRUE
)
head(rData)

##�f�[�^�̒�`�Ɗm�F---------------------------------------------------------------------------------------------------------
##�f�[�^�Z�b�g�̉��H
r_short <- rData[,1]
r_long <- rData[,2]
spread <- r_long - r_short�@#�ϐ�spread�i�����X�v���b�h�j���`
dspread <- c(NA, diff(spread))�@#�ϐ�dspread�i�O�N�x�Ƃ̋����X�v���b�h�����j���`
rData$time <- seq(as.Date("1980-01-01"), by="quarter", length.out=152) #�f�[�^�Z�b�g��time���ǉ�
rData$spread <- spread
rData$dspread <- dspread
rData$l.spread <- spread-dspread

rData <- rData[,c("time","r_short","r_long","spread","dspread","l.spread")]�@#�f�[�^�Z�b�g�̍Đ��`
head(rData, n=10)#n��k�ŏォ��k�Ԗڂ܂ŕ\���A�f�[�^����������`�ł������m�F


##15.2.2�߂̐���-------------------------------------------------------------------------------------------------

# ���������ƒZ�������̐܂���O���t��`��
ggplot(rData, aes(x = time)) +
  geom_line(aes(y = r_long), color = "blue") +  # r_long�̐܂���O���t�i�F�j
  geom_line(aes(y = r_short), color = "red") +  # r_short�̐܂���O���t�i�ԐF�j
  labs(x = "�N", y = "%") + # x����y���̃��x����ݒ�
  theme_minimal() # �O���t�̌����ڂ��V���v���ɂ���

# �����X�v���b�h�̐܂���O���t��`��
ggplot(rData, aes(x = time)) +
  geom_line(aes(y = spread), color = "green") +  # spread�̐܂���O���t�i�ΐF�j
  labs(x = "�N", y = "%") +  # x����y���̃��x����ݒ�
  theme_minimal()  # �O���t�̌`����V���v���ɂ���

model <- lm(spread ~ l.spread, data = rData)�@# �f�[�^���������Đ��`��A���f���𐄒肷��
summary(model)�@# ��A���f���̗v���\������


##16,2,4�߂̐���------------------------------------------------------------------------------------
adf_test_1 <- ur.df(rData$spread, type = "drift", lags = 0)�@# �萔���݂̂��l�������P�ʍ���������s�BStata�łƕ\�����قȂ邪T�l�͓������B
summary(adf_test_1)
adf_test_2 <- ur.df(rData$spread, type = "trend", lags = 0)�@#/*�g�����h����ꂽ�P�[�X*/
summary(adf_test_2)�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@# �萔���ƌX�����l�������P�ʍ���������s�BStata�łƕ\�����قȂ邪T�l�͓������B

#ADF����Ń��O��I���������Ȃ�A�ȉ��̃R�}���h��AIC��BIC���v�Z�ł���B
lag_selection <- VARselect(diff(rData$spread), lag.max=10, type="const")
print(lag_selection)

##DF-GLS����---------------------------------------------------------------------------------
#����R�łł���DF-GLS������̗p
#�ՊE�l�͋߂��l���Ƃ�
adf_test_notrend <- ur.ers(rData$spread, type = "DF-GLS", model = "constant", lag.max = 10)
summary(adf_test_notrend)�@#�萔������g�����h������DF-GLS����
adf_test_withtrend <- ur.ers(rData$spread, type = "DF-GLS", model = "trend", lag.max = 10)
summary(adf_test_withtrend)�@#�萔������g�����h�����DF-GLS����


##DF-GLS����̗��K���--------------------------------------------------------------------
#����R�łł���DF-GLS������̗p
#�ՊE�l�͋߂��l���Ƃ�
adf_test_r_long <- ur.ers(rData$r_long, type = "DF-GLS", model = "trend", lag.max = 10)
summary(adf_test_r_long)�@#����������DF-GLS����
adf_test_r_short <- ur.ers(rData$r_short, type = "DF-GLS", model = "trend", lag.max = 10)
summary(adf_test_r_short)�@#�Z��������DF-GLS����