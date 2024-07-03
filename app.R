library(shiny)
library(rhandsontable)
library(ggplot2)

# Define UI
ui <- fluidPage(
  titlePanel("BIOC192 Lab 3"),
  
    mainPanel(
      tabsetPanel(
        tabPanel("Exercise 1",
                 rHandsontableOutput("table1")),  
        tabPanel("Exercise 2",
                 rHandsontableOutput("table2")),  
      )
    )
  )


# Define server logic
server <- function(input, output) {
  
  # Create initial data for tables
  initial_data1 <- data.frame(
    X = c(1, 2, 3),
    Y = c(10, 20, 30)
  )
  
  initial_data2 <- data.frame(
    A = c("A", "B", "C"),
    B = c(100, 200, 300)
  )
  
  # Render tables
  output$table1 <- renderRHandsontable({
    rhandsontable(initial_data1)
  })
  
  output$table2 <- renderRHandsontable({
    rhandsontable(initial_data2)
  })
  
}

# Run the app
shinyApp(ui, server)
