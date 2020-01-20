# see https://stackoverflow.com/questions/26705554/extend-geom-smooth-in-a-single-direction
lm_left <- function(formula,data,...){
  mod <- lm(formula,data)
  class(mod) <- c('lm_left',class(mod))
  mod
}

predictdf.lm_left <-
  function(model, xseq, se, level){
  init_range = range(model$model$x)
    ## here the main code: truncate to x values at the left
    xseq <- xseq[xseq <=init_range[2]]
    ggplot2:::predictdf.default(model, xseq[-length(xseq)], se, level)
}
