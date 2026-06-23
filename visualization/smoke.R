library(shellpipes)

library(readr)
library(dplyr)

rdsSave(read_csv("git_push/fev.csv", comment="#") %>% rename(smoking=smoke))


