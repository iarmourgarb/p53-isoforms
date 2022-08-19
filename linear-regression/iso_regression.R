library(readr)
library(sjPlot)
library(sjmisc)
library(sjlabelled)
library(dplyr)

dbd_df <- read_csv("Desktop/THESIS/rmsd_rmsf_data/dbd_df.csv")

model1 <- lm(DBD ~ IVR1:IVR1_val + IVR2:IVR2_val + IVR3:IVR3_val + IVR4:IVR4_val, data=dbd_df)
summary(model1)

model2 <- lm(DBD ~ factor(IVR1) + factor(IVR2) + factor(IVR3) + factor(IVR4), data=dbd_df)
summary(model2)

tab_model(model1,
          dv.labels=c("Average RMSF of DBD"),
          file="regression_1.doc", auto.label = FALSE)

tab_model(model2,
          dv.labels=c("Average RMSF of DBD"),
          file="regression_2.doc", auto.label = FALSE)
