
library(rvest)
library(data.table)
library(textclean)
library(stringr)
library(RSelenium)
library(stringi)

## read group data stuff

result <- fread("../../../data/fifa_wc_groups_teams.csv")

## fetch betting odds

system('docker run -d -p 4445:4444 selenium/standalone-firefox')

remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "firefox")
Sys.sleep(5)
remDr$open()
remDr$navigate("https://www.oddschecker.com/football/world-cup/winner")

dataRaw <- read_html(remDr$getPageSource()[[1]]) %>% 
  html_nodes(xpath = "//*[(@id = 'oddsTableContainer')]") 

remDr$close()
system("docker stop $(docker ps -a -q)")
system("docker rm $(docker ps -a -q)")


dataRawOdds <- dataRaw %>%
  html_nodes(xpath = "table") %>%
  html_table() %>%
  as.data.table() 

dataProvider <- dataRaw %>% 
  html_nodes(xpath = "//*[contains(concat( ' ', @class, ' ' ), concat( ' ', 'bk-logo-click', ' ' ))]") %>%
  html_attr("title") %>%
  unique()

indEmpty <- which(dataRawOdds$X1 == "")
dataRawOdds <- dataRawOdds[(indEmpty[length(indEmpty)]+1):nrow(dataRawOdds),]

# remove columns with NAs
dataRawOdds <- dataRawOdds[,which(unlist(lapply(dataRawOdds, function(x)!all(is.na(x))))),with=F]

colnames(dataRawOdds) <- c("team", dataProvider)
providerNames <- colnames(dataRawOdds)[-1]

dataRawOdds[, (providerNames) := lapply(.SD, function(x) {
  lapply(x, function(y) {
    if (nchar(y) > 0) {
      eval(parse(text = y)) 
    } else {
      NA
    }
  }) %>% unlist()
}), .SDcols = providerNames]

## skip bookmakers without entries
dataRawOdds <- dataRawOdds[, which(colSums(is.na(dataRawOdds)) < nrow(dataRawOdds)), with=FALSE]

## replace missing values with row means 
for (ii in seq_along(dataRawOdds)) {
  dataRawOddsRow <- dataRawOdds[ii,2:ncol(dataRawOdds)]
  indMissing <- which(is.na(dataRawOddsRow))
  if (length(indMissing) > 0) {
    set(dataRawOdds, i=ii, j=indMissing+1, value=round(mean(unlist(dataRawOddsRow), na.rm=T)))
  }
}

setkey(result, "team")
setkey(dataRawOdds, "team")

result <- result[dataRawOdds]
result <- result[order(group, team)]

write.table(as.data.frame(result), paste0("../../../data/bettingOdds", format(Sys.Date(), "%Y%m%d"), ".csv"), quote = FALSE, row.names = FALSE, sep = ";")
