server <- function(input, output, session){
  session$onSessionEnded(stopApp)
  
  ### Close App with a button ##################################################
  observeEvent(input$close, {
    js$closeWindow()
    stopApp()
  }) # ends Session if Window is closed
  
  ### Functions ################################################################
  dataLoader <- reactive({
    dir <- getwd()
    dataDir <- paste0(dir,'/Data/')
    data <- read.csv(file = paste0(dataDir, input$selectedData, '.csv'), 
                     header = TRUE, sep = ',')
    data <- xts(data$Open,order.by = as.Date(as.POSIXct(data$Date, 
                                                        format = '%Y-%m-%d')))
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
    ret[1] <- 0
    ret <- na.omit(ret)
    return(ret)
  })
  
  model <- reactive({
    req(input$model)
    req(input$q)
    req(input$p)
    req(input$ar)
    req(input$ma)
    req(input$inc_mean)
    req(input$dist_model)
    
    flog.info(input$model)
    flog.info(input$q)
    flog.info(input$p)
    flog.info(input$ar)
    flog.info(input$ma)
    flog.info(input$inc_mean)
    flog.info(input$dist_model)
    
    model <- ugarchspec(variance.model = list(model = input$model, 
                                              garchOrder = c(input$p, input$q)),
                        mean.model = list(armaOrder = c(input$ar, input$ma), 
                                          include.mean = input$inc_mean),
                        distribution.model = input$dist_model)
    flog.info(print(model))
    return(model)
  })
  
  modelfit <- reactive({
    req(model())
    modelfit <- ugarchfit(spec=model(),data = retCalc())
    return(modelfit)
  })
  
  ### Outputs ##################################################################
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
  output$histReturns <- renderPlot({
    ggplot(data=retCalc(), aes(retCalc()[,1])) + geom_histogram()
  })
  output$qqNormRet <- renderPlot({
    qqPlot(x = retCalc(), distribution = 'norm', envelope = .99)
  })
  
  output$qqStudentRet <- renderPlot({
    qqPlot(x = retCalc(), distribution = 't', df = 4, envelope = .99)
  })
  ### Tests
  output$acf <- renderPlot({
    ggAcf(retCalc(), lag.max = 36)
  })
  
  output$pacf <- renderPlot({
    ggPacf(retCalc(), lag.max = 36)
  })
  
  output$adf <- renderPrint({
    adf.test(retCalc())
  })
  
  output$pp <- renderPrint({
    PP.test(retCalc())
  })
  
  output$kpss <- renderPrint({
    kpss.test(retCalc())
  })
  
  output$print_model <- renderPrint({
    print(model()@model$pars)
  })
  
  output$modfit <- renderPrint(({
    print(modelfit())
  }))
}