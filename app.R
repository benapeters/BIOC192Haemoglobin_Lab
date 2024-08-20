library(shiny)
library(rhandsontable)
library(ggplot2)
library(ggalt)


# Define UI
ui <- fluidPage(
  titlePanel("BIOC192 Lab 3"),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Exercise 1",
               "Table 1, page 67 of your lab book",
                 fluidRow(
                   tags$br(),
                   column(width = 5.5, rHandsontableOutput("table1")),
                   column(6.5, plotOutput("linePlot")),
                 )
               ),
                
      tabPanel("Exercise 2",
               tags$br(),
               "Table 3, page 74 of your lab book",
               rHandsontableOutput("table2"),
               plotOutput("plot2"))
      
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
          geom_xspline(aes(x = Wavelength, y = Oxy_Hb, color = "Oxy_Hb"), spline_shape = -0.4) +
          geom_point(aes(x = Wavelength, y = Oxy_Hb, color = "Oxy_Hb")) +
          geom_xspline(aes(x = Wavelength, y = Deoxy_Hb, color = "Deoxy_Hb"), spline_shape = -0.4) +
          geom_point(aes(x = Wavelength, y = Deoxy_Hb, color = "Deoxy_Hb")) +
          labs(title = "Haemoglobin Spectrum", x = "Wavelength (nm)", y = "Absorbance") +
          scale_color_manual(values = c("Oxy_Hb" = "red", "Deoxy_Hb" = "blue"), name = "Legend") +
          theme(legend.position = 'bottom') +
          theme_minimal() +
          theme(axis.line.x = element_line(color = "black", size = 1),
                axis.line.y = element_line(color = "black", size = 1),
                plot.title = element_text(hjust = 0.5))
      })
    }
  })
  
  
  initial_data2 <- data.frame(
    Time_seconds = seq(0,540, by = 30),
    Percent_Oxy_Hb = rep(NA,19)
  )
  
  output$table2 <- renderRHandsontable({
    rhandsontable(initial_data2) %>%
      hot_col("Time_seconds", format = 0) %>%
    hot_col("Percent_Oxy_Hb", type = "numeric", strict = TRUE, allowInvalid = FALSE, format = 0.0)
  })
  
  # Reactive data frame
  reactive_data2 <- reactive({
    if (!is.null(input$table2)) {
      hot_to_r(input$table2)
    } else {
      initial_data2
    }
  })
  
  # Render the plot
  output$plot2 <- renderPlot({
    data <- reactive_data2()
    ggplot(data, aes(x = Time_seconds, y = Percent_Oxy_Hb)) +
      geom_xspline(spline_shape = -0.4) +
      geom_point() +
      labs(title = "Oxygen Hemoglobin Over Time", x = "Time (seconds)", y = "Percent Oxy Hb") +
      theme_minimal() +
      theme(axis.line.x = element_line(color = "black", size = 1),
            axis.line.y = element_line(color = "black", size = 1),
            plot.title = element_text(hjust = 0.5))
  })
  
}

# Run the app
shinyApp(ui, server)
