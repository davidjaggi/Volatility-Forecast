tests <- tabItem('tests',
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
                   )))