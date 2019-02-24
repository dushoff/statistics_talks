library(readr)
library(dplyr)

smoke <- read_csv("fev.csv", comment="#") %>% rename(smoking=smoke)
