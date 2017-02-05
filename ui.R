#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
shinyUI(fluidPage(
  titlePanel("Predict MPG from Horsepower"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("sliderHP", "What is the HP of the car?", 50, 250, value = 150),
      checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
      checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE),
      submitButton("Submit"),
      h3("Instructions"),
      h4("Use the slider to select a specific hp (horsepower) and then click on 'Submit'."),
      h4("You can select either or both models to provide the mpg predictions using the checkboxes.")
    ),
    mainPanel(
      plotOutput("plot1"),
      h3("Predicted MPG from Model 1:"),
      textOutput("pred1"),
      h3("Predicted MPG from Model 2:"),
      textOutput("pred2")
    )
  )
))