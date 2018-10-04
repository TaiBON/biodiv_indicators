library(shiny)
library(ggplot2)
library(data.table)


## 匯入資料
DataBefore2003 <- fread('FishingDataBefore2003Processed_FATW_2018_01.txt', sep = '\t',
                        header = T, stringsAsFactors = F,
                        encoding = 'UTF-8')
DataAfter2003 <- fread('FishingDataAfter2003Processed_FATW_2018_01.txt', sep = '\t',
                       header = T, stringsAsFactors = F,
                       encoding = 'UTF-8')

## 統一漁法編碼
FishingMethodCodes <- fread('FishingMethodCodes.txt', sep = '\t',
                            header = T, stringsAsFactors = F,
                            encoding = 'UTF-8')
DataBefore2003 <- merge(DataBefore2003, FishingMethodCodes, by = 'fishingMethodCodeAppliedByFA')
DataAfter2003 <- merge(DataAfter2003, FishingMethodCodes, by = 'fishingMethodCodeAppliedByFA')

## 除去漁獲量為 NA 或 0 的記錄
DataBefore2003 <- DataBefore2003[fishingQuantityInTon != 0][!is.na(fishingQuantityInTon)]
DataAfter2003 <- DataAfter2003[fishingQuantityInTon != 0][!is.na(fishingQuantityInTon)]

## 除去遠洋漁業
DataBefore2003 <- DataBefore2003[fishingMethodCode > 1099]
DataAfter2003 <- DataAfter2003[fishingMethodCode > 1099]

## 除去淡水生物和不該被計入分析對象的分類群
excluded <- fread('TaxonsThatShouldBeExcluded.txt', sep = '\t',
                  header = F, stringsAsFactors = F,
                  encoding = 'UTF-8')
excluded_i04 <- excluded$V1
excluded_i01 <- excluded_i04[-c(23, 39)]
DataAfter2003_i04 <- DataAfter2003[!taxonID %in% excluded_i04,]
DataAfter2003_i01 <- DataAfter2003[!taxonID %in% excluded_i01,]

## 由於 taxonID set 有所不同，將資料以 2013 年為界分成兩組處理
DataBefore2013 <- DataAfter2003_i04[year < 2014]
DataAfter2013 <- DataAfter2003_i04[year > 2013]


## I.01
DataAfter2003Copy <- copy(DataAfter2003)
Data_i01 <- rbind(
  DataBefore2003[year < 2003, .(fishingMethodCode,
                                fishingQuantityInTon, year)],
  DataAfter2003Copy[, .(fishingQuantityInTon = sum(fishingQuantityInTon)),
                    by = .(year, fishingMethodCode)]
)
Data_i01[fishingMethodCode > 3000, fishingType := 'coastal'][
  fishingMethodCode < 3000, fishingType := 'offshore']


## I.04
TaxonLists <- fread('TaxonTLs.txt', sep = '\t',
                    header = T, stringsAsFactors = F,
                    encoding = 'UTF-8')
TaxonTLs <- TaxonLists[, c('year', 'taxonID', 'FBthenSAU2Modified',
                         'SAU2thenFBModified')]
TaxonTLs2013 <- TaxonTLs[year == 2013]
DataBefore2013 <- DataBefore2013[TaxonTLs2013[, on = 'taxonID'], on = 'taxonID', nomatch = 0]
TaxonTLs2016 <- TaxonTLs[year == 2016]
DataAfter2013 <- DataAfter2013[TaxonTLs2016[, on = 'taxonID'], on = 'taxonID', nomatch = 0]
Data_i04 <- rbind(DataBefore2013, DataAfter2013)

# 確認是否所有被列入分析的分類群都有 TL 值
unique(DataBefore2013[is.na(FBthenSAU2Modified), taxonID])
unique(DataAfter2013[is.na(FBthenSAU2Modified), taxonID])
# 除去 "其他海水魚類"
DataBefore2013 <- DataBefore2013[!taxonID == 6000]
DataBefore2013 <- DataBefore2013[!taxonID == 62999]


## 設置 server 物件
server <- function(input, output) {
  
  output$plot_I01_01 <- renderPlot({
    
    Data_i01tmp <- Data_i01[year %in% input$yearRange[1]:input$yearRange[2]][
      , .(sum = sum(fishingQuantityInTon)), by = .(year, fishingType)]
    
    Data_i01tmp_1 <- copy(Data_i01)
    Data_i01tmp_1[year %in% input$yearRange[1]:input$yearRange[2],
                  sum := sum(fishingQuantityInTon), by = .(fishingType, year)][
                    , percentage := (fishingQuantityInTon/sum)*100,
                    by = .(fishingType, year, fishingMethodCode)]

    PI01_01 <- ggplot(Data_i01tmp, aes(x = year)) +
      geom_bar(data = Data_i01tmp_1[fishingMethodCode == input$coastal],
               aes(y = percentage), stat = 'identity', fill = 'dark grey') +
      geom_line(data = Data_i01tmp[fishingType == 'coastal'],
                aes(y = sum/1000)) +
      scale_x_continuous(name = 'Year',
                         breaks = c(1959, seq(1965, 2010, by = 5), 2016),
                         labels = c(1959, seq(1965, 2010, by = 5), 2016),
                         minor_breaks = 10) +
      scale_y_continuous(name = "Yield of Catch (kt)",
                         sec.axis = sec_axis(~.*1, name = 'Percentage (%)'))

    PI01_01 <- PI01_01 + theme(axis.title = element_text(size = 16))
    PI01_01 <- PI01_01 + theme(axis.text = element_text(size = 14, colour = 'DarkGray'))
    PI01_01 <- PI01_01 + theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.85))
    PI01_01 <- PI01_01 + theme(axis.title.y = element_text(margin = margin(0,20,0,0)))
    PI01_01 <- PI01_01 + theme(axis.title.y.right = element_text(margin = margin(0,0,0,20)))

    print(PI01_01)
  })
  
  output$plot_I01_02 <- renderPlot({
    
    Data_i01tmp <- Data_i01[year %in% input$yearRange[1]:input$yearRange[2]][
      , .(sum = sum(fishingQuantityInTon)), by = .(year, fishingType)]
    
    Data_i01tmp_2 <- copy(Data_i01)
    Data_i01tmp_2[year %in% input$yearRange[1]:input$yearRange[2],
                  sum := sum(fishingQuantityInTon), by = .(fishingType, year)][
                    , percentage := (fishingQuantityInTon/sum)*100,
                    by = .(fishingType, year, fishingMethodCode)]
    
    PI01_02 <- ggplot(Data_i01tmp, aes(x = year)) +
      geom_bar(data = Data_i01tmp_2[fishingMethodCode == input$offshore],
               aes(y = percentage*10), stat = 'identity', fill = 'dark grey') +
      geom_line(data = Data_i01tmp[fishingType == 'offshore'],
                aes(y = sum/1000)) +
      scale_x_continuous(name = 'Year',
                         breaks = c(1959, seq(1965, 2010, by = 5), 2016),
                         labels = c(1959, seq(1965, 2010, by = 5), 2016),
                         minor_breaks = 10) +
      scale_y_continuous(name = "Yield of Catch (kt)",
                         sec.axis = sec_axis(~.*0.1, name = 'Percentage (%)'))
    
    PI01_02 <- PI01_02 + theme(axis.title = element_text(size = 16))
    PI01_02 <- PI01_02 + theme(axis.text = element_text(size = 14, colour = 'DarkGray'))
    PI01_02 <- PI01_02 + theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.85))
    PI01_02 <- PI01_02 + theme(axis.title.y = element_text(margin = margin(0,20,0,0)))
    PI01_02 <- PI01_02 + theme(axis.title.y.right = element_text(margin = margin(0,0,0,20)))
    
    print(PI01_02)
  })
  
  output$plot_I04_01 <- renderPlot({
    
    Data_i04Tmp <- copy(Data_i04)
    
    if (input$selected == 1) {
      Data_i04Tmp <- Data_i04Tmp[FBthenSAU2Modified >= input$threshold,]
      Data_i04Tmp_1 <- Data_i04Tmp[, sum := sum(fishingQuantityInTon), by = year][
        , .(yield = sum(fishingQuantityInTon),
        MTL = sum((fishingQuantityInTon/sum)*FBthenSAU2Modified)),
        by = year]
    } else {
      Data_i04Tmp <- Data_i04Tmp[FBthenSAU2Modified >= input$threshold,]
      Data_i04Tmp_1 <- Data_i04Tmp[, sum := sum(fishingQuantityInTon), by = year][
        , .(yield = sum(fishingQuantityInTon),
        MTL = sum((fishingQuantityInTon/sum)*SAU2thenFBModified)),
        by = year]
    }

    P <- ggplot(Data_i04Tmp_1, aes(x = year, y = MTL)) + 
      geom_line() + geom_point(size = 3) + labs(x = 'Year', y = "Mean Trophic Index")
    
    P <- P + scale_x_continuous(breaks = 2003:2016, labels = 2003:2016,
                                minor_breaks = 1)
    P <- P + theme(axis.title = element_text(size = 16))
    P <- P + theme(axis.text = element_text(size = 14, colour = 'DarkGray'))
    P <- P + theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.85))
    P <- P + theme(axis.title.y = element_text(margin = margin(0,20,0,0)))

    print(P)
    
  })
  
  output$plot_I05_01 <- renderPlot({
    
    Data_i04Tmp <- copy(Data_i04)
    
    if (input$selectedTLsForFiB == 1) {
      Data_i04Tmp <- Data_i04Tmp[FBthenSAU2Modified >= input$thresholdForFiB,]
      Data_i04Tmp_1 <- Data_i04Tmp[, sum := sum(fishingQuantityInTon), by = year][
        , .(yield = sum(fishingQuantityInTon),
            MTL = sum((fishingQuantityInTon/sum)*FBthenSAU2Modified)),
        by = year]
    } else {
      Data_i04Tmp <- Data_i04Tmp[FBthenSAU2Modified >= input$thresholdForFiB,]
      Data_i04Tmp_1 <- Data_i04Tmp[, sum := sum(fishingQuantityInTon), by = year][
        , .(yield = sum(fishingQuantityInTon),
            MTL = sum((fishingQuantityInTon/sum)*SAU2thenFBModified)),
        by = year]
    }
    
    FiB0 <- Data_i04Tmp_1[year == input$selectedYear, log(yield*(input$effiency)^(-MTL), 10)]
    FiBs <- copy(Data_i04Tmp_1)
    FiBs <- FiBs[, FiB := log(yield*(input$effiency)^(-MTL), 10) - FiB0, by = year]
    
    PFiB <- ggplot(data = FiBs, aes(x = year, y = FiB)) +
      geom_line() + geom_point(size = 3) + labs(x = 'Year', y = "Fishing-in-Balance Index")
    
    PFiB <- PFiB + scale_x_continuous(breaks = 2003:2016, labels = 2003:2016,
                                      minor_breaks = 1)
    PFiB <- PFiB + theme(axis.title = element_text(size = 16))
    PFiB <- PFiB + theme(axis.text = element_text(size = 14, colour = 'DarkGray'))
    PFiB <- PFiB + theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.85))
    PFiB <- PFiB + theme(axis.title.y = element_text(margin = margin(0,20,0,0)))
    
    print(PFiB)
    
  })
  
}