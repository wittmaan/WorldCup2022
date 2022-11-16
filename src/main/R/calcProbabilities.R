
library(data.table)
library(dplyr)

dat <- fread("../../../data/bettingOdds20221116.csv")

calcOdds <- function(quotedOdds, delta=1) {
  (quotedOdds - 1) / delta
}

calcProbs <- function(quotedOdds, delta=1) {
  odds <- calcOdds(quotedOdds, delta)
  1 - odds / (1 + odds)
}

deltaOpt <- dat[, lapply(.SD, function(quotedOdds) {
  deltaOpt <- uniroot(function(delta) {
    sum(calcProbs(quotedOdds, delta), na.rm = TRUE) - 1
  }, interval = c(0.0001, 1.0))$root
  
  #deltaOpt <- optim(0.0001, function(delta) {
  #  (sum(calcProbs(quotedOdds, delta), na.rm = TRUE) - 1)^2
  #}, method = "Brent", lower = 0.0001, upper = 1.0)$par
  
  deltaOpt
  
}), .SDcols = 4:ncol(dat)]


probs <- lapply(colnames(deltaOpt), function(col) {
  calcProbs(dat[, col, with=FALSE], unlist(deltaOpt[, col, with=FALSE]))
}) %>% as.data.table()


logit <- function(x) log(x/(1-x))
invLogit <- function(p) { exp(p) / (1 + exp(p)) }


dat[, logOdds := rowMeans(logit(probs), na.rm = TRUE)]
dat[, probabilities := invLogit(logOdds)]

fwrite(dat[, .(code, group, logOdds, probabilities)], "../../../data/probabilites20221116.csv", sep = ";")
  

