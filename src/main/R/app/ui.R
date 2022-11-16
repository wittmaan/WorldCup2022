
library(d3heatmap)
library(shiny)
library(rCharts)


shinyUI(navbarPage(
    title = 'FIFA World Cup 2022 Prediction',
    tabPanel('Explanation',
             p('This is a shiny app that uses bookmaker betting odds (see tab \'Betting Odds\') to calculate abilities and probabilities of 
             the 32 teams of the FIFA World Cup 2022.'),
             br(),
             p('To do this, the following steps are necessary:'),
             p(HTML('1. To calculate this winning probabilities, first the profit margin of the bookmakers 
                  (so called <a href="https://en.wikipedia.org/wiki/Mathematics_of_bookmaking#Overround_on_multiple_bets">overround</a>) 
             must be removed.')),
             p(HTML('2. The odds without overround infer the ability of a team. Using these abilites pairwise winning probabities
             can be calculated (see tab \'Pairwise Comparisons\').')),
             br(),
             p(HTML('The <a href="https://en.wikipedia.org/wiki/Bradley%E2%80%93Terry_model">Bradley-Terry-Modell</a> can be used
             to calculate the winning probability that team A strikes team B as P(A strikes B) = ability(A) / (ability(A) + ability(B))')),
             p('3. The averaged bookmakers ratings (see tab \'Bookmaker consensus rating\') are obtained using the log-odds 
             which are transformed via the logit-function. Via the inverse logit-function the winning probabilitis can be calculated.'),
             p('4. With an iterative approach the abilities and so the pairwise winning probability can be established
              in order to match the bookmakers winning probabilities.
              Using the pairwise winning probabilites the whole tournament can be simulated 100,000 times.'),
             p('5. Using the abilites the probability for each team to reach round of 16, quarter finals, semi finals, finals and 
             winning the tournament can be calculated (see tab \'Team Probabilites\').'),
             p('6. Furthermore the probabilities for the final standings of each group after the group phase can be estimated
              (see tab \'Group Probabilites\').'),
             br(),br(),br(),br(),
             p(HTML('Literature: 
                  <a href="http://econpapers.repec.org/paper/innwpaper/2014-17.htm">Zeileis A, Leitner C, Hornik K (2014): Home Victory for Brazil in the 2014 FIFA World Cup</a>,
                  <a href="http://econpapers.repec.org/paper/innwpaper/2016-15.htm">Zeileis A, Leitner C, Hornik K (2016): Predictive Bookmaker Consensus Model for the UEFA Euro 2016</a>'))),
    tabPanel('Betting Odds',
             p(HTML('Betting odds from 26 online bookmakers for the 32 teams in the FIFA World Cup 2022. 
              They are obtained on 2022-11-16 from <a href="https://www.oddschecker.com/football/world-cup/winner">https://https://www.oddschecker.com/football/world-cup/winner</a>')),
             DT::dataTableOutput('odds')),
    tabPanel('Pairwise Comparisons',
             p('Winning probabilities in pairwise comparisons of all FIFA World Cup 2022 teams.'), 
             #br(),
             p('For example see the rightmost column of the top row: the probability of Brazil beating Wales is estimated
             as 79 %.'),
             uiOutput("ui_heatmap")),  
    tabPanel('Bookmaker consensus rating',
             p('FIFA World Cup winning probabilities from the bookmaker consensus rating'),
             showOutput("chart", "polycharts"),
             p('Bookmaker consensus rating for the FIFA World Cup 2022, obtained from 26 online
              bookmakers. For each team, the consensus winning probability (in %), corresponding log-odds,
              simulated log-abilities, and group in tournament is provided.'),
             DT::dataTableOutput('rating')),
    tabPanel('Team Probabilites',
             p('Probabilities (in %) for each team to \'survive\' the group phase.'),
             selectInput(inputId = "group1", label = "group", choices = sort(unique(datOdds$group)), selected = "A"),
             showOutput("teamChart", "nvd3")),
    tabPanel('Group Probabilites',
             p('Probabilities (in %) for the final standings of each group after the group phase'),
             selectInput(inputId = "group2", label = "group", choices = sort(unique(datOdds$group)), selected = "A"),
             DT::dataTableOutput('group')),
    tabPanel('Match Probabilities',
             selectInput(inputId = "round", label = "round", choices = unique(knockoutStageResult$round), selected = unique(knockoutStageResult$round)[1]),
             DT::dataTableOutput('matches'))
))