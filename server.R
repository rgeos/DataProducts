# loading the necessary libraries
library(shiny)
library(UsingR)
library(datasets)

# we will be using the mtcars dataset
# The Motor Trend Car Roads data was extracted from the 1974 Motor Trend US magazine,
# and comprises fuel consumption and 10 aspects of automobile design and performance
# for 32 automobiles (1973–74 models). The dataset has 32 observations on 11 variables.  
theData = mtcars
theData$cyl  = factor(theData$cyl)
theData$vs   = factor(theData$vs)
theData$gear = factor(theData$gear)
theData$carb = factor(theData$carb)
theData$am   = factor(theData$am, labels = c("Automatic", "Manual"))

# this function will extracet the summary for each dependent variable
summaryOutcome = function(input) {
  switch(input$outcome,
         "mpg"  = return (summary(theData$mpg)),
         "hp"   = return (summary(theData$hp)),
         "wt"   = return (summary(theData$wt))
  )
}

# this function will extract the summary for each independent variable
summaryPredictor = function(input) {
  switch(input$predictor,
         "cyl"  = return (summary(theData$cyl)),
         "am"   = return (summary(theData$am)),
         "qsec" = return (summary(theData$qsec))
  )
}

# this is a helping function that calculates the correlation between 2 variables
panel.cor = function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
  usr = par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r = abs(cor(x, y))
  txt = format(c(r, 0.123456789), digits = digits)[1]
  txt = paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor = 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}

# this is a helping function that plots the histogram of a dataset
panel.hist <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, ...)
}



# this function will create a pair scatterplot matrix (2x2) of the selected variables
plotPairs = function(input) {
  formulaText = as.formula(paste(input$outcome, input$predictor, sep = " ~ "))
  pairs(formulaText,
        data = theData, col = adjustcolor(palette(), alpha.f = .3),
        panel = panel.smooth,
        upper.panel = panel.cor,
        diag.panel = panel.hist
  )  
}

# this function will create a boxplot of the selected variables
plotBoxes = function(input) {
  formulaText = as.formula(paste(input$outcome, input$predictor, sep = " ~ "))
  boxplot(formulaText, data = theData, col = adjustcolor(palette(), alpha.f = .3),
          ylab = input$outcome, 
          xlab = input$predictor)
}

# multivariate regeression model
regressionModel = function() {
  # initial liniar model with mpg as outcome and all the other variables are predictors
  initialFit  = lm(mpg ~ ., data = theData)
  # using stepwise regression model to select the best predictive variables
  bestFit     = step(initialFit, trace = 0)
}

# plotting the regression model
plotModel = function() {
  par(mfrow = c(1,4))
  plot(regressionModel())
}


# Shiny server
shinyServer(
  function(input,output)
  {
    output$outcome = renderPrint({input$outcome}) 
    output$outcomeSummary = renderPrint(summaryOutcome(input))
    output$predictor = renderPrint({input$predictor}) 
    output$predictorSummary = renderPrint(summaryPredictor(input)) 
    output$modelVariables = renderPrint(attr(summary(regressionModel())$terms, which = "variables")) 
    
    output$pairs = renderPlot({plotPairs(input)})
    output$boxes = renderPlot({plotBoxes(input)})
    output$model = renderPlot({plotModel()}) 
  }
)