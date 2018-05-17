
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(tidyr)
library(ggplot2)

source("funcs.R", local = TRUE)

shinyServer(function(input, output) {
  getResults <- reactive({
    results <- run_trials(input$a_fleg, input$a_dleg, input$a_barb, input$a_mili,
                          input$d_fleg, input$d_dleg, input$d_barb, input$d_mili)
    results
  })
  output$distPlot <- renderPlot({
    results <- getResults() %>%
      gather(side,hits,attack_hits,defence_hits)
    ggplot(data = results) +
      geom_histogram(aes(x = hits,fill = side),position='dodge',binwidth = 0.5) 
  })
  
  output$prob <- renderDataTable({
    getResults() %>% count(outcome)
  })


})
