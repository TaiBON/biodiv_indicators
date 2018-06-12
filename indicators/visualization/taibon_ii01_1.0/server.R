library(shiny)
library(data.table)

mpalist.fatw <- fread(file = 'data/MPAListProcessed_FATW_2018_01.txt',
                      sep = '\t', header = T, stringsAsFactors = F,
                      encoding = 'UTF-8')

mpalist.fatw.vis <- mpalist.fatw[!is.na(basedOn) & !is.na(level) &
                                   !is.na(areaTotalByFATW)][
                                     !(nameOfMPA %in% unique(parentMPA))]

mpalist.fatw.vis[basedOn == "國家公園法", basedOnNew := 1][
  basedOn == "野生動物保育法", basedOnNew := 2][
    basedOn == "文化資產保存法", basedOnNew := 3][
      basedOn == "都市計畫法", basedOnNew := 4][
        basedOn == "發展觀光條例", basedOnNew := 5][
          basedOn == "漁業法", basedOnNew := 6]

mpalist.fatw.vis[is.na(areaTerrestrialByFATW), areaTerrestrialByFATW := 0]

denominator <- 65076.96

server <- function(input, output) {
  
  output$mpa_area <- renderText({
    
    if(input$includeIt == 1) {
      mpalist.fatw.vis <-
        mpalist.fatw.vis[!is.na(typeOfCase) &
                           nameOfMPA != "相關漁具漁法及特定漁業禁漁區"]
    } else if(input$includeIt == 2) {
      mpalist.fatw.vis <-
        mpalist.fatw.vis[nameOfMPA != "相關漁具漁法及特定漁業禁漁區"]
    } else {
      mpalist.fatw.vis <- mpalist.fatw.vis
    }
    
    results <- mpalist.fatw.vis[basedOnNew %in% input$selectedLaw &
                                  level %in% input$selectedLevel][,
                                    .(area.total = sum(areaTotalByFATW),
                                      area.terr = sum(areaTerrestrialByFATW))]
    
    paste(round(results$area.total, 2), ' - ',
          round(results$area.terr, 2), ' = ',
          round(results$area.total - results$area.terr, 2))
  })
  
  output$mpa_ratio <- renderText({
    
    if(input$includeIt == 1) {
      mpalist.fatw.vis <-
        mpalist.fatw.vis[!is.na(typeOfCase) &
                           nameOfMPA != "相關漁具漁法及特定漁業禁漁區"]
    } else if(input$includeIt == 2) {
      mpalist.fatw.vis <-
        mpalist.fatw.vis[nameOfMPA != "相關漁具漁法及特定漁業禁漁區"]
    } else {
      mpalist.fatw.vis <- mpalist.fatw.vis
    }
    
    results <- mpalist.fatw.vis[basedOnNew %in% input$selectedLaw &
                                  level %in% input$selectedLevel][,
                                    .(area.total = sum(areaTotalByFATW),
                                      area.terr = sum(areaTerrestrialByFATW))]
    
    paste(round(((results$area.total - results$area.terr)/denominator)*100, 2), '%',
          sep = "")
  })
  
  output$mpa_twenty <- renderText({
    
    if(input$includeIt == 1) {
      mpalist.fatw.vis <-
        mpalist.fatw.vis[!is.na(typeOfCase) &
                           nameOfMPA != "相關漁具漁法及特定漁業禁漁區"]
    } else if(input$includeIt == 2) {
      mpalist.fatw.vis <-
        mpalist.fatw.vis[nameOfMPA != "相關漁具漁法及特定漁業禁漁區"]
    } else {
      mpalist.fatw.vis <- mpalist.fatw.vis
    }
    
    results <- mpalist.fatw.vis[basedOnNew %in% input$selectedLaw &
                                  level %in% input$selectedLevel][,
                                    .(area.total = sum(areaTotalByFATW),
                                      area.terr = sum(areaTerrestrialByFATW))]
    
    ratioTW <- round(((results$area.total - results$area.terr)/denominator)*100, 2)
                     
    paste(ratioTW, '%', ' - ', '20%', ' = ', ratioTW - 20, '%', sep = "")
  })
}
