library(readr)
library(dplyr)

bike_weather <- read_csv("bike_weather.csv")

bikes <- ( read_csv("hour.csv")
	%>% left_join(bike_weather)
	%>% rename(rentals=cnt)
   %>% mutate(weather=reorder(weather,weathersit))
)

print(table(bikes$rentals))
