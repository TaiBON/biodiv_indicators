library(shiny)
library(ggplot2)
library(data.table)

ui <- fluidPage(
  
  theme = 'style.css',
  
  navbarPage(strong('TaiBON Indicators Based on Marine or Beach Waste Data'),
             selected = 'III.04',
             
             tabPanel('III.04',
                      titlePanel(h1(strong('Visualization of TaiBON Indicator III.04'))),
                      
                      div(class = 'block',
                          h2(strong('「每年淨灘之垃圾噸數與分類數據」')),
                          h3('關於此指標', class = 'secTitles'),
                          
                          tabsetPanel(
                            tabPanel('指標概述'
                                     
                            ),
                            tabPanel('資料來源'
                                     
                            ),
                            tabPanel('資料清理'
                                     
                            ),
                            tabPanel('侷限性'
                                     
                            )
                          )
                      ),
                      
                      hr(),
                      h3('指標內容視覺化', class = 'secTitles'),
                      
                      tabsetPanel(
                        tabPanel('Data from Power Plants',
                                 br(),
                                 sidebarLayout(
                                   sidebarPanel(
                                     selectInput(
                                       'aggregation',
                                       label = h3(strong('請選擇資料叢集方式'), class = 'inputTitle2'),
                                       choices = list(
                                         '不分區計算年平均' = 1,
                                         '不分區計算月平均' = 2,
                                         '分電廠計算年平均' = 3,
                                         '分電廠計算月平均' = 4
                                       ),
                                       selected = 4
                                     ),
                                     checkboxGroupInput(
                                       'includedMonths',
                                       label = h4(strong('所欲包含的月份'), class = 'inputTitle'),
                                       choices = list(
                                         '一月' = 1,
                                         '二月' = 2,
                                         '三月' = 3,
                                         '四月' = 4,
                                         '五月' = 5,
                                         '六月' = 6,
                                         '七月' = 7,
                                         '八月' = 8,
                                         '九月' = 9,
                                         '十月' = 10,
                                         '十一月' = 11,
                                         '十二月' = 12
                                       ),
                                       selected = 1:12
                                     )
                                   ),
                                   
                                   mainPanel(
                                     plotOutput('plot_III04_01')
                                   )
                                 )
                        ),
                        tabPanel('Data from WDPA'
                                 
                        )
                      )
             )
  )
)