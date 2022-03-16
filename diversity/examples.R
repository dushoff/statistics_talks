library(RColorBrewer)
library(ggplot2); theme_set(theme_bw())

library(shellpipes)
startGraphics()
loadEnvironments()

set.seed(605)

print(pieStats(powPop(5, 1)))
print(pieStats(powPop(8,1)))

print(pieStats(powPop(7,1.6)))
print(pieStats(powPop(7, 0.8)))

print(pieStats(powPop(9,1.18)))

print(pieStats(powPop(9,0.9)))

