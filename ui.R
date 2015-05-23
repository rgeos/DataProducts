library(shiny)
library(markdown)

shinyUI(fluidPage(
  
  titlePanel("My Shiny App (MSA) - Developing Data Products"),
  
  fluidRow(
    column(12, wellPanel(
      p(strong("NOTE!!!"),"The plot is updated each time a parameter changes. Please wait until the screen refreshes before changing another parameter."),
      p(strong("How to use the application")),
      tabsetPanel(type = "pills", selected = "",
        tabPanel("Control Panel", includeMarkdown("text_controlPanel.txt")),
        tabPanel("Main Panel", includeMarkdown("text_mainPanel.txt")),
        tabPanel("Plotting Area", includeMarkdown("text_plottingArea.txt"))
      )
    ))
  ),
  
  fluidRow(
    column(5,
           h3("Control Panel"),
           column(9,
                  helpText("Please select the outcome and the predictor from below."),
                  selectInput(
                    inputId  = "outcome", 
                    label    = "Outcome",
                    choices  = c(
                      "Miles Per Gallon" = "mpg",
                      "Horse Power" = "hp",
                      "Weight" = "wt"),
                    selected = "mpg"
                  ),
                  radioButtons(
                    inputId = "predictor",
                    label   = "Predictor",
                    choices = c(
                      "Number of Cylinders" = "cyl",
                      "Transmission" = "am"),
                    selected = "am"
                  ),
                  wellPanel(
                    helpText("By using a stepwise regression model we will be able to automatically
                             identify the best predictive variables for the regression model"),        
                    checkboxInput(
                      inputId = "regression",
                      label   = "Show regression model plots", 
                      value   = FALSE )
                  )
           )
    ),
    
    
    column(7,
           h3("Main Panel"),
           column(12, helpText("The selected outcome is: "), verbatimTextOutput("outcome")),
           column(12, helpText("Summary on the outcome: "), verbatimTextOutput("outcomeSummary")),
           column(12, helpText("The selected predictor is: "), verbatimTextOutput("predictor")),
           column(12, helpText("Summary on the predictor: "), verbatimTextOutput("predictorSummary")),
           conditionalPanel(condition = "input.regression == true",
                            column(12, helpText("Variables used in the regression model: "), verbatimTextOutput("modelVariables"))
           )
    )
  ),
  
  fluidRow(
    column(6, h3("Plotting the data pairs"), plotOutput("pairs")),
    column(6, h3("Plotting the data boxes"), plotOutput("boxes"))
  ),
  
  conditionalPanel(condition = "input.regression == true",
                   fluidRow(
                     column(12, h3("Regression model plots"), plotOutput("model"))
                   )
  )
  
  
))