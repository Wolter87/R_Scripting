# TEGELCOUNT


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
   
   # Application title
   titlePanel("Old Faithful Geyser Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("count",
                     "count:",
                     min = 0,
                     max = 4,
                     value = 0)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
     x <- Tegelcount[,1]
     y <- seq(min(x), max(x), length.out = input$count + 1)
      
      # draw the histogram with the specified number of bins
     plot_ly(
       Tegelcount,
       x,
       y
     )
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

