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
      menuItem('Tests', tabName = 'tests')
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
                    plotOutput('plotReturns'))
      )),
      tabItem('tests',
              fluidRow())
    )
  ) # end body
) # end ui