forecast <- tabItem('forecast',
                    fluidPage(
                      fluidRow(
                        box(width = 4,
                            numericInput('n', label = 'Forecast horizon', 
                                         value = 5, 
                                         min = 1, 
                                         max = 1000, 
                                         step = 1)
                        ),
                        box(width = 4,
                            numericInput('n.roll', label = '# of rolling forecasts', 
                                         value = 0, 
                                         min = 1, 
                                         max = 1000, 
                                         step = 1)
                        ),
                        
                        box(width = 4,
                            numericInput("os_forc", label = "Select out of sample", 
                                         value = 0, min = 0, max = 1000, step = 1))
                      ),
                      box(width = 12,
                          plotOutput("plot_forecast")),
                      box(width = 12,
                          numericInput("forc_plot_num", "Select plot number", value = 1,
                                       min = 1, max = 4, step = 1)),
                      box(width = 12,
                          plotOutput("plot_forecast2"))
                    ))