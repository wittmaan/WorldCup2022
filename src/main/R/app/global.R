


library(DT)
library(dplyr)
library(d3heatmap)
library(shiny)
library(rCharts)
library(data.table)

options(RCHART_WIDTH = 800)

logit <- function(x) log(x/(1-x))

datOdds <- fread("bettingOdds20221116.csv")
datOdds <- datOdds[order(`Bet365`)]

teamResult <- fread("teamResults20221116.csv")

groupStageResult <- fread("groupStageResult20221116.csv")
knockoutStageResult <- fread("knockoutStageResult20221116.csv")

datResult <- teamResult[datOdds, on = c("code", "group")]
datResult[, probability := round(pWinning*100.0, digits=4)]
datResult[, "log-odds" := round(logit(pWinning), digits=4)]
datResult[, "log-ability" := round(log(ability), digits=4)]
datResult <- datResult[, .(team, code, probability, `log-odds`, `log-ability`, group)][order(-probability)]

groupStageResult[, p := round(p * 100.0, digits = 4)]


calcProb <- function(abilityA, abilityB) {
  return (abilityA / (abilityA + abilityB))
}

tmp <- teamResult[order(-ability)]

mat1 <- matrix(NA, nrow=nrow(tmp), ncol=nrow(tmp), dimnames=list(tmp$code, tmp$code))

for (i in 1:nrow(tmp)) {
  for (j in 1:nrow(tmp)) {
    mat1[i,j] <- calcProb(abilityA = tmp$ability[i], abilityB = tmp$ability[j])
  }
}


teamResult$pWinning <- round(teamResult$pWinning * 100.0, digits = 4)
teamResult$pFinalist <- round(teamResult$pFinalist * 100.0, digits = 4)
teamResult$pSemiFinalist <- round(teamResult$pSemiFinalist * 100.0, digits = 4)
teamResult$pQuarterFinalist <- round(teamResult$pQuarterFinalist * 100.0, digits = 4)
teamResult$pRoundOfSixteen <- round(teamResult$pRoundOfSixteen * 100.0, digits = 4)
