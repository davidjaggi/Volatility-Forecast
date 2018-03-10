# git push -u origin master
source('installer.R')
source('ErrorHandler.R')
source("header.R")
source("sidebar.R")
source("data.R")
source("tests.R")
source("fit.R")
source("forecast.R")

ui <- dashboardPage(
  # Start DashBoard Header
  header, # end header
  # start sidebar
  sidebar, # end sidebar
  # start body
  dashboardBody(
    tabItems(data, tests, fit, forecast) # end tabitems
  ) # end body
) # end ui