sidebar <- dashboardSidebar(sidebarMenu(
    menuItem('Data', tabName = 'data'),
    menuItem('Tests', tabName = 'tests'),
    menuItem('Fit', tabName = 'fit'),
    menuItem("Forecast", tabName = 'forecast')
  ) # end menu
)