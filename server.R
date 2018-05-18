library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)

source("funcs.R", local = TRUE)

shinyServer(function(input, output) {
  getResults <- reactive({
    validate(
      need((input$a_fleg + input$a_dleg + input$a_mili) > 0, 
           "Attack must have Roman units"),
      need(!((input$d_fleg + input$d_dleg + input$d_mili > 0) && input$leader != 'None'), 
           "Barbarian Leader/Rival Emperor can't be in Roman army"),
      need(!((input$a_fleg + input$a_dleg ==0) && input$a_mili && input$a_barb > 0), 
           "Barbarians in a Roman army need a General"),
      need(!((input$d_fleg + input$d_dleg ==0) && input$d_mili && input$d_barb > 0), 
           "Barbarians in a Roman army need a General"),
      need(((input$d_fleg + input$d_dleg + input$d_mili + input$d_barb) > 0 | input$leader !='None'),
           "Defence must have at least one unit"),
      need(!((input$d_fleg + input$d_dleg + input$d_mili == 0) && input$d_cast), 
           "Castra must be stacked with a Roman unit"),
      need(!(input$a_mili && input$d_mili),
           "Militia on both sides is not possible"),
      need(!(input$leader == 'rival' && (input$d_fleg + input$d_dleg + input$d_barb + input$d_mili) > 0),
           "Rival Emperors fight alone!"),
      need((input$a_fleg + input$a_dleg) >= input$a_barb,
           "Roman army cannot have more barbarians than legions"),
      need(!(((input$d_fleg + input$d_dleg) < input$d_barb) && (input$d_fleg + input$d_dleg) > 0),
           "Roman army cannot have more barbarians than legions")
      
    )
    results <- run_trials(input$a_fleg, input$a_dleg, input$a_barb, input$a_mili,
                          input$d_fleg, input$d_dleg, input$d_barb, input$d_mili,
                          input$d_cast, input$leader, input$flank, input$event)
    results
  })
  output$distPlot <- renderPlot({
    results <- getResults() %>%
      gather(side,hits,attack,defence)
    ggplot(data = results) +
      geom_histogram(aes(x = hits,fill = side),position='dodge',binwidth = 0.5) +
      theme(legend.position = c(0.9, 0.85))
  })
  
  output$prob <- renderDataTable({
    getResults() %>% 
      count(outcome) %>%
      mutate(probability = round(n/100)) %>%
      select(outcome,probability)
  },options = list(searching = FALSE, paging = FALSE))


})
