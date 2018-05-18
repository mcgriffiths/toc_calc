library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Time of Crisis combat calculator"),

  # Sidebar 
  sidebarLayout(
    sidebarPanel(
      submitButton("Fight!"),
      h3("Attack"),
      numericInput("a_fleg", label = "Full-strength legions", min = 0, max = 10, value = 1),
      numericInput("a_dleg", label = "Depleted legions", min = 0, max = 10, value = 0),
      numericInput("a_barb", label = "Barbarians", min = 0, max = 10, value = 0),
      checkboxInput("a_mili", label = "Militia?", value = FALSE),
      h3("Defence"),
      numericInput("d_fleg", label = "Full-strength legions", min = 0, max = 10, value = 1),
      numericInput("d_dleg", label = "Depleted legions", min = 0, max = 10, value = 0),
      numericInput("d_barb", label = "Barbarians", min = 0, max = 10, value = 0),
      checkboxInput("d_mili", label = "Militia?", value = FALSE),
      checkboxInput("d_cast", label = "Castra?", value = FALSE),
      selectInput("leader", label="Barbarian Leader:",
                  choices = c("None","Ardashir/Shapur"='ardshap', "Cniva"='cniva'),
                  selected = "None"),
      h3("Events"),
      checkboxInput("flank", label = "Flanking declared?", value = FALSE),
      selectInput("event", label="Event in play:",
                  choices = c("None"='none',
                              "Plague of Cyprian"='plague', 
                              "Good Auguries"='good_aug', 
                              "Bad Auguries"='bad_aug'),
                  selected = "none")
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      dataTableOutput("prob")
    )
  )
)
)
