#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(ggthemes)
library(plotly)

employee_data <- readRDS("../data/employee_data.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Give the page a title
  titlePanel("HR Data"),
  
  # Generate a row with a sidebar
  sidebarLayout(# Define the sidebar with one input
    sidebarPanel(
      selectInput(
        "hr_variable",
        "HR Variable:",
        choices = colnames(employee_data),
        selected = "OverTime"
      ),
      hr(),
      helpText("Data from HR Database")
    ),
    
    # Create a spot for the barplot
    mainPanel(plotlyOutput("hrPlot", width = "200%"))
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  # Fill in the spot we created for a plot
  output$hrPlot <- renderPlotly({
    # Render a barplot
    p2 <- ggplot(data = employee_data) +
      geom_bar(aes(x = employee_data[, input$hr_variable], fill = Attrition), position = "fill") +
      theme(axis.title.y = element_blank()) +
      theme(axis.title.x = element_blank()) +
      scale_fill_colorblind()
    ggplotly(p2, height = 400, width = 600)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

