library(shiny)

# Define UI
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Confidence Intervals"),
  
  # Sidebar with controls for test value, reliability, and confidence level
  sidebarPanel(

    numericInput("x", "Individual's Test Value (T scale):", 50),
    
    br(), br(),
    
    sliderInput("reli", "Reliability of the Test:",min = 0, max = 1, value = 0.9, step = 0.05),
    
    br(), br(),
    
    sliderInput("conflevel", "Confidence Level:", min = 0.5, max = 0.99, value = 0.95, step = 0.05)
      
    ),
      
# Show the plot
mainPanel(
    #h3(textOutput("caption")),
    
    plotOutput("confPlot") #, height = "600px")
)
  

))