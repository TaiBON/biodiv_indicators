library(shiny)
library(ggplot2)
library(data.table)

MPAList_FA <- fread(file = 'MPAList_FA.txt', sep = '\t', header = T,
                    stringsAsFactors = F, encoding = 'UTF-8')
MPAList_FA_ForDisplay <- fread(file = 'MPAList_FA_ForDisplay.txt', sep = '\t', header = F,
                               stringsAsFactors = F, encoding = 'UTF-8')
MPAList_FA_ForDisplay <- MPAList_FA_ForDisplay$V1
MPAList_FA <- MPAList_FA[ORIG_NAME %in% MPAList_FA_ForDisplay]
names(MPAList_FA)
includeIt <- 26504.85 - MPAList_FA[LAW_TW_CODE == 6, sum(ORIG_NAME_GROUP_AREA)]

server <- function(input, output) {
  output$output_II01_01 <- renderText({
    if(input$denominator == 1) {
      denominator <- 65076.96
    } else {
      denominator <- 340000
    }
    if(input$includeIt) {
      if(input$noOverlap) {
        MPAList_FATmp <- MPAList_FA[YEAR_ESTABLISH <= input$year &
                                      LAW_TW_CODE %in% input$selectedLaw &
                                      MPA_PLEVEL_TW %in% input$selectedLevel][
                                        , .(sumM = sum(ORIG_NAME_GROUP_AREA), sumL = sum(ORIG_NAME_GROUP_LAREA))]
        paste(round(((MPAList_FATmp$sumM - MPAList_FATmp$sumL)/denominator)*100, 2), '%')
      } else {
        '?'
      }
    } else {
      MPAList_FATmp <- MPAList_FA[YEAR_ESTABLISH > 1983]
      MPAList_FATmp <- MPAList_FATmp[YEAR_ESTABLISH <= input$year &
                                       LAW_TW_CODE %in% input$selectedLaw &
                                       MPA_PLEVEL_TW %in% input$selectedLevel][
                                         , .(sumM = sum(ORIG_NAME_GROUP_AREA), sumL = sum(ORIG_NAME_GROUP_LAREA))]
      paste(round(((MPAList_FATmp$sumM - MPAList_FATmp$sumL)/denominator)*100, 2), '%')
    }
  })
  
  output$output_II01_02 <- renderText({
    if(input$includeIt) {
      if(input$noOverlap) {
        MPAList_FATmp <- MPAList_FA[YEAR_ESTABLISH <= input$year &
                                      LAW_TW_CODE %in% input$selectedLaw &
                                      MPA_PLEVEL_TW %in% input$selectedLevel][
                                        , .(sumM = sum(ORIG_NAME_GROUP_AREA), sumL = sum(ORIG_NAME_GROUP_LAREA))]
        paste(round(MPAList_FATmp$sumM, 2), ' - ', round(MPAList_FATmp$sumL, 2), ' - ', 0, ' = ', round(MPAList_FATmp$sumM - MPAList_FATmp$sumL, 2))
      } else {
        MPAList_FATmp <- MPAList_FA[YEAR_ESTABLISH <= input$year &
                                      LAW_TW_CODE %in% input$selectedLaw &
                                      MPA_PLEVEL_TW %in% input$selectedLevel][
                                        , .(sumM = sum(ORIG_NAME_GROUP_AREA), sumL = sum(ORIG_NAME_GROUP_LAREA))]
        paste(round(MPAList_FATmp$sumM, 2), ' - ', '?', ' - ', '?', ' = ', '?')
      }
    } else {
      MPAList_FATmp <- MPAList_FA[YEAR_ESTABLISH > 1983]
      MPAList_FATmp <- MPAList_FATmp[YEAR_ESTABLISH <= input$year &
                                       LAW_TW_CODE %in% input$selectedLaw &
                                       MPA_PLEVEL_TW %in% input$selectedLevel][
                                         , .(sumM = sum(ORIG_NAME_GROUP_AREA), sumL = sum(ORIG_NAME_GROUP_LAREA))]
      paste(round(MPAList_FATmp$sumM, 2), ' - ', round(MPAList_FATmp$sumL, 2), ' - ', 0, ' = ', round(MPAList_FATmp$sumM + MPAList_FATmp$sumL, 2))
    }
  })
  
  output$output_II01_03 <- renderText({
    if(input$denominator == 1) {
      denominator <- 65076.96
    } else {
      denominator <- 340000
    }
    denominator
  })
}