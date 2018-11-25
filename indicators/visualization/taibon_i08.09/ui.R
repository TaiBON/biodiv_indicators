library(shiny)
library(ggplot2)
library(data.table)


## Input all data
Data <- fread('FishingCraftData.txt', sep = '\t',
              header = T, stringsAsFactors = F,
              encoding = 'UTF-8')


ui <- fluidPage(

  theme = 'style.css',
  
  navbarPage(
    strong("TaiBON Indicators Based on Fishing Vessel Data"),
    selected = 'I.08',
    
    tabPanel(
      'I.08',
      titlePanel(h1(strong('Visualization of TaiBON Indicator I.08'))),
      
      div(class = 'block',
          h2(strong('「漁船總噸數及每年降低的噸數」')),
          h3('關於此指標'),
          
          tabsetPanel(
            
            tabPanel('指標概述',
                     br(),
                     tags$ol(class = 'list',
                             tags$li('本指標假設一個國家的漁船總噸數與其週遭海洋生態系承受的壓力存在正相關性。漁船總噸數上升/下降，海洋生態系所承受的壓力也隨之上升/下降，而可做為反映壓力強度的監測指標。'),
                             tags$li('本指標對應', a(href = 'https://sustainabledevelopment.un.org/sdg14','Aichi Targets 6')),
                             tags$li('本指標對應', a(href = 'https://www.cbd.int/doc/strategic-plan/targets/T6-quick-guide-en.pdf','SDGs 14.4'))
                     )
            ),
            
            tabPanel('資料來源',
                     br(),
                     tags$ol(class = 'list',
                             tags$li('目前本計畫用於計算此指標的資料皆來自農委會漁業署發布至其', 
                                     a(href = 'http://www.fa.gov.tw/cht/index.aspx','官網'),
                                     '上的《漁業年報》內容，這些資料都可在此',
                                     a(href = 'http://www.fa.gov.tw/cht/PublicationsFishYear/index.aspx', '連結'),
                                     '中找到。'),
                             tags$li('截至 2017 年 10 月，漁業署官網上的《漁業年報》涵蓋的刊期範圍為 2003-2016，其中 2003-2010 年僅有 PDF 格式 (範例檔請見此',
                                     a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngaTJlcmdCNnhpWEE', '連結'),
                                     ')，2011-2016 則多了 Excel 格式 (範例檔請見此',
                                     a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngSnk2R3RWNGY2Z28', '連結'),
                                     ')。'),
                             tags$li('部分 1959-2002 年間的資料可在 2003-2016 的年報中找到 (範例檔請見此',
                                     a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngdEZ3cENBY0xvY28', '連結'),
                                     ')。'),
                             tags$li('漁業署《漁業年報》中與此指標相關之資料集 (可參考上述範例檔) 所涵蓋之資訊，2003-2016 有各「年度」、各「縣市」、各「漁法」、各「噸位」之漁船的「總船數」、「總重量」、「總馬力數」。其中「噸位」的分類方式自 2003 至 2016 維持一致；至於「縣市」和「漁法」，2003-2010 列出 25 縣市和 21 個漁法類別，2011 年後則減為 20 縣市 (刪除五都) 和 9 個漁法類別，於資料整合使用時需注意。1959-2002 則有各「年度」、各「噸位」的「總船數」。')
                     )
            ),
            
            tabPanel('資料清理',
                     br(),
                     tags$ol(class = 'list',
                             tags$li('經本計畫執行人員清理過的資料目前可透過此',
                                     a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngWVVJcS1Bc19WNW8', '連結'),
                                     '下載到。但請注意，由於原始資料狀況複雜，資料的清理實際上尚未完成。')
                     )
            ),
            
            tabPanel('侷限性')
            
          )
          
      ),
      
      h3('指標內容視覺化'),
      tabsetPanel(
        
        tabPanel('Dataset from FATW',
                 br(),
                 sidebarLayout(
                   
                   sidebarPanel(
                     checkboxGroupInput(
                       'checkGroup',
                       label = h4(class = 'inputTitle', strong('欲納入加總的漁業漁法')),
                       choices = c('單船拖網' = 1,
                                   '雙船拖網' = 2,
                                   '鰹鮪圍網' = 3,
                                   '鮪延繩釣' = 4,
                                   '魷釣' = 5,
                                   '漁業加工' = 6,
                                   '漁獲物搬運' = 7,
                                   '巾著網' = 8,
                                   '鯖圍網' = 9,
                                   '刺網' = 10,
                                   '追逐網' = 11,
                                   '鯛及雜魚延繩釣' = 12,
                                   '曳繩網' = 13,
                                   '定置漁業作業' = 14,
                                   '火誘網' = 15,
                                   '一支釣' = 16,
                                   '鏢旗魚' = 17,
                                   '雜漁業' = 18,
                                   '養殖漁業作業' = 19,
                                   '公務用' = 20,
                                   '其他' = 21),
                       selected = c(1:5, 8:18)
                     )
                   ),
                   
                   mainPanel(
                     h4(class = 'plot_title', strong('(A) 歷年漁船總噸數 (1967-2016)')),
                     plotOutput('plot_I08_00'),
                     br(),
                     h4(class = 'plot_title', strong('(B) 歷年漁船總噸數 (2003-2016)')),
                     plotOutput('plot_I08_01')
                   )
                 )
        )
      )
    ),
    
    tabPanel(
      'I.09',
      titlePanel(h1(strong('Visualization of TaiBON Indicator I.09'))),
      
      div(class = 'block',
          h2(strong('「有效漁船總數、每年減少的船數及每年新建造的船數」')),
          h3('關於此指標'),
          
          tabsetPanel(
            
            tabPanel('指標概述',
                     br(),
                     tags$ol(class = 'list',
                             tags$li('本指標假設一個國家的漁船總船數與其週遭海洋生態系承受的壓力存在正相關性。漁船總船數上升/下降，海洋生態系所承受的壓力也隨之上升/下降，而可做為反映壓力強度的監測指標。'),
                             tags$li('本指標對應', a(href = 'https://sustainabledevelopment.un.org/sdg14','Aichi Targets 6')),
                             tags$li('本指標對應', a(href = 'https://www.cbd.int/doc/strategic-plan/targets/T6-quick-guide-en.pdf','SDGs 14.4'))
                     )
            ),
            
            tabPanel('資料來源',
                     br(),
                     tags$ol(class = 'list',
                             tags$li('目前本計畫用於計算此指標的資料皆來自農委會漁業署發布至其', 
                                     a(href = 'http://www.fa.gov.tw/cht/index.aspx','官網'),
                                     '上的《漁業年報》內容，這些資料都可在此',
                                     a(href = 'http://www.fa.gov.tw/cht/PublicationsFishYear/index.aspx', '連結'),
                                     '中找到。'),
                             tags$li('截至 2017 年 10 月，漁業署官網上的《漁業年報》涵蓋的刊期範圍為 2003-2016，其中 2003-2010 年僅有 PDF 格式 (範例檔請見此',
                                     a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngaTJlcmdCNnhpWEE', '連結'),
                                     ')，2011-2016 則多了 Excel 格式 (範例檔請見此',
                                     a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngSnk2R3RWNGY2Z28', '連結'),
                                     ')。'),
                             tags$li('部分 1959-2002 年間的資料可在 2003-2016 的年報中找到 (範例檔請見此',
                                     a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngdEZ3cENBY0xvY28', '連結'),
                                     ')。'),
                             tags$li('漁業署《漁業年報》中與此指標相關之資料集 (可參考上述範例檔) 所涵蓋之資訊，2003-2016 有各「年度」、各「縣市」、各「漁法」、各「噸位」之漁船的「總船數」、「總重量」、「總馬力數」。其中「噸位」的分類方式自 2003 至 2016 維持一致；至於「縣市」和「漁法」，2003-2010 列出 25 縣市和 21 個漁法類別，2011 年後則減為 20 縣市 (刪除五都) 和 9 個漁法類別，於資料整合使用時需注意。1959-2002 則有各「年度」、各「噸位」的「總船數」。')
                     )
            ),
            
            tabPanel('資料清理',
                     br(),
                     tags$ol(class = 'list',
                             tags$li('經本計畫執行人員清理過的資料目前可透過此',
                                     a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngWVVJcS1Bc19WNW8', '連結'),
                                     '下載到。但請注意，由於原始資料狀況複雜，資料的清理實際上尚未完成。')
                     )
            ),
            
            tabPanel('侷限性')
            
          )
          
      ),
      
      h3('指標內容視覺化'),
      tabsetPanel(
        
        tabPanel('Dataset from FATW',
                 br(),
                 sidebarLayout(
                   
                   sidebarPanel(
                     checkboxGroupInput(
                       'checkGroup2',
                       label = h4(class = 'inputTitle', strong('欲納入加總的漁業漁法')),
                       choices = c('單船拖網' = 1,
                                   '雙船拖網' = 2,
                                   '鰹鮪圍網' = 3,
                                   '鮪延繩釣' = 4,
                                   '魷釣' = 5,
                                   '漁業加工' = 6,
                                   '漁獲物搬運' = 7,
                                   '巾著網' = 8,
                                   '鯖圍網' = 9,
                                   '刺網' = 10,
                                   '追逐網' = 11,
                                   '鯛及雜魚延繩釣' = 12,
                                   '曳繩網' = 13,
                                   '定置漁業作業' = 14,
                                   '火誘網' = 15,
                                   '一支釣' = 16,
                                   '鏢旗魚' = 17,
                                   '雜漁業' = 18,
                                   '養殖漁業作業' = 19,
                                   '公務用' = 20,
                                   '其他' = 21),
                       selected = c(1:5, 8:18)
                     )
                   ),
                   
                   mainPanel(
                     h4(class = 'plot_title', strong('(A) 歷年漁船總船數 (1967-2016)')),
                     plotOutput('plot_I09_00'),
                     br(),
                     h4(class = 'plot_title', strong('(B) 歷年漁船總船數 (2003-2016)')),
                     plotOutput('plot_I09_01')
                   )
                 )
        )
      )
    )
  )
)