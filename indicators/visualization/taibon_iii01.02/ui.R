library(shiny)
library(ggplot2)
library(data.table)

ui <- fluidPage(
  
  theme = 'style.css',
  
  navbarPage(strong('TaiBON Indicators Based on Water Monitoring Data'),
             selected = 'III.02',
             
             tabPanel('III.01',
                      titlePanel(h1(strong('Visualization of TaiBON Indicator III.01'))),
                      
                      div(class = 'block',
                          h2(strong('「海域環境水質監測數據的合格率」')),
                          h3('關於此指標', class = 'secTitles'),
                          
                          tabsetPanel(
                            tabPanel(
                              '指標概述',
                              br(),
                              tags$ol(class = 'list',
                                      tags$li('本指標源於永續發展指標。其內容係以法規',
                                              a(href = 'http://www.rootlaw.com.tw/LawArticle.aspx?LawID=A040370000001900-0901226','《海域環境分類及海洋環境品質標準》'),
                                              '中所規定之「甲類」和「乙類」海域海洋環境品質標準為評斷水質時的準據，分別就每年度所有監測記錄中之酸鹼值、溶氧量、鎘含量、銅含量、鉛含量、鋅含量、汞含量等七項水質因子進行評量，並計算各項水質因子的合格筆數，將所有合格筆數加總後除以總監測筆數，即得合格率'),
                                      tags$li('本指標對應', a(href = 'https://www.cbd.int/sp/targets/rationale/target-8/','Aichi Targets 8')),
                                      tags$li('本指標對應', a(href = 'https://sustainabledevelopment.un.org/sdg14','SDGs 14.1'))
                              )
                            ),
                            tabPanel(
                              '資料來源',
                              br(),
                              tags$ol(class = 'list',
                                      tags$li('目前本計畫用於計算此指標的資料皆來自環保署發布至其', 
                                              a(href = 'http://www.fa.gov.tw/cht/index.aspx','全國環境水質監測資訊網'),
                                              '上之《水質年報》中的海域水質監測資料，這些資料都可在此',
                                              a(href = 'https://wq.epa.gov.tw/Code/Report/DownloadList.aspx', '連結'),
                                              '的「海域水質」分頁中找到。'),
                                      tags$li('截至 2017 年 10 月，全國環境水質監測資訊網上的《水質年報》涵蓋的刊期範圍為 1976-2016，而環保署對台灣海域水質的長期監測始自 2002 年，故目前海水水質監測資料所橫跨的年份為 2002-2016，皆有 CSV 格式檔 (範例檔請見此',
                                              a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngMWdSdHBxNjVKSUk', '連結'), ')。'),
                                      tags$li('2002-2004，環保署針對海域水質監測所架設的測站有 97 座，地理範圍涵蓋台灣本島及澎湖沿海。2005 年後又陸續增設數座測站，並將金馬地區也納入監測範圍，截至 2016 年已有 105 座測站。各測站之地理分布，可參考此取自 2016 年《水質年報》的',
                                              a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngdlhBTm1RS3JhS1E', '分布圖'), '。'),
                                      tags$li('環保署《水質年報》中與此指標相關之資料集 (可參考上述範例檔) 所涵蓋之資訊，包括各「測站」(含「測站名稱」及「測站編號」) 於特定「日期」在其所屬「海域」之「水深 1 公尺處」所量測到的 19 項水質因子測值，並記錄當時「空氣中的溫度」。19 項水質因子為「水溫」、「鹽度」、「酸鹼度」、「以滴定法測定之溶氧量」、「以電極法測定之溶氧量」、「溶氧飽和度」、「懸浮固體」、「葉綠素 a」、「氨氮」、「硝酸鹽氮」、「亞硝酸鹽氮」、「正磷酸鹽」、「矽酸鹽」、「鎘」、「鉻」、「銅」、「鋅」、「鉛」、「汞」。')
                              )
                            ),
                            tabPanel(
                              '資料清理',
                              br(),
                              tags$ol(class = 'list',
                                      tags$li('經本計畫執行人員清理或調整過的資料目前可透過此',
                                              a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngeklQbVcyMnN4YUk', '連結'),
                                              '下載到。此調整過的版本與原資料在內容上差異不大，主要的差異有四點：(1) 將原資料表單徹底轉為 data frame 的形式；(2) 所有低於偵測極限的數值 (係指於原資料中被以 "< number" 形式表示者) 皆被轉為數值 0，並另立新的欄位來容納該筆測量的偵測極限數值，如於原欄位「鎘」中數值為 "<0.00001" 的記錄，其資訊會被拆解入兩個新的欄位 "Cd" (置入數值 "0") 和 "CdMethodLimit" (置入數值 "0.00001") 中；(3) 原資料表單中被以 "--" 表示者，皆視為「由於並無進行測量故並無測值」，而一律轉為 "NA" 符號；(4) 內容分隔符號改為 TAB。'),
                                      tags$li('105 座測站的座標可透過此',
                                              a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngSkRjOVR6c3JUR1U', '連結'),
                                              '下載到。')
                              )
                            ),
                            tabPanel(
                              '侷限性',
                              br(),
                              h4(class = 'limitType', strong('指標層面的問題')),
                              tags$ol(class = 'list',
                                      tags$li(
                                        '不同水域 (例如河口與開放海域) 其水質因子的背景值可能會有很大的差異，故單一的評比標準有可能無法客觀反映污染狀況。'
                                      )
                              )
                                     
                            )
                          )
                      ),
                      
                      hr(),
                      h3('指標內容視覺化', class = 'secTitles'),
                      
                      tabsetPanel(
                        tabPanel('Data from EPATW',
                                 br(),
                                 sidebarLayout(
                                   sidebarPanel(
                                     h3(class = 'inputTitle', strong('說明')),
                                     p(class = 'visualization',
                                       '本頁面之長條圖顯示了台灣歷年沿海水域的甲乙類水質標準合格率。您可以透過下方「水質標準」中所提供的選項來指定您希望採行的水質標準 (目前僅有《海域環境分類及海洋環境品質標準》中所規定之甲乙類標準可供選擇。)'
                                     ),
                                     selectInput(
                                       'waterQuality',
                                       label = h4(strong('水質標準'), class = 'inputTitle'),
                                       choices = list(
                                         '台灣法規《海域環境分類及海洋環境品質標準》中規定之甲乙類標準' = 1
                                       ),
                                       selected = 1
                                     )
                                   ),
                                   
                                   mainPanel(
                                     plotOutput('plot_III01_01')
                                   )
                                 )
                        )
                      )
             ),
             
             tabPanel(
               'III.02',
               titlePanel(h1(strong('Visualization of TaiBON Indicator III.02'))),
               
               div(class = 'block',
                   h2(strong('「在海域及港口設置水質固定測站以定期長期監測水質因子的變化」')),
                   h3('關於此指標', class = 'secTitles'),
                   
                   tabsetPanel(
                     tabPanel(
                       '指標概述',
                       br(),
                       tags$ol(class = 'list',
                               tags$li('本指標源於 2015-2016 年間海域專家會中針對 TaiBON Indicator III.01 所提出的建議，即相較呈現以單一標準計算出之「合格率」，不如直接呈現各水質因子測值的年度變化趨勢。目前本頁面中已初步完成其資料視覺化的水質因子包括「水溫」、「鹽度」、「酸鹼度」、「以電極法測定之溶氧量」、「懸浮固體」、「葉綠素 a」、「鎘」、「鉻」、「銅」、「鋅」、「鉛」、「汞」。'),
                               tags$li('本指標目前以「年度」為觀察各水質因子趨勢變化的基本單位。在此前提下，勢必得計算各水質因子的年平均數，而計算年平均數前「如何對資料進行叢集」仍屬開放議題。本頁面目前設置了三個做法：一為不做任何資料叢集、直接計算全台 (含各離島) 各水質因子的平均值。二為參考環保署《水質年報》中的做法，以鼻頭角、高屏溪出海口、曾文溪出海口、王功漁港為界，將台灣本島周圍海域劃分為 4 個區域，並分別計算年平均值。三為參考此',
                                       a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngdlhBTm1RS3JhS1E', '分布圖'),
                                       '中各測站的位置，將其主觀分為 18 個區域後分別計算年平均值。'),
                               tags$li('本指標對應', a(href = 'https://www.cbd.int/sp/targets/rationale/target-8/','Aichi Targets 8')),
                               tags$li('本指標對應', a(href = 'https://sustainabledevelopment.un.org/sdg14','SDGs 14.1'))
                       )
                     ),
                     tabPanel(
                       '資料來源',
                       br(),
                       tags$ol(class = 'list',
                               tags$li('目前本計畫用於計算此指標的資料皆來自環保署發布至其', 
                                       a(href = 'http://www.fa.gov.tw/cht/index.aspx','全國環境水質監測資訊網'),
                                       '上之《水質年報》中的海域水質監測資料，這些資料都可在此',
                                       a(href = 'https://wq.epa.gov.tw/Code/Report/DownloadList.aspx', '連結'),
                                       '的「海域水質」分頁中找到。'),
                               tags$li('截至 2017 年 10 月，全國環境水質監測資訊網上的《水質年報》涵蓋的刊期範圍為 1976-2016，而環保署對台灣海域水質的長期監測始自 2002 年，故目前海水水質監測資料所橫跨的年份為 2002-2016，皆有 CSV 格式檔 (範例檔請見此',
                                       a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngMWdSdHBxNjVKSUk', '連結'), ')。'),
                               tags$li('2002-2004，環保署針對海域水質監測所架設的測站有 97 座，地理範圍涵蓋台灣本島及澎湖沿海。2005 年後又陸續增設數座測站，並將金馬地區也納入監測範圍，截至 2016 年已有 105 座測站。各測站之地理分布，可參考此取自 2016 年《水質年報》的',
                                       a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngdlhBTm1RS3JhS1E', '分布圖'), '。'),
                               tags$li('環保署《水質年報》中與此指標相關之資料集 (可參考上述範例檔) 所涵蓋之資訊，包括各「測站」(含「測站名稱」及「測站編號」) 於特定「日期」在其所屬「海域」之「水深 1 公尺處」所量測到的 19 項水質因子測值，並記錄當時「空氣中的溫度」。19 項水質因子為「水溫」、「鹽度」、「酸鹼度」、「以滴定法測定之溶氧量」、「以電極法測定之溶氧量」、「溶氧飽和度」、「懸浮固體」、「葉綠素 a」、「氨氮」、「硝酸鹽氮」、「亞硝酸鹽氮」、「正磷酸鹽」、「矽酸鹽」、「鎘」、「鉻」、「銅」、「鋅」、「鉛」、「汞」。')
                       )
                     ),
                     tabPanel(
                       '資料清理',
                       br(),
                       tags$ol(class = 'list',
                               tags$li('經本計畫執行人員清理或調整過的資料目前可透過此',
                                       a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngeklQbVcyMnN4YUk', '連結'),
                                       '下載到。此調整過的版本與原資料在內容上差異不大，主要的差異有四點：(1) 將原資料表單徹底轉為 data frame 的形式；(2) 所有低於偵測極限的數值 (係指於原資料中被以 "< number" 形式表示者) 皆被轉為數值 0，並另立新的欄位來容納該筆測量的偵測極限數值，如於原欄位「鎘」中數值為 "<0.00001" 的記錄，其資訊會被拆解入兩個新的欄位 "Cd" (置入數值 "0") 和 "CdMethodLimit" (置入數值 "0.00001") 中；(3) 原資料表單中被以 "--" 表示者，皆視為「由於並無進行測量故並無測值」，而一律轉為 "NA" 符號；(4) 內容分隔符號改為 TAB。'),
                               tags$li('105 座測站的座標可透過此',
                                       a(href = 'https://drive.google.com/open?id=0B873V0xzs-ngSkRjOVR6c3JUR1U', '連結'),
                                       '下載到。')
                       )
                     ),
                     tabPanel('侷限性'
                              
                     )
                   )
               ),
               
               hr(),
               h3('指標內容視覺化', class = 'secTitles'),
               
               tabsetPanel(
                 tabPanel('Data from EPATW',
                          br(),
                          sidebarLayout(
                            sidebarPanel(
                              h3(class = 'inputTitle', strong('說明')),
                              p(class = 'visualization',
                                '本頁面各折線圖皆顯示了歷年台灣沿近海特定水質因子的變化趨勢，您可以透過下方「水質因子列表」中所提供的列表來選定感興趣的因子。您也可以透過「請選擇資料叢集方式」中所提供的選項來選定您在計算水質因子年平均數前想採納的資料叢集方式。選項中，「不分區直接計算年平均」代表不對資料做任何叢集、直接計算全台的年平均值；「分區計算年平均 - 參考《水質年報》」則參考《水質年報》，將台灣本島周邊海域分成 4 區；「分區計算年平均 - 主觀認定」則根據 105 座測站的位置，將監測的海域範圍主觀分成 18 區。若您認為特定水質因子存在明顯的季節變化，「所欲包含的季度」可讓您選定那些季度的測值該被列入計算。'
                              ),
                              h3(strong('請選擇環境測值'), class = 'inputTitle2'),
                              selectInput(
                                'selectedFactor',
                                label = h4(strong('水質因子列表'), class = 'inputTitle'),
                                choices = list(
                                  '酸鹼值' = 1,
                                  '葉綠素 a 含量' = 2,
                                  '重金屬含量-鎘' = 3,
                                  '重金屬含量-鉻' = 4,
                                  '重金屬含量-銅' = 5,
                                  '重金屬含量-鋅' = 6,
                                  '重金屬含量-鉛' = 7,
                                  '重金屬含量-汞' = 8,
                                  '懸浮微粒' = 9,
                                  '溶氧量-以電極法' = 11,
                                  '鹽度' = 12,
                                  '水溫' = 13
                                ),
                                selected = 1
                              ),
                              br(),
                              selectInput(
                                'aggregation',
                                label = h3(strong('請選擇資料叢集方式'), class = 'inputTitle2'),
                                choices = list(
                                  '不分區直接計算年平均' = 1,
                                  '分區計算年平均 - 參考《水質年報》' = 2,
                                  '分區計算年平均 - 主觀認定' = 3
                                ),
                                selected = 1
                              ),
                              checkboxGroupInput(
                                'includedSeasons',
                                label = h4(strong('所欲包含的季度'), class = 'inputTitle'),
                                choices = list(
                                  '1st Jan-Mar' = 1,
                                  '2ed Apr-Jun' = 2,
                                  '3rd Jul-Sep' = 3,
                                  '4rd Oct-Dec' = 4
                                ),
                                selected = 1:4
                              )
                            ),
                            
                            mainPanel(
                              plotOutput('plot_III02_01', height = '1000px')
                            )
                          )
                 )
               )
             )
  )
)