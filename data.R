
data <- tabItem('data',
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
        ))