server <- function(input, output, session){
  session$onSessionEnded(stopApp)
  
  dataLoader <- reactive({
    dir <- getwd()
    dataDir <- paste0(dir,'/Data/')
    data <- read.csv(file = paste0(dataDir, input$selectedData, '.csv'), header = TRUE, sep = ',')
    open <- data$Open
    data <- xts(open,order.by = as.Date.POSIXct(data$Date, format = '%Y-%m-%d'))
    return(data)
  })
  
  dataInput <- reactive({
    raw <- dataLoader()
    data <- as.xts(raw)
    return(data)
  })
  
  retCalc <- reactive({
      data <- dataInput
      ret <- Delt(data, type = input$returnForm)
      return(ret)
  })
  
  output$dataSummary <- renderDataTable({
    table(summary(dataLoader()))
  })
  
  output$plotData <- renderPlot({
    plot(dataLoader())
  })
  
  output$plotReturns <- renderPlot({
    plot(retCalc())
  })
}