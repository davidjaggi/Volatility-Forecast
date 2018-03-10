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
    
    model <- ugarchspec(variance.model = list(model = input$model, 
                                              garchOrder = c(input$p, input$q)),
                        mean.model = list(armaOrder = c(input$ar, input$ma), 
                                          include.mean = TRUE),
                        distribution.model = input$dist_model)
    
    return(model)
  })
  
  modelfit <- reactive({
    req(model())
    modelfit <- ugarchfit(spec=model(),data = retCalc(), 
                          out.sample = input$os_fit, 
                          solver = input$solver)
    return(modelfit)
  })
  
  modelforecast <- reactive({
    req(input$n)
    forecast <- ugarchforecast(modelfit(), data = NULL, n.ahead = input$n, 
                               n.roll = input$n.roll, out.sample = input$os_forc)
    return(forecast)
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
  
  output$print_modfit <- renderPrint({
    print(modelfit())
  })
  
  output$plot_modfit <- renderPlot({
    plot(modelfit(), which = input$fit_plot_num)
  })
  
  output$plot_forecast <- renderPlot({
    plot(modelforecast()@forecast$seriesFor)
  })
  
  output$plot_forecast2 <- renderPlot({
    plot(modelforecast(), which = input$forc_plot_num)
  })
}