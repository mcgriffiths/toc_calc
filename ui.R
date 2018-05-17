
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Time of Crisis combat calculator"),

  # Sidebar 
  sidebarLayout(
    sidebarPanel(
      submitButton("Submit"),
      h3("Attack"),
      numericInput("a_fleg", label = "Full-strength legions", value = 0),
      numericInput("a_dleg", label = "Depleted legions", value = 0),
      numericInput("a_barb", label = "Barbarians", value = 0),
      checkboxInput("a_mili", label = "Militia?", value = FALSE),
      h3("Defence"),
      numericInput("d_fleg", label = "Full-strength legions", value = 0),
      numericInput("d_dleg", label = "Depleted legions", value = 0),
      numericInput("d_barb", label = "Barbarians", value = 0),
      checkboxInput("d_mili", label = "Militia?", value = FALSE),
      h3("Events"),
      checkboxInput("flank", label = "Flanking declared?", value = FALSE),
      selectInput("event", label="Event in play:",
                  choices = c("None","Plague of Cyprian", "Good Auguries", "Bad Auguries"),
                  selected = "None")
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      dataTableOutput("prob")
    )
  )
)
)
