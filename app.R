library(shiny)
library(rhandsontable)
library(ggplot2)

# Define UI
ui <- fluidPage(
  titlePanel("BIOC192 Lab 3"),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Exercise 1",
               rHandsontableOutput("table1"),
               plotOutput("linePlot")),  
      tabPanel("Exercise 2",
               rHandsontableOutput("table2"))
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Create initial data for tables
  spectrum_data <- data.frame(
    Wavelength = c(490,500,510,520,530,540,550,560,570,580,590,600),
    Oxy_Hb = rep(NA, 12),
    Deoxy_Hb = c(.174,.206,.256,.306,.388,.512,.608,.598,.525,.425,.295,.15)
  )
  
  # Render tables
  output$table1 <- renderRHandsontable({
    rhandsontable(spectrum_data, rowHeaders = FALSE) %>%
      hot_col("Oxy_Hb", type = "numeric", strict = TRUE, allowInvalid = FALSE, format = 0.000) %>%
      hot_col("Deoxy_Hb", readOnly = TRUE, format = 0.000) %>%
      hot_col("Wavelength", readOnly = TRUE, format = 0)
  })
  
  observe({
    if (!is.null(input$table1)) {
      spectrum_data <- hot_to_r(input$table1)
      output$linePlot <- renderPlot({
        ggplot(spectrum_data) +
          geom_line(aes(x = Wavelength, y = Oxy_Hb, color = "Oxy_Hb")) +
          geom_point(aes(x = Wavelength, y = Oxy_Hb, color = "Oxy_Hb")) +
          geom_line(aes(x = Wavelength, y = Deoxy_Hb, color = "Deoxy_Hb")) +
          geom_point(aes(x = Wavelength, y = Deoxy_Hb, color = "Deoxy_Hb")) +
          labs(title = "Oxy_Hb and Deoxy_Hb Spectrum", x = "Wavelength (nm)", y = "Absorbance") +
          scale_color_manual(values = c("Oxy_Hb" = "blue", "Deoxy_Hb" = "red"), name = "Legend")
      })
    }
  })
  
  initial_data2 <- data.frame(
    A = c("A", "B", "C"),
    B = c(100, 200, 300)
  )
  
  output$table2 <- renderRHandsontable({
    rhandsontable(initial_data2)
  })
  
}

# Run the app
shinyApp(ui, server)
