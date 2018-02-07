source('packages.R')
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
              fluidRow(
                box(width = 6,
                    selectInput(inputId = 'selectedData',
                                label = 'Select Data',
                                choices = c(SPX = 'SPX')
                                ),
                    selectInput(inputId = 'returnForm',
                                label = 'Select Form of return',
                                choices = c(arithmetic = 'arithmetic',
                                            log = 'log')
                    )
                    ),
                box(width = 6,
                    dateRangeInput(inputId = 'dataRange',
                                   label = 'Select Data Range')),
                box(width = 6,
                    DTOutput('dataSummary')),
                box(width = 12,
                    plotOutput('plotData')),
                box(width = 12,
                    plotOutput('plotReturns'))
              )
      ),
      tabItem('tests',
              fluidRow())
    )
  ) # end body
) # end ui