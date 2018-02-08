server <- function(input, output, session){
  session$onSessionEnded(stopApp)
  
  ### Close App with a button ####################################################
  observeEvent(input$close, {
    js$closeWindow()
    stopApp()
  }) # ends Session if Window is closed
  
  dataLoader <- reactive({
    dir <- getwd()
    dataDir <- paste0(dir,'/Data/')
    data <- read.csv(file = paste0(dataDir, input$selectedData, '.csv'), header = TRUE, sep = ',')
    data <- xts(data$Open,order.by = as.Date(as.POSIXct(data$Date, format = '%Y-%m-%d')))
    return(data)
  })
  
  dataInput <- reactive({
    req(input$dataRange)
    
    raw <- dataLoader()
    start <- as.Date(input$dataRange[1])
    end <- as.Date(input$dataRange[2])
    data <- window(raw, start = start, end = end)
    
    # data cleaning
    if (input$cleaning == "prevDay"){
      data <- na.locf(data)
      data <- na.omit(data)
    } else {
      data <- na.omit(data)
    }
    # flog.info(data)
    return(data)
  })
  
  retCalc <- reactive({
    req(input$returnForm)
      data <- dataInput()
      ret <- Delt(data, type = input$returnForm)
      ret <- na.omit(ret)
      return(ret)
  })
  
  output$dataSummary <- renderPrint({
    summary(dataInput())
  })
  
  output$returnSummary <- renderPrint({
    summary(retCalc())
  })
  
  output$plotData <- renderPlot({
    autoplot(dataInput())
  })
  
  output$plotReturns <- renderPlot({
    autoplot(retCalc())
  })
}