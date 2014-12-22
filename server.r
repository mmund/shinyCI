library(shiny)
library(ggplot2)


# Define server logic
shinyServer(function(input, output) {
  
#### the plotting function ####
output$confPlot <- renderPlot({
  ### prepare data and stuff 
  daf        <- data.frame(x = 50, y = 0.005)
  daf$x      <- input$x
  daf$rel    <- input$reli
  daf$sdv    <- 10
  daf$minval <- -3*daf$sdv
  daf$maxval <-  3*daf$sdv
  daf$se     <- daf$sdv*sqrt(1 - daf$rel)
  daf$clevel <- input$conflevel
  daf$crit.z <- abs(qnorm((1-daf$clevel) / 2))
  daf$ci.min <- daf$x - daf$crit.z*daf$se
  daf$ci.max <- daf$x + daf$crit.z*daf$se
    
  ### the plot
  g <- ggplot() + 
    stat_function(data = data.frame(x = c(20, 80)), aes(x), fun = dnorm, args = list(mean = 50, sd = 10)) + # normal dist with m = 50, sd = 10
    theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) + ylab("") + # y-axis 
    scale_x_continuous("T-Wert", breaks = seq(20,80, 10)) # x-axis
    # colour different areas of the plot
    g <- g +   
    geom_polygon(data = data.frame(x = c(40, seq(from = 40, to = 60, by = 0.5), 60), 
                                   y = c(0,  dnorm(seq(from = 40, to = 60, by = 0.5), 50, 10), 0))
                 , aes(x=x, y=y), fill = "blue", alpha = 0.4) # +
    g <- g + geom_point(data = daf, aes(x = x, y = y), size = 5) # test value
    g <- g + geom_errorbarh(data = daf, aes(x = x, y = y, xmin = ci.min, xmax = ci.max), height = 0, size = 1) # confidence intervals
    g
    })

output$interpreter <- renderText({
  daf        <- data.frame(x = 50, y = 0.005)
  daf$x      <- input$x
  daf$rel    <- input$reli
  daf$sdv    <- 10
  daf$minval <- -3*daf$sdv
  daf$maxval <-  3*daf$sdv
  daf$se     <- daf$sdv*sqrt(1 - daf$rel)
  daf$clevel <- input$conflevel
  daf$crit.z <- abs(qnorm((1-daf$clevel) / 2))
  daf$ci.min <- daf$x - daf$crit.z*daf$se
  daf$ci.max <- daf$x + daf$crit.z*daf$se
  
    if (daf$ci.min >= 40 & daf$ci.max <= 60) "durchschnittlich" else
      if(daf$ci.max < 40) "unterdurchschnittlich" else
        if(daf$ci.min > 60) "überdurchschnittlich" else
          if (daf$ci.min < 40 & daf$ci.max >= 40 & daf$ci.max < 60) "unterdurchschnittlich bis durchschnittlich" else
            if (daf$ci.min >= 40 & daf$ci.min <= 60 & daf$ci.max > 60) "durchschnittlich bis überdurchschnittlich" else
              if (daf$ci.min < 40 & daf$ci.max > 60) "unterdurchschnittlich bis überdurchschnittlich"        
}) # end renderText
    
})  # end shinyServer