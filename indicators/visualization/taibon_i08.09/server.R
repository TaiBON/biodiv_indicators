library(shiny)
library(ggplot2)
library(data.table)

## Input all data
Data <- fread('FishingCraftData.txt', sep = '\t',
              header = T, stringsAsFactors = F,
              encoding = 'UTF-8')
TotalTonnage <- fread('TotalTonnageTmp.txt', sep = '\t',
                      header = T, stringsAsFactors = F,
                      encoding = 'UTF-8')
NTonnage <- fread('NumberTmp.txt', sep = '\t',
                  header = T, stringsAsFactors = F,
                  encoding = 'UTF-8')
Data <- Data[!is.na(tonnage),]
Data2003 <- Data[year < 2011,]
Data2011 <- Data[year > 2010,]

#
FishingMethodCodes <- fread('FishingMethodCodes.txt', sep = '\t',
                            header = T, stringsAsFactors = F,
                            encoding = 'UTF-8')
Data2003 <- merge(Data2003, FishingMethodCodes, by = 'fishingMethod')


server <- function(input, output) {
  
  output$plot_I08_00 <- renderPlot({
    PT <- ggplot(TotalTonnage, aes(x = year, y = tonnage/1000)) + 
      geom_line(size = 1,  color = '#797474') + labs(x = 'Year', y = "Total tonnage (kt)")
    
    PT <- PT + scale_x_continuous(breaks = c(1967, seq(1975, 2010, 5), 2016),
                                  labels = c(1967, seq(1975, 2010, 5), 2016),
                                minor_breaks = 10)
    PT <- PT + theme(axis.title = element_text(size = 16))
    PT <- PT + theme(axis.text = element_text(size = 14, colour = 'DarkGray'))
    PT <- PT + theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.85))
    PT <- PT + theme(axis.title.y = element_text(margin = margin(0,20,0,0)))
    
    print(PT)
  })
  
  output$plot_I08_01 <- renderPlot({

    DataTmp <- Data2003[fishingMethodCode %in% input$checkGroup, 
                        .(tonnage = sum(tonnage)), by = year]
    
    P <- ggplot(DataTmp, aes(x = DataTmp$year, y = ((DataTmp$tonnage)/1000))) + 
      geom_line(size = 1,  color = '#797474') + labs(x = 'Year', y = "Total tonnage (kt)")
    
    P <- P + scale_x_continuous(breaks = 2003:2010, labels = 2003:2010,
                                minor_breaks = 1)
    P <- P + theme(axis.title = element_text(size = 16))
    P <- P + theme(axis.text = element_text(size = 14, colour = 'DarkGray'))
    P <- P + theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.85))
    P <- P + theme(axis.title.y = element_text(margin = margin(0,20,0,0)))

    print(P)
    
  })
  
  output$plot_I09_00 <- renderPlot({
    PT <- ggplot(NTonnage, aes(x = year, y = number)) + 
      geom_line(size = 1,  color = '#797474') + labs(x = 'Year', y = "Total Number")
    
    PT <- PT + scale_x_continuous(breaks = c(1967, seq(1975, 2010, 5), 2016),
                                  labels = c(1967, seq(1975, 2010, 5), 2016),
                                  minor_breaks = 10)
    PT <- PT + theme(axis.title = element_text(size = 16))
    PT <- PT + theme(axis.text = element_text(size = 14, colour = 'DarkGray'))
    PT <- PT + theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.85))
    PT <- PT + theme(axis.title.y = element_text(margin = margin(0,20,0,0)))
    
    print(PT)
  })
  
  output$plot_I09_01 <- renderPlot({
    
    DataTmp <- Data2003[!is.na(numberOfCraftWooden)]
    DataTmp <- DataTmp[ !is.na(numberOfCraftSteel)]
    DataTmp <- DataTmp[ !is.na(numberOfCraftFRP)]
    DataTmp <- DataTmp[fishingMethodCode %in% input$checkGroup2, 
                       .(number = sum(numberOfCraftWooden + numberOfCraftSteel + numberOfCraftFRP)),
                       by = year]
    
    PN <- ggplot(DataTmp, aes(x = year, y = number)) + 
      geom_line(size = 1,  color = '#797474') + labs(x = 'Year', y = "Total Number")
    
    PN <- PN + scale_x_continuous(breaks = 2003:2010, labels = 2003:2010,
                                minor_breaks = 1)
    PN <- PN + theme(axis.title = element_text(size = 16))
    PN <- PN + theme(axis.text = element_text(size = 14, colour = 'DarkGray'))
    PN <- PN + theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.85))
    PN <- PN + theme(axis.title.y = element_text(margin = margin(0,20,0,0)))
    
    print(PN)
    
  })
  
}