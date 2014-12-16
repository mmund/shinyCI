library(shiny)
library(ggplot2)


# Define server logic
shinyServer(function(input, output) {
  
#   mytext <- reactive(function() {
#     paste("conf level:", input$conflevel, "\n class:", class(input$conflevel))
#   })
#   
#   output$caption <- reactiveText(function(){
#     mytext()
#   })
  

  # the plotting function
   output$confPlot <- renderPlot(function() {
    
    # prepare data and stuff 
    daf <- data.frame(x = 50, y = 0.005)
    daf$x <- as.numeric(as.character(input$x))
    daf$rel <- as.numeric(as.character(input$reli))
    daf$se <- 10*sqrt(1 - daf$rel)
    daf$clevel <- as.numeric(as.character(input$conflevel))
    daf$crit.z <- abs(qnorm((1-daf$clevel)/2))
    daf$ci.min <- daf$x - daf$crit.z*daf$se
    daf$ci.max <- daf$x + daf$crit.z*daf$se
    
    # the plot
    g <- ggplot() + 
      stat_function(data = data.frame(x = c(20, 80)), aes(x), fun = dnorm, args = list(mean = 50, sd = 10)) + # normal dist with m = 50, sd = 10
      theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) + ylab("") + # y-axis 
      scale_x_continuous("T-Value", breaks = seq(20,80, 10)) # x-axis
    # colour different areas of the plot
    g <- g +   
#       geom_polygon(data = data.frame(x = c(20,seq(20, 40, 0.5),40), 
#                                      y = c(0,dnorm(seq(20, 40, 0.5), 50, 10), 0))
#                    , aes(x=x, y=y), fill = "yellow", alpha = 0.4) + 
       geom_polygon(data = data.frame(x = c(40,seq(40, 60, 0.5),60), 
                                     y = c(0,dnorm(seq(40, 60, 0.5), 50, 10), 0))
                   , aes(x=x, y=y), fill = "blue", alpha = 0.4) # +
#       geom_polygon(data = data.frame(x = c(60,seq(60, 80, 0.5),80), 
#                                      y = c(0,dnorm(seq(60, 80, 0.5), 50, 10), 0))
#                    , aes(x=x, y=y), fill = "skyblue", alpha = 0.4)
    g <- g + geom_point(data = daf, aes(x = x, y = y), size = 5) # test value
    g <- g + geom_errorbarh(data = daf, aes(x = x, y = y, xmin = ci.min,xmax = ci.max), height = 0, size = 1) # confidence intervals
    print(g)
    })
  
    
})