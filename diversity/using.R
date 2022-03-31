## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE
  , comment = "#>"
  , dev = "ragg_png"
)

## ----setup, include =F--------------------------------------------------------
library(MeanRarity)


## ----compute rarity-----------------------------------------------------------
# for a totally even distribution, Hill diversity is the same regardless of `l`

even_comm <- rep(2, 6)
rarity(even_comm, 1) # richness
rarity(even_comm, -1) # Hill-Simpson

all.equal(rarity(even_comm, 0), rarity(even_comm, 0.34), rarity(even_comm, 1))

# for uneven communities, Hill diversity depends on `l`

uneven_comm <- c(20, 8, 5, 4, 2, 1)

l_vals <- c(1, 0, -1, 0.34)


data.frame(l = l_vals
           , Hill = sapply(l_vals, function(l){
                    rarity(uneven_comm, l)})
)



## ----effective numbers--------------------------------------------------------
uneven_12 <- c(531, 186, 101,  63, 41, 28, 19, 13, 9, 5, 3, 1)
even_3 <- c(20, 20, 20)

rarity(uneven_comm, -1) %>% round(2)
rarity(uneven_12, -1) %>% round(2)
rarity(even_3, -1) %>% round(2)



## ----Balance plot setup-------------------------------------------------------

rich_bal <- rarity_plot(ab = uneven_comm, l = 1, base_size = 12) +
  ggplot2::labs(x = "") +
  ggplot2::labs(title = "\u2113 = 1\n richness") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.6
                                                    , vjust = 0.5
                                                    # , family = "Arial Unicode MS"
                                                    )
                 ) + 
  ggplot2::scale_color_brewer(type = "qual", palette = "Dark2")

shan_bal <- white_y( # hide y axis
  rarity_plot(ab = uneven_comm
              , l = 0
              , base_size = 12
              , verbose = F)) +
    ggplot2::labs(title = "\u2113 = 0\nHill-Shannon diversity") +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.6
                                                    , vjust = 0.5
                                                    # , family = "Arial Unicode MS"
                                                    )
                 ) + 
    ggplot2::scale_color_brewer(type = "qual", palette = "Dark2")

simp_bal <- white_y(
  rarity_plot(ab = uneven_comm
              , l = -1
              , base_size = 12
              , verbose = F)) +
  ggplot2::labs(title = "\u2113 = -1\nHill-Simpson diversity") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.6
                                                    , vjust = 0.5
                                                    # , family = "Arial Unicode MS"
                                                    )
                 ) +
  ggplot2::labs(x = "") +
  ggplot2::scale_color_brewer(type = "qual", palette = "Dark2")


## ----Balance plot print, out.width = '33%', out.height = '33%', fig.show = "hold"----
rich_bal
shan_bal
simp_bal



## ----fit species abundance distributions--------------------------------------
# set target richness and Hill-Simpson diversity levels
rich <- 20
simpson <- 12
even_SAD <- fit_SAD(rich = rich, simpson = simpson, distr = "lnorm")

#output is a list with three elements
even_SAD

rich <- 20
simpson <- 6
uneven_SAD <- fit_SAD(rich = rich, simpson = simpson, distr = "lnorm")



ev<-radplot(even_SAD$rel_abundances) +
  ggplot2::labs(y = "relative abundance", title =NULL)+
  ggplot2::ylim(c(0, 0.4))
un<-radplot(uneven_SAD$rel_abundances) +
  ggplot2::labs(y = "relative abundance", title =NULL) +
  ggplot2::ylim(c(0, 0.4))

## ----plot radplots, fig.width = 3, fig.height =3, fig.show = "hold"-----------
ev
un


## ----sample from SAD----------------------------------------------------------

# diversity of a small sample unlikely to match the simulated diversity values

# first, sample from our simulated SADs

even_sample <- sample_infinite(even_SAD$rel_abundances, 50)
uneven_sample <- sample_infinite(uneven_SAD$rel_abundances, 50)
#sample_infinite returns a numeric vector of sample species abundances
even_sample
uneven_sample

# we can compare evenness (given a scaling parameter `l`)
# the evenness is the normalized ratio of an arbitrary Hill diversity to richness
e3Fun(even_sample, -1)
e3Fun(uneven_sample, -1)

# compare diversity from sample vs. ideal SAD:
# likely pretty far off for a small sample!

# with an even SAD, all diversities lower
even_SAD$community_info
rbind(lapply(c(1, 0, -1), function(l){
  rarity(even_sample, l)
}))

# with an uneven SAD, sample Hill-Simpson can be higher than true Hill-Simpson
# richness is always lower
uneven_SAD$community_info
rbind(lapply(c(1, 0, -1), function(l){
  rarity(uneven_sample, l)
}))


big_even_sample <- sample_infinite(even_SAD$rel_abundances, 1e7)
big_uneven_sample <- sample_infinite(uneven_SAD$rel_abundances, 1e7)

# with a big enough sample, simulated diversities nearly recovered
even_SAD$community_info
rbind(lapply(c(1, 0, -1), function(l){
  rarity(big_even_sample, l)
}))


## ----diversity profile--------------------------------------------------------
# the even and uneven communities have same richness but different Hill 
# diversity when `ell != 1`
ggplot2::ggplot(divpro(even_SAD[[3]]),
                ggplot2::aes(ell, d)) +
  ggplot2::geom_line() +
  ggplot2::ylim(0,22) +
  ggplot2::theme_classic() +
  ggplot2::labs(x = "scaling exponent \'l\'", y = "Hill diversity")

ggplot2::ggplot(divpro(uneven_SAD[[3]]),
                ggplot2::aes(ell, d)) +
  ggplot2::geom_line() +
    ggplot2::ylim(0,22) +
  ggplot2::theme_classic() +
  ggplot2::labs(x = "scaling exponent \'l\'", y = "Hill diversity")





## ----bias figure , fig.height = 7, fig.width = 7------------------------------

# ratio scale
purrr::map(c("lnorm", "gamma", "invgamma"), function(dist){
   myp<-err_plot_data %>% 
    dplyr::mutate(naive_sdlog = sample_sdlog) %>% 
    tidyr::pivot_longer(c(5:12, 16)
                 , names_to = c("est", "err_type")
                 , names_pattern = "(.*)_(.*)"
                 , values_to = "this_error"
    ) %>% 
    dplyr::mutate(err_type = factor(err_type
                                    , levels = c("rmsle", "sdlog", "bias")
                                    , labels = c("Average proportional error"
                     , "Proportional \nVariability"
                     , "Proportional Bias")
                                    )
                  , est = dplyr::if_else(est == "estimator", "asymptotic"
                                , dplyr::if_else(est == "naive"
                                                 , "naïve"
                                                 , "sample"))
                  ) %>% 
    dplyr::mutate(this_error = dplyr::if_else(abs(this_error) > 2
                                              , sign(this_error)*Inf
                                              , this_error)) %>% 
     dplyr::filter(distribution == dist # "gamma"
                   ) %>% 
    ggplot2::ggplot(ggplot2::aes(x = ell
                                 , color = evenness)) +
    ggplot2::geom_line(ggplot2::aes(y = this_error
      , linetype = est), size = 0.8) +
    ggplot2::theme_classic() +
    ggplot2::theme(strip.background = ggplot2::element_blank()
                   , strip.placement.y = "outside"
                   , panel.spacing.x = ggplot2::unit(1.3, "lines")
                   , panel.spacing.y = ggplot2::unit(1.3, "lines")
                   , legend.key.width = ggplot2::unit(2, "lines")
                   )+
    ggplot2::scale_x_continuous(limits = c(-1,1)
                                ) +
    ggplot2::scale_y_continuous(labels = function(x){str2expression(print_operator(x))}
                        , breaks = rat_breaks()) + 
    ggplot2::scale_color_manual(values = hcl.colors(4
                                                    , palette = "SunsetDark")[1:3]
                                ) +
    ggplot2::scale_linetype_manual(values = c("solid", "dashed", "dotted"))+
    ggplot2::facet_grid(err_type~sample_size
                        , labeller = ggplot2::labeller(sample_size = ggplot2::label_both
                                              , err_type = ggplot2::label_value
                                              )
                        , scales = "free_y"
                        , space = "free_y"
                        , switch = "y"
                        ) +  
      ggplot2::labs(x = "scaling exponent \U2113"
                  , y = ""
                  , linetype = "estimator"
                    ) +
      ggplot2::geom_hline(yintercept = 0, size = 0.2)
  print(myp)
})

# #centinel scale
# purrr::map(c("lnorm", "gamma", "invgamma"), function(dist){
#   myp<-err_plot_data %>% 
#     dplyr::mutate(naive_sdlog = sample_sdlog) %>% 
#     tidyr::pivot_longer(c(5:12, 16)
#                  , names_to = c("est", "err_type")
#                  , names_pattern = "(.*)_(.*)"
#                  , values_to = "this_error"
#     ) %>% 
#     dplyr::mutate(err_type = factor(err_type
#                                     , levels = c("rmsle", "sdlog", "bias")
#                                     , labels = c("Average proportional error"
#                      , "Proportional \nVariability"
#                      , "Proportional Bias")
#                                     )
#                   , est = dplyr::if_else(est == "estimator", "asymptotic"
#                                 , dplyr::if_else(est == "naive"
#                                                  , "naïve"
#                                                  , "sample"))
#                   ) %>% 
#     dplyr::mutate(this_error = dplyr::if_else(abs(this_error) > 2
#                                               , sign(this_error)*Inf
#                                               , this_error)) %>% 
#      dplyr::filter(distribution == dist # "gamma"
#                    ) %>% 
#     ggplot2::ggplot(ggplot2::aes(x = ell
#                                  , color = evenness)) +
#     ggplot2::geom_line(ggplot2::aes(y = 100*this_error
#       , linetype = est), size = 0.8) +
#     ggplot2::theme_classic() +
#     ggplot2::theme(strip.background = ggplot2::element_blank()
#                    , strip.placement.y = "outside"
#                    , panel.spacing.x = ggplot2::unit(1.3, "lines")
#                    , panel.spacing.y = ggplot2::unit(1.3, "lines")
#                    , legend.key.width = ggplot2::unit(2, "lines")
#                    )+
#     ggplot2::scale_x_continuous(limits = c(-1,1)
#                                 ) +
#     ggplot2::scale_color_manual(values = hcl.colors(4
#                                                     , palette = "SunsetDark")[1:3]
#                                 ) +
#     ggplot2::scale_linetype_manual(values = c("solid", "dashed", "dotted"))+
#     ggplot2::facet_grid(err_type~sample_size
#                         , labeller = ggplot2::labeller(sample_size = ggplot2::label_both
#                                               , err_type = ggplot2::label_value
#                                               )
#                         , scales = "free_y"
#                         , space = "free_y"
#                         , switch = "y"
#                         ) +  
#       ggplot2::labs(x = "scaling exponent \U2113"
#                   , y = ""
#                   , linetype = "estimator"
#                     ) +
#       ggplot2::geom_hline(yintercept = 0, size = 0.2)
# })


## ----sidenote on when naive beats asymptotic----------------------------------

# occam <- err_plot_data %>% 
#   dplyr::group_by(evenness, distribution, ell, sample_size) %>% 
#   dplyr::summarize(total = estimator_rmsle > naive_rmsle
#             , bias = abs(estimator_bias) > abs(naive_bias)
#             , variability = estimator_sdlog > sample_sdlog)
# 
# 
# occam %>% 
#   dplyr::filter(total %in% c(TRUE, FALSE)) %>% 
#   ggplot2::ggplot(ggplot2::aes(total, ell, color = as.factor(sample_size), shape = distribution ))+
#   ggplot2::geom_jitter(height = 0, width = 0.4)+
#   ggplot2::scale_color_manual(values = hcl.colors(4, "Plasma")) +
#   ggplot2::facet_wrap(~evenness)+
#   ggplot2::labs(x = "naive estimator beats Chao (rmsle)")+
#   ggplot2::ylim(c(-1, 1))+
#   ggplot2::theme_classic()
# 
# 
# occam %>% 
#   dplyr::filter(bias %in% c(TRUE, FALSE)) %>% 
#   ggplot2::ggplot(ggplot2::aes(bias, ell, color = as.factor(sample_size), shape = distribution ))+
#   ggplot2::geom_jitter(height = 0, width = 0.4)+
#   ggplot2::scale_color_manual(values = hcl.colors(4, "Plasma")) +
#   ggplot2::facet_wrap(~evenness)+
#   ggplot2::labs(x = "naive estimator beats Chao (log accuracy ratio)")+
#   ggplot2::ylim(c(-1, 1))+
#   ggplot2::theme_classic()
# 
# occam %>% 
#   dplyr::filter(variability %in% c(TRUE, FALSE)) %>% 
#   ggplot2::ggplot(ggplot2::aes(variability, ell, color = as.factor(sample_size), shape = distribution ))+
#   ggplot2::geom_jitter(height = 0, width = 0.4)+
#   ggplot2::scale_color_manual(values = hcl.colors(4, "Plasma")) +
#   ggplot2::facet_wrap(~evenness)+
#   ggplot2::labs(x = "naive estimator beats Chao (sdlog)")+
#   ggplot2::ylim(c(-1, 1))+
#   ggplot2::theme_classic()



## ----sampling variation in diversity estimates, fig.height = 7, fig.width = 7----




## ----table of functions-------------------------------------------------------
table_dat<-data.frame(
  `Function name` = c("rarity", "rarity_plot", "radplot", "divpro", "sample_infinite", "sample_finite", "fit_SAD")
  , `General purpose` = c("Computation", "Visualization", "Visualization", "Visualization", "Sampling", "Sampling", "Simulation")
  , `Description` = c("Compute Hill diversity using the rarity parameterization")
)

