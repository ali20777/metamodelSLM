library(shiny)

# Load data processing file
source("data_processing.R")

shinyServer(
   function(input, output) {
     # Set P and v as reactive
     P <- reactive({input$Power})
     v <- reactive({input$Speed})
     output$width <- renderText( { width( P(), v() ) } )
     output$length <- renderText( { length( P(), v() ) } )
   }
)
