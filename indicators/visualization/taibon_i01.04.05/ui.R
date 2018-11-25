library(shiny)
library(ggplot2)
library(data.table)

ui <- fluidPage(
  
  theme = 'style.css',
  
  navbarPage(strong("TaiBON Indicators Based on 'Yield of Catch' Data"),
             selected = 'I.01',
              
    tabPanel('I.01',
             titlePanel(h1(strong('Visualization of TaiBON Indicator I.01'))),
             
             div(class = 'block',
               h2(strong('「沿近海漁業別漁獲量」')),
               h3('關於此指標', class = 'secTitles'),
               
               tabsetPanel(
                 
                 tabPanel('指標概述',
                          br(),
                          tags$ol(class = 'list',
                                  tags$li('本指標用於呈現歷年沿岸漁業和近海漁業中各漁業漁法之漁獲量的年變化趨勢，希望藉此反映台灣對各類漁業漁法之利用程度及特定種類漁法之捕獲量佔總漁獲量比率的年變化趨勢。'),
                                  tags$li('本指標對應', a(href = 'https://www.cbd.int/sp/targets/rationale/target-6/','Aichi Targets 6')),
                                  tags$li('本指標對應', a(href = 'https://sustainabledevelopment.un.org/sdg14','SDGs 14.4'))
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
                                          a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngMEJhaFJPaFFsVXM', '連結'),
                                          ')，2011-2016 則多了 Excel 格式 (範例檔請見此',
                                          a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngWEFHNUZxSnM4Nm8', '連結'),
                                          ')。'),
                                  tags$li('部分 1959-2002 年間的資料可在 2003-2016 的年報中找到 (範例檔請見此',
                                          a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngUWpOdUdWZGNWYUE', '連結'),
                                          ')。'),
                                  tags$li('漁業署《漁業年報》中與此指標相關之資料集 (可參考上述範例檔) 所涵蓋之資訊，2003-2016 有各「年度」基於各種「漁法」所捕獲到的「海洋生物分類群」之「生物量」(以噸為單位)。1959-2002 則僅有「年度」、「漁法」、漁獲之「生物量」等資訊。「漁法」和「海洋生物分類群」皆有漁業署所派賦的編碼，2003-2013 年和 2014 年後的編碼系統不同，於資料整合使用時需注意。')
                          )
                 ),
                 
                 tabPanel('資料清理',
                          br(),
                          tags$ol(class = 'list',
                                  tags$li('經本計畫執行人員清理過的資料目前可透過此',
                                          a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngWVVJcS1Bc19WNW8', '連結'),
                                          '下載到。但請注意，由於原始資料狀況複雜，資料的清理實際上尚未完成。'),
                                  tags$li('僅「近海漁業」和「沿岸漁業」的漁獲資料會被納入分析對象。'),
                                  tags$li('原始資料所羅列之分類群中，吳郭魚類、鯉魚、鯽魚、大頭鰱、竹葉鰱、鯁魚、淡水鯰、泥鰍、觀賞魚類、錦鯉、其他觀賞蝦、其他觀賞魚、鱒魚、香魚、長腳大蝦、蜆、牛蛙、鱉、鱉蛋由於不屬海洋生物，故被直接排除在分析對象之外。')
                          )
                 ),
                 
                 tabPanel('侷限性',
                          br(),
                          h4(class = 'limitType', strong('資料層面的問題')),
                          tags$ol(class = 'list',
                                  tags$li(
                                    '漁業署目前透過《漁業年報》發布的漁獲資料中尚不存在對漁業中棄獲 (Discards) 的記錄，故棄獲對台灣沿近海生態系之平均營養指數的影響程度難以評估。'
                                  ),
                                  tags$li(
                                    '自 1983 年漁獲場外交易合法化後，《漁業年報》中漁獲統計資料的代表性就難以評估。'
                                  )
                          )
                 )
               )
             ),
             
             hr(),
             h3('指標內容視覺化', class = 'secTitles'),
             
             br(),
             sidebarPanel(
               h3(class = 'inputTitle', strong('說明')),
               p(class = 'visualization',
                 '本頁面 A 圖和 B 圖中之折線圖分別顯示了台灣沿岸漁業和近海漁業的總漁獲量年度變化，您可以透過對下方「年度範圍」參數條的調節來鎖定您希望顯示的年度範圍。A 圖和 B 圖中之長條圖則分別代表了特定沿岸和近海漁業漁法之漁獲量佔總漁獲量比率的年度變化，您可以透過下方「沿岸漁業漁法列表」和「近海漁業漁法列表」所提供的選項來鎖定您所關注的漁業漁法。'
               ),
               sliderInput(
                 'yearRange',
                 h4(class = 'inputTitle', strong('年度範圍')),
                 min = 1959, max = 2016, value = c(1959, 2016),
                 step = 1, tick = F
               ),
               br(),
               selectInput(
                 'coastal',
                 label = h4(class = 'inputTitle', strong('沿岸漁業漁法列表')),
                 choices = list(
                   '鏢旗魚' = 3096,
                   '一支釣' = 3050,
                   '延繩釣' = 3051,
                   '定置網' = 3001,
                   '地曳網' = 3002,
                   '火誘網或焚寄網' = 3003,
                   '刺網' = 3004,
                   '追逐網' = 3005,
                   '流袋網' = 3006,
                   '勿堯漁業' = 3007,
                   '櫻花蝦漁業' = 3008,
                   '赤尾青蝦漁業' = 3009,
                   '遊憩漁業' = 3097,
                   '籠具' = 3098,
                   '其他釣具漁法' = 3079,
                   '其他網具漁法' = 3049,
                   '其他沿岸漁業' = 3099
                 ),
                 selected = 3096
               ),
               br(),
               selectInput(
                 'offshore',
                 label = h4(class = 'inputTitle', strong('近海漁業漁法列表')),
                 choices = list(
                   '一支釣' = 2053,
                   '曳繩釣' = 2052,
                   '鮪延繩釣' = 2050,
                   '雜魚延繩釣' = 2051,
                   '刺網' = 2005,
                   '巾著網' = 2001,
                   '火誘網或棒受網' = 2003,
                   '鯖參圍網' = 2002,
                   '扒網' = 2006,
                   '追逐網' = 2007,
                   '中小拖網' = 2004,
                   '珊瑚漁業' = 2097,
                   '飛魚卵漁業' = 2098,
                   '籠具' = 2096,
                   '其他釣具漁法' = 2079,
                   '其他網具漁法' = 2049,
                   '其他近海漁業' = 2099
                 ),
                 selected = 2053
               )
             ),
             br(),
             mainPanel(
               h4(class = 'plot_title', strong('(A) 沿岸漁業漁獲量年度變化趨勢圖')),
               plotOutput('plot_I01_01'),
               br(),
               h4(class = 'plot_title', strong('(B) 近海漁業漁獲量年度變化趨勢圖')),
               plotOutput('plot_I01_02')
             )
    ),
    
    tabPanel('I.04-MTI',
             titlePanel(h1(strong('Visualization of TaiBON Indicator I.04 - Mean Trophic Index'))),
             
             div(class = 'block',
                 h2(strong('「平均營養指數」')),
                 h3('關於此指標', class = 'secTitles'),
                 
                 tabsetPanel(
                   
                   tabPanel('指標概述',
                            br(),
                            tags$ol(class = 'list',
                                    tags$li('本指標假設一個國家的漁獲可被視為對該國家海洋生態系的取樣，而漁獲中海洋生物的相對豐度可視為對真實海洋生態系中海洋生物相對豐度的推估，繼以各分類群於特定年度之相對豐度為該分類群營養階層 (trophic level, TL) 之權數、各自相乘並予以加總後，計算該年度中海洋生態系的平均營養位階 (mean trophic level, MTL)，此即平均營養指數 (Mean Trophic Index, MTI)。'),
                                    tags$li('本指標對應', a(href = 'https://www.cbd.int/sp/targets/rationale/target-6/','Aichi Targets 6')),
                                    tags$li('本指標對應', a(href = 'https://sustainabledevelopment.un.org/sdg14','SDGs 14.4'))
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
                                            a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngMEJhaFJPaFFsVXM', '連結'),
                                            ')，2011-2016 則多了 Excel 格式 (範例檔請見此',
                                            a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngWEFHNUZxSnM4Nm8', '連結'),
                                            ')。'),
                                    tags$li('部分 1959-2002 年間的資料可在 2003-2016 的年報中找到 (範例檔請見此',
                                            a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngUWpOdUdWZGNWYUE', '連結'),
                                            ')。'),
                                    tags$li('漁業署《漁業年報》中與此指標相關之資料集 (可參考上述範例檔) 所涵蓋之資訊，2003-2016 有各「年度」基於各種「漁法」所捕獲到的「海洋生物分類群」之「生物量」(以噸為單位)。1959-2002 則僅有「年度」、「漁法」、漁獲之「生物量」等資訊。「漁法」和「海洋生物分類群」皆有漁業署所派賦的編碼，2003-2013 年和 2014 年後的編碼系統不同，於資料整合使用時需注意。')
                            )
                   ),
                   
                   tabPanel('資料清理',
                            br(),
                            tags$ol(class = 'list',
                                    tags$li('經本計畫執行人員清理過的資料目前可透過此',
                                            a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngWVVJcS1Bc19WNW8', '連結'),
                                            '下載到。但請注意，由於原始資料狀況複雜，資料的清理實際上尚未完成。'),
                                    tags$li('僅「近海漁業」和「沿岸漁業」的漁獲資料會被納入分析對象。'),
                                    tags$li('原始資料所羅列之分類群中，吳郭魚類、鯉魚、鯽魚、大頭鰱、竹葉鰱、鯁魚、淡水鯰、泥鰍、觀賞魚類、錦鯉、其他觀賞蝦、其他觀賞魚、鱒魚、香魚、長腳大蝦、蜆、牛蛙、鱉、鱉蛋由於不屬海洋生物，故被直接排除在分析對象之外。'),
                                    tags$li('原始資料所羅列之分類群中，飛魚卵和「其他海水魚」由於不具備與之對應的 TL 值，故被直接排除在分析對象之外。')
                            )
                   ),
                   
                   tabPanel('侷限性',
                            br(),
                            h4(class = 'limitType', strong('指標層面的問題')),
                            tags$ol(class = 'list',
                                    tags$li(
                                      '此指標是假設沿近海漁業之漁獲可被視為對台灣沿近海生態系的取樣，故漁獲中海洋生物的相對豐度可做為對台灣海洋生態系中海洋生物相對豐度的推估值，但此假設尚未被驗證。'
                                    )
                            ),
                            h4(strong(class = 'limitType', '資料層面的問題')),
                            tags$ol(class = 'list',
                                    tags$li(
                                      '漁業署目前透過《漁業年報》發布的漁獲資料中尚不存在對漁業中棄獲 (Discards) 的記錄，故棄獲對台灣沿近海生態系之平均營養指數的影響程度難以評估。'
                                    ),
                                    tags$li(
                                      '目前《漁業年報》1959-2002 的漁獲資料由於缺少「海洋生物分類群」相關資訊，暫無法用於計算此項指標。'
                                    ),
                                    tags$li(
                                      '自 1983 年漁獲場外交易合法化後，《漁業年報》中漁獲統計資料的代表性就難以評估。'
                                    )
                            )
                   )
                 )
             ),
             
             hr(),
             h3('指標內容視覺化', class = 'secTitles'),
             tabsetPanel(
               
               tabPanel('Dataset from FATW',
                        br(),
                        sidebarLayout(
                          
                          sidebarPanel(
                            h3(class = 'inputTitle', strong('說明')),
                            p(class = 'visualization',
                              '本頁面之折線圖顯示了根據《漁業年報》歷年沿近海漁獲量所計算出的 MTI。由於分類群的 TL 值並不是一種標準數值，隨著計算指標時採納之參考來源的不同，可能得到不盡相同的結果。目前此頁面提供兩種 TL 值的參考來源，您可以透過下方「分類群營養位階參考來源」所提供的選項來選定您要採納的參考來源。選項中的方案一代表以 FishBase 為首要參考對象、如有不足才參考 Sea Around Us，方案二則兩者的參考順位顛倒過來。您也可以利用「計算 MTI 時的營養位階閾值」來設定是否要將 TL 值小於特定數值的分類群排除在分析對象之外。'
                            ),
                            selectInput(
                              'selected',
                              h4(strong('分類群營養位階參考來源'), class = 'inputTitle'),
                              choices = list('方案一' = 1,
                                             '方案二' = 2),
                              selected = 1
                            ),
                            
                            sliderInput(
                              'threshold',
                              h4(strong('計算 MTI 時採用的營養位階閾值'), class = 'inputTitle'),
                              min = 1, max = 4.5, value = 3,
                              step = 0.25
                            )
                            
                          ),
                          
                          mainPanel(
                            plotOutput('plot_I04_01')
                          )
                        )
               )
               
               #tabPanel('Dataset in 2014-2016')
               
             )
    ),
    
    tabPanel('I.05-FiB',
             titlePanel(h1(strong('Visualization of TaiBON Indicator I.05 - Fishing-in-Balance Index'))),
             div(class = 'block',
                 h2(strong('「漁獲平衡指數」')),
                 h3('關於此指標', class = 'secTitles'),
                 tabsetPanel(
                   tabPanel('指標概述',
                     br(),
                     tags$ol(class = 'list',
                             tags$li('當平均營養指數 (Mean Trophic Index, MTL) 的變動趨勢呈現持續下降 (或上升) 時，有一種可能為國家的漁業政策為有見於'),
                             tags$li('本指標對應', a(href = 'https://www.cbd.int/sp/targets/rationale/target-6/','Aichi Targets 6')),
                             tags$li('本指標對應', a(href = 'https://sustainabledevelopment.un.org/sdg14','SDGs 14.4'))
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
                                     a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngMEJhaFJPaFFsVXM', '連結'),
                                     ')，2011-2016 則多了 Excel 格式 (範例檔請見此',
                                     a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngWEFHNUZxSnM4Nm8', '連結'),
                                     ')。'),
                             tags$li('部分 1959-2002 年間的資料可在 2003-2016 的年報中找到 (範例檔請見此',
                                     a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngUWpOdUdWZGNWYUE', '連結'),
                                     ')。'),
                             tags$li('漁業署《漁業年報》中與此指標相關之資料集 (可參考上述範例檔) 所涵蓋之資訊，2003-2016 有各「年度」基於各種「漁法」所捕獲到的「海洋生物分類群」之「生物量」(以噸為單位)。1959-2002 則僅有「年度」、「漁法」、漁獲之「生物量」等資訊。「漁法」和「海洋生物分類群」皆有漁業署所派賦的編碼，2003-2013 年和 2014 年後的編碼系統不同，於資料整合使用時需注意。')
                     )       
                   ),
                   tabPanel('資料清理',
                     br(),
                     tags$ol(class = 'list',
                             tags$li('經本計畫執行人員清理過的資料目前可透過此',
                                     a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngWVVJcS1Bc19WNW8', '連結'),
                                     '下載到。但請注意，由於原始資料狀況複雜，資料的清理實際上尚未完成。'),
                             tags$li('僅「近海漁業」和「沿岸漁業」的漁獲資料會被納入分析對象。'),
                             tags$li('原始資料所羅列之分類群中，吳郭魚類、鯉魚、鯽魚、大頭鰱、竹葉鰱、鯁魚、淡水鯰、泥鰍、觀賞魚類、錦鯉、其他觀賞蝦、其他觀賞魚、鱒魚、香魚、長腳大蝦、蜆、牛蛙、鱉、鱉蛋由於不屬海洋生物，故被直接排除在分析對象之外。'),
                             tags$li('原始資料所羅列之分類群中，飛魚卵和「其他海水魚」由於不具備與之對應的 TL 值，故被直接排除在分析對象之外。')
                     )
                   ),
                   tabPanel('侷限性'
                            
                   )
                 )
             ),
             
             hr(),
             h3('指標內容視覺化', class = 'secTitles'),
             tabsetPanel(
               tabPanel('Dataset from FATW',
                 br(),
                 sidebarPanel(
                   selectInput(
                     'selectedTLsForFiB',
                     h4(strong('分類群營養位階參考來源'), class = 'inputTitle'),
                     choices = list('方案一' = 1,
                                    '方案二' = 2),
                     selected = 1
                   ),
                   sliderInput(
                     'thresholdForFiB',
                     h4(strong('計算 MTI 時採用的營養位階閾值'), class = 'inputTitle'),
                     min = 1, max = 4.5, value = 3,
                     step = 0.25
                   ),
                   sliderInput(
                     'effiency',
                     h4(strong('計算 FiB 時假設的能量轉換效率'), class = 'inputTitle'),
                     min = 0.01, max = 0.3, value = 0.1,
                     step = 0.01
                   ),
                   sliderInput(
                     'selectedYear',
                     h4(strong('計算 FiB 時採用的基準年'), class = 'inputTitle'),
                     min = 2003, max = 2016, value = 2003,
                     step = 1
                   )
                 ),
                 mainPanel(
                   plotOutput('plot_I05_01')
                 )
               )
             )
    )
  )
)