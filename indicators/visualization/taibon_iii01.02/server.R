library(shiny)
library(ggplot2)
library(data.table)

OceanRaw <- fread(file = 'SeaMonitoringData_EPA_2018_01.txt', sep = '\t', header = T,
                  stringsAsFactors = F, encoding = 'UTF-8')

WaterGroups1 <- fread(file = 'WaterGroups_EPA_2018_01.txt', sep = '\t', header = T,
                      stringsAsFactors = F, encoding = 'UTF-8')

OceanRaw_III01 <- OceanRaw[, .(pH, DOByTitration, DOByElectrode, Cd, Pb, Hg, Cu, Zn, PH4N, year)]

pH <- OceanRaw_III01[pH %in% seq(7.5, 8.5, 0.1), .N, year][order(year)]
DO <- OceanRaw_III01[DOByTitration > 5 | DOByElectrode > 5, .N, year][order(year)]
Cd <- OceanRaw_III01[Cd <= 0.01, .N, year][order(year)]
Pb <- OceanRaw_III01[Cd <= 0.1, .N, year][order(year)]
Hg <- OceanRaw_III01[Cd <= 0.002, .N, year][order(year)]
Cu <- OceanRaw_III01[Cd <= 0.03, .N, year][order(year)]
Zn <- OceanRaw_III01[Cd <= 0.5, .N, year][order(year)]
N <- OceanRaw_III01[, .N, year][order(year)]

AClass <- ((pH$N + DO$N + Cd$N + Pb$N + Hg$N + Cu$N + Zn$N)/(N$N*8))*100
Data_III01_A <- data.table(year = 2002:2016,
                           percentage = AClass)

OceanRaw_III02 <- OceanRaw
OceanRaw_III02 <- OceanRaw_III02[WaterGroups1[, on = 'siteName'], on = 'siteName']


server <- function(input, output) {
  
  output$plot_III01_01 <- renderPlot({
    
    if(input$waterQuality == 1) {
      DataTmp <- Data_III01_A
    } else {
      DataTmp <- Data_III01_A
    }
    
    DataTmp <- ggplot(DataTmp, aes(x = year, y = percentage)) +
      geom_bar(data = DataTmp, stat = 'identity', fill = 'dark grey') +
      scale_x_continuous(name = 'Year',
                         breaks = c(2002:2016),
                         labels = c(2002:2016),
                         minor_breaks = 1) +
      scale_y_continuous(name = "Pass Rate (%)")
    
      PIII01_01 <- DataTmp + theme(axis.title = element_text(size = 16))
      PIII01_01 <- PIII01_01 + theme(axis.text = element_text(size = 14, colour = 'DarkGray'))
      PIII01_01 <- PIII01_01 + theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.85))
      PIII01_01 <- PIII01_01 + theme(axis.title.y = element_text(margin = margin(0,20,0,0)))
      PIII01_01 <- PIII01_01 + theme(axis.title.y.right = element_text(margin = margin(0,0,0,20)))
    
    print(PIII01_01)
  })
  
  output$plot_III02_01 <- renderPlot({
    
    OceanRaw_III02Tmp <- OceanRaw_III02[season %in% input$includedSeasons]
    names(OceanRaw_III02Tmp)

    if(input$aggregation == 1) {
      if(input$selectedFactor == 1) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, pH)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(pH), .(pH = mean(pH)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = pH)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "pH") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      } else if (input$selectedFactor == 2) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, chlorophyllA)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(chlorophyllA), .(chlorophyllA = mean(chlorophyllA)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = chlorophyllA)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Chlorophyll a (μg/L)") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      } else if (input$selectedFactor == 3) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Cd)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Cd), .(Cd = mean(Cd)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Cd*1000)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Cd (μg/L)") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      } else if (input$selectedFactor == 4) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Cr)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Cr), .(Cr = mean(Cr)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Cr*1000)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Cr (μg/L)") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      } else if (input$selectedFactor == 5) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Cu)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Cu), .(Cu = mean(Cu)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Cu*1000)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Cu (μg/L)") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      } else if (input$selectedFactor == 6) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Zn)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Zn), .(Zn = mean(Zn)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Zn*1000)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Zn (μg/L)") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      } else if (input$selectedFactor == 7) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Pb)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Pb), .(Pb = mean(Pb)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Pb*1000)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Pb (μg/L)") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      } else if (input$selectedFactor == 8) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Hg)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Hg), .(Hg = mean(Hg)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Hg*1000)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Hg (μg/L)") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      } else if (input$selectedFactor == 9) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, SS)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(SS), .(SS = mean(SS)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = SS)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Suspended Solids (mg/L)") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      } else if (input$selectedFactor == 10) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, DOByTitration)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(DOByTitration), .(DOByTitration = mean(DOByTitration)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = DOByTitration)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "DO determined by Titration (mg/L)") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      } else if (input$selectedFactor == 11) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, DOByElectrode)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(DOByElectrode), .(DOByElectrode = mean(DOByElectrode)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = DOByElectrode)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "DO determined by Electrode Method (mg/L)") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      } else if (input$selectedFactor == 12) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, salinity)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(salinity), .(salinity = mean(salinity)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = salinity)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Salinity (psu)") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      } else {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, waterTempeature)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(waterTempeature), .(waterTempeature = mean(waterTempeature)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = waterTempeature)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Water Temperature (Celsius)") + theme(aspect.ratio = 2/3, plot.margin = unit(c(-500,0,0,0), 'pt'))
      }
    } else if (input$aggregation == 2) {
      if(input$selectedFactor == 1) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, pH, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(pH), .(pH = mean(pH)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = pH)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "pH") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      } else if (input$selectedFactor == 2) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, chlorophyllA, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(chlorophyllA), .(chlorophyllA = mean(chlorophyllA)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = chlorophyllA)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Chlorophyll a (μg/L)") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      } else if (input$selectedFactor == 3) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Cd, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Cd), .(Cd = mean(Cd)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Cd*1000)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Cd (μg/L)") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      } else if (input$selectedFactor == 4) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Cr, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Cr), .(Cr = mean(Cr)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Cr*1000)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Cr (μg/L)") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      } else if (input$selectedFactor == 5) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Cu, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Cu), .(Cu = mean(Cu)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Cu*1000)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Cu (μg/L)") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      } else if (input$selectedFactor == 6) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Zn, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Zn), .(Zn = mean(Zn)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Zn*1000)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Zn (μg/L)") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      } else if (input$selectedFactor == 7) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Pb, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Pb), .(Pb = mean(Pb)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Pb*1000)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Pb (μg/L)") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      } else if (input$selectedFactor == 8) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Hg, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Hg), .(Hg = mean(Hg)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Hg*1000)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Hg (μg/L)") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      } else if (input$selectedFactor == 9) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, SS, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(SS), .(SS = mean(SS)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = SS)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Suspended Solids (mg/L)") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      } else if (input$selectedFactor == 10) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, DOByTitration, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(DOByTitration), .(DOByTitration = mean(DOByTitration)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = DOByTitration)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "DO determined by Titration (mg/L)") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      } else if (input$selectedFactor == 11) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, DOByElectrode, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(DOByElectrode), .(DOByElectrode = mean(DOByElectrode)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = DOByElectrode)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "DO determined by Electrode Method (mg/L)") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      } else if (input$selectedFactor == 12) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, salinity, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(salinity), .(salinity = mean(salinity)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = salinity)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Salinity (psu)") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      } else {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, waterTempeature, waterBodyGroup2)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(waterTempeature), .(waterTempeature = mean(waterTempeature)), by = .(year, waterBodyGroup2)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = waterTempeature)) + facet_wrap(~waterBodyGroup2) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Water Temperature (Celsius)") + theme(aspect.ratio = 1/1, plot.margin = unit(c(-200,0,0,0), 'pt'))
      }
    } else if (input$aggregation == 3) {
      if(input$selectedFactor == 1) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, pH, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(pH), .(pH = mean(pH)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = pH)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "pH")
      } else if (input$selectedFactor == 2) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, chlorophyllA, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(chlorophyllA), .(chlorophyllA = mean(chlorophyllA)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = chlorophyllA)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "Chlorophyll a (μg/L)")
      } else if (input$selectedFactor == 3) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Cd, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Cd), .(Cd = mean(Cd)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Cd*1000)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "Cd (μg/L)")
      } else if (input$selectedFactor == 4) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Cr, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Cr), .(Cr = mean(Cr)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Cr*1000)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "Cr (μg/L)")
      } else if (input$selectedFactor == 5) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Cu, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Cu), .(Cu = mean(Cu)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Cu*1000)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "Cu (μg/L)")
      } else if (input$selectedFactor == 6) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Zn, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Zn), .(Zn = mean(Zn)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Zn*1000)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "Zn (μg/L)")
      } else if (input$selectedFactor == 7) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Pb, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Pb), .(Pb = mean(Pb)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Pb*1000)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "Pb (μg/L)")
      } else if (input$selectedFactor == 8) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Hg, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Hg), .(Hg = mean(Hg)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Hg*1000)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "Hg (μg/L)")
      } else if (input$selectedFactor == 9) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, SS, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(SS), .(SS = mean(SS)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = SS)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "Suspended Solids (mg/L)")
      } else if (input$selectedFactor == 10) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, DOByTitration, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(DOByTitration), .(DOByTitration = mean(DOByTitration)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = DOByTitration)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "DO determined by Titration (mg/L)")
      } else if (input$selectedFactor == 11) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, DOByElectrode, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(DOByElectrode), .(DOByElectrode = mean(DOByElectrode)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = DOByElectrode)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "DO determined by Electrode Method (mg/L)")
      } else if (input$selectedFactor == 12) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, salinity, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(salinity), .(salinity = mean(salinity)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = salinity)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "Salinity (psu)")
      } else {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, waterTempeature, waterBodyGroup3)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(waterTempeature), .(waterTempeature = mean(waterTempeature)), by = .(year, waterBodyGroup3)]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = waterTempeature)) + facet_wrap(~waterBodyGroup3, ncol = 3) + geom_line(size = 1, color = '#797474', height = 10) + labs(x = 'Year', y = "Water Temperature (Celsius)")
      }
    } else {
      if(input$selectedFactor == 1) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, pH)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(pH), .(pH = mean(pH)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = pH)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "pH")
      } else if (input$selectedFactor == 2) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, chlorophyllA)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(chlorophyllA), .(chlorophyllA = mean(chlorophyllA)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = chlorophyllA)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Chlorophyll a (μg/L)")
      } else if (input$selectedFactor == 3) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Cd)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Cd), .(Cd = mean(Cd)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Cd)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Chlorophyll a (mg/L)")
      } else if (input$selectedFactor == 4) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Cr)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Cr), .(Cr = mean(Cr)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Cr)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Chlorophyll a (mg/L)")
      } else if (input$selectedFactor == 5) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Cu)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Cu), .(Cu = mean(Cu)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Cu)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Chlorophyll a (mg/L)")
      } else if (input$selectedFactor == 6) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Zn)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Zn), .(Zn = mean(Zn)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Zn)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Chlorophyll a (mg/L)")
      } else if (input$selectedFactor == 7) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Pb)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Pb), .(Pb = mean(Pb)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Pb)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Chlorophyll a (mg/L)")
      } else if (input$selectedFactor == 8) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, Hg)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(Hg), .(Hg = mean(Hg)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = Hg)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Chlorophyll a (mg/L)")
      } else if (input$selectedFactor == 9) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, SS)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(SS), .(SS = mean(SS)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = SS)) + geom_line(size = 1, color = '#797474') + labs(x = 'Year', y = "Chlorophyll a (mg/L)")
      } else if (input$selectedFactor == 10) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, DOByTitration)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(DOByTitration), .(DOByTitration = mean(DOByTitration)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = DOByTitration)) + geom_line(size = 1, color = '#797474')
      } else if (input$selectedFactor == 11) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, DOByElectrode)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(DOByElectrode), .(DOByElectrode = mean(DOByElectrode)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = DOByElectrode)) + geom_line(size = 1, color = '#797474')
      } else if (input$selectedFactor == 12) {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, salinity)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(salinity), .(salinity = mean(salinity)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = salinity)) + geom_line(size = 1, color = '#797474')
      } else {
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[, .(year, waterTempeature)]
        OceanRaw_III02Tmp <- OceanRaw_III02Tmp[!is.na(waterTempeature), .(waterTempeature = mean(waterTempeature)), by = year]
        P <- ggplot(OceanRaw_III02Tmp, aes(x = year, y = waterTempeature)) + geom_line(size = 1, color = '#797474')
      }
    }
    
    P <- P + scale_x_continuous(breaks = seq(2004, 2016, 4), labels = seq(2004, 2016, 4), minor_breaks = 1)
    P <- P + theme(axis.title = element_text(size = 16))
    P <- P + theme(axis.text.y = element_text(size = 14, colour = 'DarkGray'))
    P <- P + theme(axis.text.x = element_text(size = 10, colour = 'DarkGray'))
    P <- P + theme(axis.text.x = element_text(angle = 45, hjust = 0.75, vjust = 0.85))
    P <- P + theme(axis.title.y = element_text(margin = margin(0,20,0,0)))
    P <- P + theme(strip.text = element_text(size = 14, colour = '#797474', hjust = 0, family = 'Microsoft JhengHei'))
    P <- P + theme(strip.background=element_rect(fill="white"))
    print(P)
  })
  
}