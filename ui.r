library(shiny)

# Define UI
# fluidPage
shinyUI(pageWithSidebar(
  
  #### Application title ####
  titlePanel("Konfidenzintervalle"),
  
  #### Sidebar with controls for test value, reliability, and confidence level ####
  sidebarPanel(

    numericInput("x"
                 , helpText(strong("Testwert auf T-Skala"), br(),
                          "(MW = 50, SD = 10):")
                 # , "Testwert auf T-Skala:"
                 , 50),
    
    br(), br(),
    
    sliderInput("reli"
                , strong("Reliabilität:")
                , min = 0
                , max = 1
                , value = 0.8
                , step = 0.05),
    
    br(), br(),
    
    sliderInput("conflevel"
                , helpText(strong("Sicherheitswahrscheinlichkeit"), br(),
                           "(1 - Irrtumswahrscheinlichkeit):")
                , min = 0.5
                , max = 1.00
                , value = 0.95
                , step = 0.01),
    
    #### interpretation of current CI
    br(), br(),
    
    helpText(strong("Interpretation:", br())),
    textOutput("interpreter")
    
    ),
  
  #### Show the Plot ####
  mainPanel(
    plotOutput("confPlot") #, height = "600px")
    )
))