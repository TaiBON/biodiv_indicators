library(shiny)
library(ggplot2)
library(data.table)

DataPPRaw <- fread(file = 'data/DataFromPowerPlantProcessed_2018_01.txt', sep = '\t', header = T,
                   stringsAsFactors = F, encoding = 'UTF-8')
DataPPRaw <- DataPPRaw[!is.na(samplingVolume)]

DataPP_M <- DataPPRaw[, .(meanM = mean((debrisDaily+debrisOrganism+debrisWood+miscellaneous)/samplingVolume)),
                      by = .(year, month, siteName)]
#test <- DataPP_M
#test <- na.omit(test)


server <- function(input, output) {
  
  output$plot_III04_01 <- renderPlot({
    
    DataPP_MTmp <- DataPP_M[month %in% input$includedMonths]
    
    if(input$aggregation == 1) {
      DataPP_MTmp <- DataPP_MTmp[, .(Mean = mean(meanM)), by = year]
      P <- ggplot(DataPP_MTmp, aes(x = year, y = Mean)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Debris Quantity")
    } else if (input$aggregation == 3) {
      DataPP_MTmp <- DataPP_MTmp[, .(Mean = mean(meanM)), by = .(year, siteName)]
      P <- ggplot(DataPP_MTmp, aes(x = year, y = Mean)) + geom_line(size = 1, color = '#797474') + 
        facet_wrap(~siteName) + labs(x = 'Year', y = "Debris Quantity")
    } else {
      DataPP_MTmp <- DataPP_MTmp[, .(Mean = mean(meanM)), by = .(year, siteName)]
      
    }
    
    print(P)
  })
  
}