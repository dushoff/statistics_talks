## ----setup, include = F-------------------------------------------------------
library(MeanRarity)
library(patchwork) # amazing ggplot2 add-on for multi-panel plots
library(dplyr) # part of the tidyverse
library(ggplot2) # part of the tidyverse
library(tidyr) # part of the tidyverse
library(purrr) # part of the tidyverse
#library(tictoc) # lightweight package for convenient timing
library(furrr) # `tidyverse` and `parallel` combined
library(iNEXT) # implements diversity CI recommended by Chao et al. 2014, Chao and Jost 2015


## ----RAD plot, fig.height = 5, fig.width = 5, fig.retina = 2------------------

# to make RAD plot for communities comparable, use one maxab and one maxrich for all plots
maxab <- max(sapply(beeAbunds[2:5], max)) # the maximum observed species abundance in any community

maxrich <- max(sapply(beeAbunds[2:5], function(x){sum(x > 0)})) # maximum observed richness


myplots <- purrr::map(2:5, function(makedatind){
    radplot(beeAbunds[,makedatind], maxab = maxab, maxrich = maxrich
            , shape = 13 + makedatind # solid filled shapes
            , size = 1.5
            , fill = c("#1b9e77", "#d95f02", "#7570b3", "#e7298a")[makedatind - 1]) +
    ggplot2::labs(title = ggplot2::element_blank()) +
    ggplot2::theme(text = ggplot2::element_text(size = 14)
                   , axis.text = ggplot2::element_text(colour = "black"))
})


myplots[[1]] + # first community
  ggplot2::labs(x = "") +# syling
white_y(myplots[[3]]) + # second community 
  ggplot2::labs(x = "") + # styling
myplots[[2]] +  # third community
white_y(myplots[[4]]) # fourth community
  



## ----Compute mean diveristy estimates under rarefaction, eval = F-------------
## 
## # this takes a long time to run so we're going to stash it but export the data it creates
## 
## sz<-1:745 #sample sizes from 1 to maximum observed total abundance at a site
## nrep<-200 #Large enough because estimating means
## 
## #tictoc::tic() #time this
## nc <- parallel::detectCores() - 1 #nc is number of cores to use in parallel processing
## future::plan(strategy = future::multiprocess, workers = nc) #this sets up the cluster
## 
## 
## div_ests <- purrr::map_dfr(1:nrep, function(k){
##  furrr::future_map_dfr(sz, function(x){
##     map(2:length(beeAbunds), function(sitio){
##       f<-beeAbunds %>% dplyr::select(all_of(sitio))
##       if(sum(f) > x){
##         comm = dplyr::pull(f) %>% subsam(size = x)
##         return(data.frame(obs_est(comm)
##                      , site = names(f)))
##       }
##     })
##   })
## })
## 
## #tictoc::toc() #507 seconds with quad-core i7 processor, not bad.
## mean_narm <- function(x){mean(x, na.rm = T)}
## mean_ests <- div_ests %>%
##   dplyr::group_by(site, individuals) %>%
##   dplyr::summarize_all(mean_narm)


## ----Species Accumulation Curves, fig.width = 5, fig.height = 5---------------

site_ab <- purrr::map_dfr(names(beeAbunds[,2:5]), function(site){
  data.frame(site, abun = sum(beeAbunds[,site]))
})

mean_ests %>%
  dplyr::left_join(site_ab) %>% 
  dplyr::mutate(cutrows = individuals > 0.8 * abun) %>%
  #truncate the dataset because literal bootstrapping gets funny and  the Chao1
  #levels off near observed abundance, didn't want to discuss this in guide
  #since it's obvious but not interesting and possibly very confusing.
  dplyr::filter(!cutrows) %>% 
  ggplot2::ggplot(aes(individuals, obsrich, color = site))+
  ggplot2::geom_point(alpha = 0.3, size = 0.5) +
  ggplot2::geom_point(aes(y = chaorich, color = site, shape = site)
             , size=0.8, alpha=0.5) +
  ggplot2::theme_classic() +
  ggplot2::labs(x = "\nIndividuals", y = "Species richness\n") +
  ggplot2::xlim(c(0, 400)) +
  ggplot2::ylim(c(0, 80)) +
  ggplot2::theme(text = ggplot2::element_text(size=14)
        , axis.text = ggplot2::element_text(colour = "black")) +
  ggplot2::theme(legend.position = "none") +
  ggplot2::scale_shape_manual(values = c(15:18)) +
  ggplot2::scale_color_brewer(palette = "Dark2")




## ----Diversity profile plot, fig.width = 5, fig.height = 5--------------------

site_pro <- purrr::map_dfr(names(beeAbunds[2:5]), function(x){
  data.frame(site = x, divpro(beeAbunds[, x]))}) #make profile for each community

site_pro %>%  ggplot2::ggplot(aes(ell, d, color = site)) +
    ggplot2::geom_line() +
    ggplot2::geom_point(data = site_pro %>% 
                          dplyr::filter(ell %in% c(-1,1,0))
               , aes(ell, d, color = site, shape = site)
               , size = 3, alpha = 0.5) +
    ggplot2::theme_classic() +
    ggplot2::theme(text = ggplot2::element_text(size = 14)
          , axis.text = ggplot2::element_text(colour = "black")
          , legend.position = "none") +
    #this is the unicode for the curly l
    ggplot2::labs(x = "Exponent \U2113", y = "Diversity") +
    ggplot2::scale_shape_manual(values = c(15:18)) +
    ggplot2::scale_color_brewer(palette = "Dark2")


## ----Figure 4: diversity estimates with CI, fig.height = 5, fig.width = 7, eval = TRUE----

#tictoc::tic() #time this

iN_form <- as.list(beeAbunds[, -1])
by_size <- iNEXT::estimateD(iN_form
                                , base = "size")

by_coverage <- iNEXT::estimateD(iN_form
                                , base = "coverage")

by_effort <- purrr::map_dfr(lapply(iN_form, sum), function(size){
    iNEXT::estimateD(iN_form
                    , base = "size"
                    , level = size) %>% dplyr::filter(method == "observed")

})
    
iseveral <- dplyr::bind_rows(size = by_size
                             , coverage = by_coverage
                             , effort = by_effort
                             , .id = "standard") %>%
  dplyr::mutate(order = 1 - order)
                   
#tictoc::toc()  #43 sec this time!?!?!

#tictoc::tic()
asyseveral <- purrr::map_dfr(2:5, function(sitio){
  purrr::map_dfr(-1:1, function(l){
    theboots <- MeanRarity:::Bootstrap.CI_df(pull(beeAbunds[, sitio]), l)
    est <- Chao_Hill_abu(dplyr::pull(beeAbunds[, sitio]), l)
    data.frame(site = names(beeAbunds[, sitio])
               , order = l
               , qD = est
               , qD.LCL = est - theboots[2]
               , qD.UCL = est + theboots[4])
  })
})
#tictoc::toc() # <2 seconds.

asyseveral$method <- "asymptotic"
asyseveral$standard <- "asymptotic"
allseveral <- dplyr::bind_rows(iseveral, asyseveral)
#diversities, standardized by effort

#get some parameters of data
#individuals in sample with fewest
minm <- min(by_effort %>% 
              dplyr::filter(m == min(m)) %>% 
              dplyr::pull(m)) 

minc <- min(by_effort %>% 
              dplyr::group_by(site) %>% 
              dplyr::summarize(SC = max(SC)) %>% 
              dplyr::pull(SC)) # coverage of sample with lowest


tog <- allseveral %>% 
  dplyr::mutate(sm = paste(standard, site, sep=""))

inds <- data.frame("order" = c(1, 0, -1), divind = factor(c("richness"
                                                           , "Hill-Shannon"
                                                           , "Hill-Simpson")
                                                 , levels = c("richness"
                                                              , "Hill-Shannon"
                                                              , "Hill-Simpson")))

togn <- tog %>% 
  dplyr::left_join(inds) %>%  
  dplyr::ungroup()

togn <- togn %>%     
  dplyr::mutate(divind = factor(divind
                         , levels = c("richness"
                                      , "Hill-Shannon"
                                      , "Hill-Simpson"))
          , site = factor(site
                          , levels = c("IAS_3"
                                     , "Cold Soil_5"
                                     , "Lord Stirling_4"
                                     , "Fox Hill_5")))
togn <- togn %>% 
  dplyr::mutate(methlab = factor(standard
                          , levels = c("effort"
                                       , "size"
                                       , "coverage"
                                       , "asymptotic")
                           , labels = c("effort (14 transects)"
                                        , "size (255 individuals)"
                                        , "coverage (95.7%)"
                                        , "asymptotic")))
ebsize<-0.6
ebw<-0.4
psize<-2.5

############################
# make figures, which get stuck together.
leftPlot <- togn %>% 
    dplyr::filter(methlab != "asymptotic") %>% 
    ggplot2::ggplot(aes(site, qD, color = site, shape = site)) +
    ggplot2::geom_errorbar(aes(ymin = qD.LCL, ymax = qD.UCL)
                  , size = ebsize, width = ebw) +
    ggplot2::geom_point(size = psize) +
    ggplot2::facet_grid(divind ~ methlab, switch = "y", scales = "free_y") +
    ggplot2::theme_classic() +
    ggplot2::theme(legend.position = "none", axis.text.x = ggplot2::element_blank()
          , axis.ticks.x = ggplot2::element_blank()) +
    ggplot2::labs(y = NULL) +
    ggplot2::theme(panel.spacing = unit(0, "lines")
          , panel.border = ggplot2::element_rect(fill = NA)
          , strip.background = ggplot2::element_blank()
          , strip.text = ggplot2::element_text(face = "bold", size = 10)
          , axis.title.x = ggplot2::element_blank()
          , legend.position = "none"
          , strip.placement = "outside") +
    ggplot2::scale_y_continuous(limits = c(0,NA)
                       , expand = ggplot2::expand_scale(mult = c(0, .05))) +
    ggplot2::scale_shape_manual(values = c(17, 15, 18, 16)) +
    ggplot2::scale_color_manual(values = c("#7570b3"
                                , "#1b9e77"
                                , "#e7298a"
                                , "#d95f02")) 
rightPlot <- togn %>% 
  dplyr::filter(methlab == "asymptotic") %>% 
  ggplot2::ggplot(ggplot2::aes(site, qD, color = site, shape = site)) +
  ggplot2::geom_errorbar(ggplot2::aes(ymin = qD.LCL, ymax = qD.UCL)
                         , size = ebsize, width = ebw) +
  ggplot2::geom_point(size = psize) +
  ggplot2::facet_grid(divind~methlab, switch = "y", scales = "free_y") +
  ggplot2::theme_classic() +
  ggplot2::theme(legend.position = "none"
                 , axis.text.x = ggplot2::element_blank()
                 , axis.ticks.x = ggplot2::element_blank()) +
  ggplot2::labs(y = NULL, x = NULL) +
  ggplot2::theme(panel.spacing = unit(0, "lines"),
        panel.border = ggplot2::element_rect(fill = NA),
        strip.background = ggplot2::element_blank(),
        strip.text.x = ggplot2::element_text(face = "bold", size = 10),
        strip.text.y = ggplot2::element_blank(),
        axis.title = ggplot2::element_blank(),
        legend.position = "none",
        strip.placement = "outside") +
  ggplot2::scale_y_continuous(limits = c(0, NA)
                     , expand = ggplot2::expand_scale(mult = c(0, 0.05))) +
  ggplot2::scale_shape_manual(values = c(17, 15, 18, 16)) +
  ggplot2::scale_color_manual(values = c("#7570b3"
                              , "#1b9e77"
                              , "#e7298a"
                              , "#d95f02" ))


leftPlot + rightPlot + plot_layout(widths = c(3, 1))



## ----Fig 5: Effort-based Rarefaction, warning = F, eval = F-------------------
## # this takes a long time to run so we're going to stash it but export the data
## # in the package
## 
## # the idea here is to sample from 14 30-minute sampling bouts from each site and
## # compare coverage. While we resample 30-minute transects, we compute the
## # estimated sample coverage and count individuals in each subsample. We use this
## # to compare standardization methods.
## 
## maxeff <- 14
## reps <- 9999
## #tictoc::tic() #time this
## nc <- parallel::detectCores() - 1 #nc is number of cores to use in parallel processing
## future::plan(strategy = future::multiprocess, workers = nc) #this sets up the cluster
## 
## show_ests <- furrr::future_map_dfr(1:reps, function(x){
##   purrr::map_dfr(1:maxeff, function(i){
##     sam <- beeObs %>%
##       dplyr::group_by(sr) %>%
##       dplyr::do(filter(., start %in%
##                          sample(unique(.$start)
##                                 , size = maxeff - i + 1
##                                 , replace = F)))
##     subcom <- sam %>% dplyr::group_by(bee, sr) %>%
##       dplyr::summarize(abund = n()) %>%
##       tidyr::spread(key = sr
##                     , value = abund
##                     , fill = 0) %>%
##       as.data.frame()
##     basicdat <- purrr::map_dfr(apply(subcom[, -1], MARGIN = 2, obs_est), rbind)
##     return(data.frame(basicdat, site = names(subcom[, -1]), transects = maxeff - i + 1))
##   })
## })
## 
## #tictoc::toc() #Under 2 hours with only 4 cores
## 
## effort_means <- show_ests %>%
##   dplyr::group_by(site, transects) %>%
##   dplyr::summarize_at(.vars = c("n"
##                               , "coverage"
##                               , "obsrich"
##                               , "chaorich"
##                               , "obsshan"
##                               , "chaoshan"
##                               , "obssimp"
##                               , "chaosimp"), .funs = mean)
## 
## 
## #gather to make a prettier plot, will need to get fancy now that there's asy also
## effort_rare <- effort_means %>% dplyr::rename(
##   "richness_observed" = obsrich
##   , "richness_asymptotic" = chaorich
##   , "Hill-Shannon_observed" = obsshan
##   , "Hill-Shannon_asymptotic" = chaoshan
##   , "Hill-Simpson_observed" = obssimp
##   , "Hill-Simpson_asymptotic" = chaosimp
##   , size = n
##   , effort = transects) %>%
##   tidyr::gather(key = "ell"
##                 , value = "diversity"
##                 , "richness_observed"
##                 , "richness_asymptotic"
##                 , "Hill-Shannon_observed"
##                 , "Hill-Shannon_asymptotic"
##                 , "Hill-Simpson_observed"
##                 , "Hill-Simpson_asymptotic") %>%
##   tidyr::gather(key = method
##                 , value =xax
##                 , effort
##                 , size
##                 , coverage) %>%
##   tidyr::separate(ell, c("divind", "etype"), sep = "_")
## 
## effort_rare$divind <- factor(effort_rare$divind
##                           , levels = c("richness"
##                                        , "Hill-Shannon"
##                                        , "Hill-Simpson")
##                           , labels = c("richness"
##                                      , "Hill-Shannon"
##                                      , "Hill-Simpson"))
## effort_rare$method <- factor(effort_rare$method
##                           , levels = c("effort"
##                                      , "size"
##                                      , "coverage"))
## effort_rare$etype <- factor(effort_rare$etype
##                          , levels = c("observed"
##                                       , "asymptotic"))
## 
## 


## ----Fig 5 rarefaction, fig.width =7, fig.height = 7--------------------------

effort_rare %>% 
  dplyr::filter(etype == "observed") %>% 
  ggplot2::ggplot(aes(xax
             , diversity
             , color = site
             , shape = site)) +
  ggplot2::geom_point(size = 2) +
  ggplot2::geom_line() +
  ggplot2::theme_classic() +
  ggplot2::scale_alpha(range=c(0.4, 0.8)) +
  ggplot2::theme( legend.position = "none"
         , axis.text = ggplot2::element_text(colour = "black")
         , axis.title.y = ggplot2::element_text(size = 14)
         , panel.spacing = unit(1.3, "lines")
         , strip.placement.y = "outside") +
  ggplot2::labs(x = "    transects                            individuals                             % coverage    "
       , y = "diversity") +
  ggplot2::facet_grid(divind ~ method, scales = "free", switch = "y") +
  ggplot2::expand_limits(y = 0) +
  ggplot2::scale_shape_manual(values = c(15:18)) +
  ggplot2::scale_color_brewer(palette = "Dark2") + 
  ggplot2::scale_y_log10()


## ----Appendix C rarefaction with estimators , fig.width = 7, fig.height = 5----
effort_rare %>% 
  ggplot2::ggplot(ggplot2::aes(xax, diversity, color = site, shape = site)) +
  ggplot2::geom_line(ggplot2::aes(alpha = etype), size = 1) +
  ggplot2::theme_classic() +
  ggplot2::scale_alpha(range = c(0.4, 0.8)) +
  ggplot2::theme( legend.position = "none"
         , axis.text = ggplot2::element_text(colour = "black")
         , axis.title.y = ggplot2::element_text(size = 14)
         , panel.spacing = unit(0.3, "lines")
         , strip.placement.y = "outside") +
  # shoudl fix the spacing between x-axis labels
  ggplot2::labs(x = "    transects                                     individuals                                     % coverage    "
       , y = "diversity") +
  ggplot2::facet_grid(divind ~ method + etype, scales = "free", switch = "y") +
  ggplot2::expand_limits(y = 0) +
  ggplot2::scale_color_brewer(palette = "Dark2") + 
  ggplot2::scale_y_log10() +
  ggplot2::scale_alpha_manual(values = c(1, 0.6))


## ----Balance plot, fig.width = 9, fig.height = 3------------------------------

# plot some rarity "balance plots" for guide to measuring diversity (Roswell et al. 2021 http://onlinelibrary.wiley.com/doi/10.1111/oik.07202/abstract)
ab <- c(20,8,5,4,2,1)

rich_bal <- rarity_plot(ab, 1, base_size = 12) +
  ggplot2::labs(x = "") +
  scale_color_brewer(type = "qual", palette = "Dark2") 

shan_bal <- white_y(rarity_plot(ab, 0, base_size = 12, verbose = F)) + #do not return all the text this time
  scale_color_brewer(type = "qual", palette = "Dark2")

simp_bal <- white_y(rarity_plot(ab, -1, base_size = 12, verbose = F)) + 
  ggplot2::labs(x = "") +
  scale_color_brewer(type = "qual", palette = "Dark2")

#assemble triptych with patchwork
rich_bal +
  shan_bal +
  simp_bal





## ----simulate species abundance distributions---------------------------------

# simulate SADs for analysis
SADs_list<-map(c("lnorm", "gamma"), function(distr){
  map(c(100, 200), function(rich){
    map(c(0.05, .15,.25,.5,.75,.85), function(simp_Prop){ #simp_Prop is evenness
      fit_SAD(rich = rich, simpson = simp_Prop*(rich-1)+1, distr = distr)
    })
  })
})


## ----visualize SADs, fig.width = 7, fig.height = 5----------------------------
# function to remove subscripts; apparently this way of making a labeller is now
# deprecated
remsub <- function(variable, value){
  return(gsub("_"," ",value))}

#function to summarize frequencies
asab<-function(namevec){as.numeric(table(namevec))}

# make rank abundance distributions
myabs<-map_dfr(flatten(flatten(SADs_list)) #, function(x) data.frame(names(x)))
               , function(x){data.frame(ab=x$rel_abundances)}
               , .id="SAD")


myabs %>% dplyr::left_join(data.frame(
  SAD=as.character(1:24)
  , skew=factor(c("uneven", "int","int", "int","int", "even"), levels=c("uneven", "int", "even"))
  , dist=factor(c(rep("lognormal", 12), rep("gamma", 12)), levels=c("lognormal", "gamma"))
)) %>%
  dplyr::mutate(abD=paste(dist, skew)) %>%
  dplyr::group_by(SAD, abD, dist, skew) %>%
  dplyr::mutate(abrank = dplyr::min_rank(desc(ab))
                , log_relative_abundance = log(ab)
                , relative_abundance = ab) %>%
  #for plotting, gather the two scales to use `facet_grid`
  tidyr::gather(scl, rel_abund, relative_abundance, log_relative_abundance )%>%
  # grab the extreme SADs and one intermediate for each distributional
  # assumption, just the 200 spp versions (they look the same though)
  dplyr::filter(SAD %in% c("7","10","12","19","22","24")) %>%
  # plot the RADs to show difference between gamma and lognormal, more extreme
  # with skew
  ggplot2::ggplot(aes(abrank, rel_abund, color=dist))+
    ggplot2::geom_point(alpha=0.3, size=1)+
    ggplot2::geom_line(size=.4, alpha=0.3)+
    ggplot2::theme_classic()+
    # theme(text=element_text(size=16))+
    ggplot2::labs(x="abundance rank", y="", color="", shape="")+
      ggplot2::facet_grid(forcats::fct_rev(scl)~skew, scales="free", switch="y", labeller=remsub)

