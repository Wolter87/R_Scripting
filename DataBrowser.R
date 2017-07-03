#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(data.table)
library(shiny)

# Define UI for application
ui <- fluidPage(
   
  titlePanel("DataBrowser"),
  
  sidebarLayout(
    sidebarPanel(
    fileInput("file", "Upload csv bestand"),
    
    textInput("FindFloor", "Zoek vloer:"),
    actionButton("SearchFloor", "Zoek vloer"),
    
br(), br(),

    textInput("FindTile", "Zoek tegel:"),
    actionButton("SearchTile", "Zoek tegel"),
    
br(), br(),

    dateRangeInput("dates", 
                    "Date range",
                    start = "2016-03-08", 
                    end = "2016-03-30"),
    actionButton("SearchDate", "Filter datum"),

    actionButton("Reset", "Herstel")
    ),
 
    mainPanel(
    tableOutput("df_out")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
 values <- reactiveValues(df = NULL)

  #browse knop werking
  observeEvent(input$file, {
    values$df <- read.csv(input$file$datapath, stringsAsFactors=FALSE)
  })
  #Vloer zoek knop
  observeEvent(input$SearchFloor, {
    values$df <- subset(values$df, Vloer == input$FindFloor)
  })
  #Zoek tegel knop
  observeEvent(input$SearchTile, {
    values$df <- subset(values$df, Tegel == input$FindTile)
  })
  #Datum zoek knop, hier is de data.tables library voor nodig. (%between% functie)
  observeEvent(input$SearchDate, {
    values$df <- subset(values$df, Datum %between% c(input$dates[1], input$dates[2]))
  })
  #Herlaad het huidige bestand, nieuwe bestanden kun je opnieuw laden door weer op de browse knop te drukken.
  observeEvent(input$Reset, {
    values$df <- read.csv(input$file$datapath, stringsAsFactors=FALSE)
  })
  #Ouput
  output$df_out <- renderTable({
        values$df
    })
}

# Run the application
shinyApp(ui = ui, server = server)
