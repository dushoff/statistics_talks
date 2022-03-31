## ----setup, include = F-------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")#, dev = "pdf")
library(MeanRarity)
library(patchwork) # amazing ggplot2 add-on for multi-panel plots
library(dplyr) # part of the tidyverse
library(ggplot2) # part of the tidyverse
library(tidyr) # part of the tidyverse
library(purrr) # part of the tidyverse
#library(tictoc) # lightweight package for convenient timing
library(furrr) # `tidyverse` and `parallel` combined


## ----simulate species abundance distributions---------------------------------

# simulate SADs for analysis
SADs_list<-map(c("lnorm", "gamma"), function(distr){
  map(c(100, 200), function(rich){
    map(c(.1,.15,.25,.5,0.75,.85), function(simp_Prop){ #simp_Prop is evenness
      fit_SAD(rich = rich, simpson = simp_Prop*(rich-1)+1, distr = distr)
    })
  })
})



## ----test estimators, eval = F------------------------------------------------
## 
## nreps <- 9999
## 
## ss_to_test <- floor(10^seq(1,3, 0.2))
## 
## flatsads <- flatten(flatten(SADs_list))
## 
## nc <- parallel::detectCores() - 1
## future::plan(strategy = "multiprocess", workers = nc)
## # options <- furrr::furrr_options(seed = TRUE)
## tic()
## compare_ests <- map_dfr(1:24, function(SAD){
##   map_dfr(-1:1, function(ell){
##    truth = as.numeric(flatsads[[SAD]][[2]][2-ell])
##    truep = flatsads[[SAD]][[3]]
##    dinfo = data.frame(t(flatsads[[SAD]][[1]]))
##   future_map_dfr(.x=1:nreps, .f=function(nrep){
##       map_dfr(ss_to_test, function(ss){
##         subsam = sample_infinite(truep, ss)
##         chaoest = Chao_Hill_abu(subsam, ell)
##         naive = rarity(subsam, ell)
##         gods = GUE(subsam, truep, ell)
##         return(bind_cols(data.frame(truth, chaoest, naive, gods, n=ss, ell, SAD), dinfo))
##       })
##     }
##     # , .options= options
##     )
##   })
## })
## toc() # 6 mins on 2.9 GHz i7 quad core processor
## # define a function for computing the root mean square
## nasum <- function(x){sum(x, na.rm =T)}
## rootms <- function(x){sqrt(nasum(((x)^2)/length(x)))}
## namean <- function(x){mean(x, na.rm =T)}
## 
## errs <- compare_ests %>%
##   group_by(ell, distribution, fitted.parameter, n, SAD) %>%
##   mutate(godsError = gods - truth
##          , naiveError = naive - truth
##          , chaoError = chaoest - truth) %>%
##   summarize_at(.vars = c("godsError", "naiveError", "chaoError"), .funs = c(rootms, namean)) %>%
##   pivot_longer(godsError_fn1:chaoError_fn2,
##     names_to = c("estimator", ".value"),
##     names_sep = "_"
##       ) %>%
##   rename(rmse = fn1, bias = fn2)


## ----plot rmse, fig.height =5, fig.width =7-----------------------------------
# data to make plot prettier
inds <- data.frame("ell" = c(1, 0, -1), divind = factor(c("richness"
                                                           , "Hill-Shannon"
                                                           , "Hill-Simpson")
                                                 , levels = c("richness"
                                                              , "Hill-Shannon"
                                                            , "Hill-Simpson")))
#plot
errs %>% 
  mutate(estimator = gsub("*Error", "", estimator)) %>%  
  left_join(inds) %>% 
  filter(SAD %in% c("8","10","12","19","22", "24")) %>%
  ggplot(aes(n, rmse, color = estimator))+
  geom_line(alpha = 0.7, size =1.5) +
  facet_grid(divind~SAD, scales = "free") +
  theme_classic()+
  theme(axis.text.x = element_text(angle = 90)) +
  labs(x = "individuals", y = "root mean squared error")
  

## ----plot bias, fig.height =5, fig.width =7-----------------------------------


errs %>% 
  mutate(estimator = gsub("*Error", "", estimator)) %>%  
  left_join(inds) %>% 
  filter(SAD %in% c("7","10","12","19","22","24")) %>%
  ggplot(aes(n, bias, color = estimator)) +
  geom_line(alpha = 0.7, size =1.5) +
  facet_grid(divind~SAD, scales = "free") +
  geom_hline(yintercept = 0) +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(x = "individuals")
  


## ----Gods estimator in the face of extreme rarity, eval =F--------------------
## #we can check out whether upping sample sizes by a factor of 100 is
## # sufficient to bring God's estimator in line, but it's pretty time consuming to
## # do this sampling, and with the extreme rarities in SAD 19 we don't actually
## # see God's estimator behaving well with sample sizes ≤1e7, so we won't do this
## # with brute force.
## # nreps <- 999
## #
## # ss_to_test <- floor(10^seq(5,7, 0.25))
## # SAD<-19
## #
## #
## # nc <- parallel::detectCores() - 1
## # future::plan(strategy = "multiprocess", workers = nc)
## # # options <- furrr::furrr_options(seed = TRUE)
## # tic()
## # God_with_microbes <- map_dfr(-1:1, function(ell){
## #    truth = as.numeric(flatsads[[SAD]][[2]][2-ell])
## #    truep = flatsads[[SAD]][[3]]
## #    dinfo = data.frame(t(flatsads[[SAD]][[1]]))
## #   future_map_dfr(.x=1:nreps, .f=function(nrep){
## #       map_dfr(ss_to_test, function(ss){
## #         subsam = sample_infinite(truep, ss)
## #         chaoest = Chao_Hill_abu(subsam, ell)
## #         naive = rarity(subsam, ell)
## #         gods = GUE(subsam, truep, ell)
## #         return(bind_cols(data.frame(truth, chaoest, naive, gods, n=ss, ell, SAD), dinfo))
## #       })
## #     }
## #     # , .options= options
## #     )
## #  })
## # toc()
## #
## # microbe_errs <- God_with_microbes %>%
## #   group_by(ell, distribution, fitted.parameter, n, SAD) %>%
## #   mutate(godsError = gods - truth
## #          , naiveError = naive - truth
## #          , chaoError = chaoest - truth) %>%
## #   summarize_at(.vars = c("godsError", "naiveError", "chaoError"), .funs = c(rootms, namean)) %>%
## #   pivot_longer(godsError_fn1:chaoError_fn2,
## #     names_to = c("estimator", ".value"),
## #     names_sep = "_"
## #       ) %>%
## #   rename(rmse = fn1, bias = fn2)
## #
## #
## # microbe_errs %>%
## #   mutate(estimator = gsub("*Error", "", estimator)) %>%
## #   left_join(inds) %>%
## #   ggplot(aes(n, rmse, color = estimator)) +
## #   geom_line(alpha = 0.7, size =1.5) +
## #   facet_grid(~divind, scales = "free") +
## #   geom_hline(yintercept = 0) +
## #   theme_classic() +
## #   theme(axis.text.x = element_text(angle = 90)) +
## #   labs(x = "individuals")
## #
## # microbe_errs %>%
## #   mutate(estimator = gsub("*Error", "", estimator)) %>%
## #   left_join(inds) %>%
## #   ggplot(aes(n, bias, color = estimator)) +
## #   geom_line(alpha = 0.7, size =1.5) +
## #   facet_grid(~divind, scales = "free") +
## #   geom_hline(yintercept = 0) +
## #   theme_classic() +
## #   theme(axis.text.x = element_text(angle = 90)) +
## #   labs(x = "individuals")

