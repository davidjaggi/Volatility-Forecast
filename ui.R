# git push -u origin master
source('installer.R')
source('ErrorHandler.R')

ui <- dashboardPage(
  # Start DashBoard Header
  dashboardHeader(title = 'Volatility Forecast'), # end header
  # start sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem('Data', tabName = 'data'),
      menuItem('Tests', tabName = 'tests'),
      menuItem('Forecast', tabName = 'forecast')
    ) # end menu
  ), # end sidebar
  # start body
  dashboardBody(
    tabItems(
      tabItem('data',
              fluidPage(
              fluidRow(
                box(width = 6,
                    selectInput(inputId = 'selectedData',
                                label = 'Select Data',
                                choices = c(SPX = 'SPX')
                                ),
                    selectInput(inputId = 'returnForm',
                                label = 'Select Form of return',
                                choices = c(arithmetic = 'arithmetic',
                                            log = 'log'))
                    ),
                box(width = 6,
                    dateRangeInput(inputId = 'dataRange',
                                   label = 'Select Data Range',
                                   start = '2000-01-01', 
                                   end = Sys.Date()),
                    selectInput("cleaning", label = "Cleaning Type",
                                choices = c("Previous Day" = "prevDay", "Delete" = "delete"), 
                                multiple = FALSE))
                ),
              fluidRow(
                box(width = 6,
                    verbatimTextOutput('dataSummary')),
                box(width = 6,
                   verbatimTextOutput('returnSummary'))
                ),
                box(width = 12,
                    plotOutput('plotData')),
                box(width = 12,
                    plotOutput('plotReturns')),
              box(width = 12,
                  plotOutput('histReturns')),
              fluidRow(
                box(width = 6,
                    plotOutput('qqNormRet')),
                box(width = 6,
                    plotOutput('qqStudentRet'))
              )
      )),
      tabItem('tests',
              fluidPage(
                  box(width = 12,
                      plotOutput('acf')),
                  box(width = 12,
                      plotOutput('pacf')),
                  box(width = 12,
                      verbatimTextOutput('adf')),
                  box(width = 12,
                      verbatimTextOutput('pp')
                  ),
                  box(width = 12,
                      verbatimTextOutput('kpss')
                  ))),
      tabItem('forecast',
              fluidPage(
                box(width = 12,
                    selectInput("model", label = "Selecht Model",
                                choices = c("sGARCH",
                                            "fGARCH",
                                            "eGARCH",
                                            "gjrGARCH",
                                            "apGARCH",
                                            "iGARCH",
                                            "csGARCH"))),
                fluidRow(
                  box(width = 6,
                      numericInput("q",label = "Select q",
                                   value = 1,
                                   min = 0, 
                                   max = 100, 
                                   step = 1)),
                  box(width = 6,
                      numericInput("p", label = "Select p",
                                   value = 1,
                                   min = 0,
                                   max = 100,
                                   step = 1))),
                fluidRow(
                  box(width = 4,
                      numericInput("ar",label = "Select ar",
                                   value = 1,
                                   min = 0, 
                                   max = 100, 
                                   step = 1)),
                  box(width = 4,
                      numericInput("ma", label = "Select ma",
                                   value = 1,
                                   min = 0,
                                   max = 100,
                                   step = 1)),
                  box(width = 4,
                      selectInput("inc_mean", label = "Should the mean be included?",
                                  choices = c("TRUE", 
                                              "FALSE")))), # end fluidrow
                box(width = 12,
                    selectInput("dist_model", label = "Select distribution",
                                choices = c("Normal" = "norm",
                                            "Skewed Normal" = "snorm",
                                            "Student-t" = "std",
                                            "Skewed Student-t" = "sstd",
                                            "Generalized error" = "ged",
                                            "Skewed generalized error" = "sged",
                                            "Inversed gaussian" = "nig",
                                            "Generalized hyperbolic" = "ghyp",
                                            "Johnson's SU" = "jsu"))),
                box(width = 12,
                    verbatimTextOutput("print_model")),
                
                box(width = 12,
                    verbatimTextOutput("modfit"))
                ) # end fluidpage
      )# end forecast tab
    ) # end tabitems
  ) # end body
) # end ui