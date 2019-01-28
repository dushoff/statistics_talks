library(readr)
library(dplyr)

smoke <- (read_csv("fev.csv")
	%>% rename(smoking=smoke)
	%>% print()
)
