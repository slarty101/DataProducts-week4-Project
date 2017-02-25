#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
# get the data and clean it
carsApp <- read.table("auto-mpg.data", na.strings = "?")
colnames(carsApp) <- c("mpg","cylinders","displacement","hp","weight","acceleration","model year","origin","car name")
carsApp <- na.omit(carsApp)


shinyServer(function(input, output) {
  carsApp$hpsp <- ifelse(carsApp$hp - 120 > 0, carsApp$hp - 120, 0)
  model1 <- lm(mpg ~ hp, data = carsApp)
  model2 <- lm(mpg ~ hpsp + hp, data = carsApp)
  
  model1pred <- reactive({
    hpInput <- input$sliderHP
    predict(model1, newdata = data.frame(hp = hpInput))
  })
  
  model2pred <- reactive({
    hpInput <- input$sliderHP
    predict(model2, newdata = 
              data.frame(hp = hpInput,
                         hpsp = ifelse(hpInput - 120 > 0,
                                       hpInput - 120, 0)))
  })
  output$plot1 <- renderPlot({
    hpInput <- input$sliderHP
    
    plot(carsApp$hp, carsApp$mpg, xlab = "Horsepower", 
         ylab = "Miles Per Gallon", bty = "n", pch = 16,
         xlim = c(50, 250), ylim = c(10, 45))
    if(input$showModel1){
      abline(model1, col = "red", lwd = 2)
    }
    if(input$showModel2){
      model2lines <- predict(model2, newdata = data.frame(
        hp = 50:250, hpsp = ifelse(50:250 - 120 > 0, 50:250 - 120, 0)
      ))
      lines(50:250, model2lines, col = "blue", lwd = 2)
    }
    legend(25, 250, c("Model 1 Prediction", "Model 2 Prediction"), pch = 16, 
           col = c("red", "blue"), bty = "n", cex = 1.2)
    points(hpInput, model1pred(), col = "red", pch = 16, cex = 2)
    points(hpInput, model2pred(), col = "blue", pch = 16, cex = 2)
  })
  
  output$pred1 <- renderText({
    model1pred()
  })
  
  output$pred2 <- renderText({
    model2pred()
  })
})