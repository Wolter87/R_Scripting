#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
  sidebarLayout(
    sidebarPanel(
      helpText("Select a stock to examine. 
               Information will be collected from Google finance."),
      
      textInput("symb", "Symbol", "SPY"),
      
      dateRangeInput("dates", 
                     "Date range",
                     start = "2013-01-01", 
                     end = as.character(Sys.Date())),
      
      br(),
      
      checkboxInput("log", "Plot y axis on log scale", 
                    value = FALSE),
      
      checkboxInput("adjust", 
                    "Adjust prices for inflation", value = FALSE)
      ),
    
    mainPanel(plotOutput("plot"))
  )
)

library(quantmod)
source("C:/Users/Wolter/Documenten/School/HvA HBO ICT/Project big data/stockVis/helpers.R")

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  dataInput <- reactive({
    getSymbols(input$symb, src = "google", 
              from = input$dates[1],
              to = input$dates[2],
              auto.assign = FALSE)
  })
  
  finalInput <- reactive({
    if (input$adjust) return (adjust(dataInput()))
    (dataInput())
  })
  
  output$plot <- renderPlot({
    chartSeries(finalInput(), theme = chartTheme("white"), 
      type = "line", log.scale = input$log, TA = NULL)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

