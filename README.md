
## FIFA World Cup 2022 Prediction

According to this [approach](https://econpapers.repec.org/paper/innwpaper/2014-17.htm)
here is my attempt to do predictions for the FIFA World Cup 2022:

1. Fetch quoted odds from https://www.oddschecker.com/football/world-cup/winner using fetchData.R
2. Transform them to odds and calculate aggregated probabilities using calcProbabilities.R
3. Run the simulations via the given java program using probabilites2022xxxx.csv as input.
4. Copy all csv-files to the app folder and view the results in the shiny app.

This app is also running on shinyapps.io: https://wittmann.shinyapps.io/FIFA_WORLD_CUP_2022_Prediction/