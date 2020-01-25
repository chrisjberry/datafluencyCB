library(tidyverse)
library(BayesFactor)

memory_data <- 
  tibble(
    attention = round(rnorm(234,mean=100,sd=30),3),
    sex = rbinom(234,1,0.5),
    blueberries = abs(round(rnorm(234,mean=334,sd=100))),
    iq = round(rnorm(234,mean=110,sd=15),3),
    age = round(rnorm(234,mean=34,sd=7),3),
    sleep = round(rnorm(234,mean=7.5,sd=2),3),
    memory_score = abs(round(0.3*attention + 0.27*iq + 0.6*age + 4*sleep + rnorm(234,0,13),2)))

memory_data %>% cor()

mem_model <- lm(memory_score ~ .,data=memory_data)

memory1 <- lm(memory_score ~ iq + age,data=memory_data)
summary(memory1)

memory2 <- lm(memory_score ~ iq + age + attention + sleep,data=memory_data)
summary(memory2)

write_csv(memory_data,"memory_data.csv")
