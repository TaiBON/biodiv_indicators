library(shiny)
library(data.table)

mpalist.fatw <- fread(file = 'data/MPAListProcessed_FATW_2018_01.txt',
                      sep = '\t', header = T, stringsAsFactors = F,
                      encoding = 'UTF-8')

mpalist.fatw.vis <- mpalist.fatw[!is.na(basedOn) & !is.na(level) &
                                   !is.na(areaTotalByFATW)][
                                     !(nameOfMPA %in% unique(parentMPA))]

denominator <- 65076.96

server <- function(input, output) {
  
  output$mpa.aera <- renderText(
    
    if(input$includeIt_2 == 1) {
      mpalist.fatw.vis <- mpalist.fatw.vis[nameOfMPA != "相關漁具漁法及特定漁業禁漁區"]
    }
    
    if(input$includeIt_1 == 1) {
      mpalist.fatw.vis <- mpalist.fatw.vis[!is.na(typeOfCase)]
    }
    
    results <- mpalist.fatw.vis[basedOn %in% input$selectedLaw &
                                  level %in% input$selectedLevel][,
                                    .(area.total = sum(areaTotalByFATW),
                                      area.terr = sum(areaTerrestrialByFATW))],

    paste(round(((results$area.total - results$area.terr)/denominator)*100, 2), '%')
  )
  
}