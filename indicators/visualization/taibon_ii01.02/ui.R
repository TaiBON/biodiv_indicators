library(shiny)
library(ggplot2)
library(data.table)

ui <- fluidPage(
  
  theme = 'style.css',
  
  navbarPage(strong('TaiBON Indicators Based on Area of MPAs'),
             selected = 'II.01',
    
    tabPanel('II.01',
      titlePanel(h1(strong('Visualization of TaiBON Indicator II.01'))),
      
      div(class = 'block',
          h2(strong('「海洋保護區的數目、面積及其佔專屬經濟水域之面積比」')),
          h3('關於此指標', class = 'secTitles'),
          
          tabsetPanel(
            tabPanel(
              '指標概述',
              br(),
              tags$ol(class = 'list',
                      tags$li('本指標意欲與 Aichi Targets 11 及 SDGs 14.5 「在西元 2020 年以前，依照國家與國際法規，以及可取得的最佳科學資訊，保護至少 10% 的海岸與海洋區」直接接軌，即台灣疆域內被劃入海洋保護區之海域總面積及該面積佔台灣所管轄之海域總面積的比值。'),
                      tags$li('本指標對應', a(href = 'https://www.cbd.int/sp/targets/rationale/target-11/','Aichi Targets 11')),
                      tags$li('本指標對應', a(href = 'https://sustainabledevelopment.un.org/sdg14','SDGs 14.5'))
              )
            ),
            tabPanel(
              '資料來源',
              br(),
              tags$ol(class = 'list',
                      tags$li('根據漁業署官網',
                              a(href = 'http://www.fa.gov.tw/cht/TaiwanOceansProtectionAreas/content.aspx?id=6&chk=db96a8d8-09e4-47e4-9364-5076fe339134&param=pn%3d2','「我國海洋保護區保護等級分類系統」'),
                              '之內容，台灣的海洋保護區依受保護的嚴格程度，分為第一級「禁止進入或影響」、第二級「禁止採捕」、第三級「分區多功能使用」(嚴格程度依次遞減)。'),
                      tags$li('目前本計畫用於計算此指標的資料皆來自農委會漁業署發布至其官網上', 
                              a(href = 'http://www.fa.gov.tw/cht/TaiwanOceansProtectionAreas/content.aspx?id=1&chk=2001739d-d4cd-4ded-bf92-d570912baf08','「臺灣的海洋保護區」'),
                              '頁面中的內容，這些由漁業署整合自營建署、觀光局、林務局的海洋保護區相關資料，都可在此',
                              a(href = 'http://www.fa.gov.tw/cht/TaiwanOceansProtectionAreas/content.aspx?id=7&chk=f5d07a6b-2159-4218-a376-f632fb1ed1f9&param=pn%3d1', '連結'),
                              '中找到。'),
                      tags$li('根據漁業署所統整的資料，目前被台灣官方列入「海洋保護區」的區域共分五類，分別對應五種法規，即由「國家公園法」律定之「國家公園海域保護區」、由「野生動物保育法」律定之「野生動物保護區」、由「文化資產保存法」律定之「自然保留區」、由「都市計畫法」或「發展觀光條例」律定之「國家風景特定區」、以及由「漁業法」律定之「漁業資源保育區」和「相關漁具漁法及特定漁業禁漁區 (常簡稱為禁漁區)」。'),
                      tags$li('在此', a(href = 'http://www.fa.gov.tw/cht/TaiwanOceansProtectionAreas/content.aspx?id=7&chk=f5d07a6b-2159-4218-a376-f632fb1ed1f9&param=pn%3D1', '頁面'),
                              '之附件《國內已有法令依據之海洋保護區資料彙整表》中，詳列出除「相關漁具漁法及特定漁業禁漁區」外各類海洋保護區的基本資訊，包括「保護區名稱」、「法令依據」、「管理目的及內容」、「管理機關」、「地理位置」、「面積」、「現況及未來計畫」等資訊。大部分名列此文件的海洋保護區於「地理位置」一欄皆有 4 個以上的座標點位，可用於估算其面積。「現況及未來計畫」欄位中亦常有註記該海洋保護區的保護等級。'),
                      tags$li('國際上計算海洋保護區面積比例時多半以專屬經濟海域 (Exclusive Economic Zone, EEZ) 為分母，然台灣可能因為複雜的政治因素，目前並無官方正式公告之 EEZ 數值。漁業署以 12 海浬領海面積為替，根據《國內已有法令依據之海洋保護區資料彙整表》，該數值為 65076.96 平方公里。')
              )
            ),
            tabPanel(
              '資料清理',
              br(),
              tags$ol(class = 'list',
                      tags$li('本指標之資料清理流程理應為：(1) 將《國內已有法令依據之海洋保護區資料彙整表》中之點位資料整理為更容易使用的形式。(2) 利用點位資料計算出各海洋保護區的面積，並與漁業署統整的版本進行比對。(3) 減去其中屬於陸域部分的面積。(4) 減去各保護區相互重疊的部分。'),
                      tags$li('本計畫執行者目前仍處於前述資料清理流程中的第 (1) 階段，故資料清理尚未完成。本頁面之數值計算皆是先假設《國內已有法令依據之海洋保護區資料彙整表》中有明確羅列之海洋保護區彼此間並無重疊，且其所陳述之面積 (除非特別提及) 皆屬海域而不包括陸域部分。')
              )
            ),
            tabPanel(
              '侷限性',
              br(),
              h4(class = 'limitType', strong('指標層面的問題')),
              tags$ol(class = 'list',
                      tags$li(
                        '在計算台灣海洋保護區面積比例時，保護等級屬第二和第三級 (特別是第三級) 者的面積是否該納入計算，仍然存在爭議。這對此項指標的計算結果會有相當顯著的影響，因根據《國內已有法令依據之海洋保護區資料彙整表》，計算台灣海洋保護區面積比時被計入的海洋保護區超過八成以上缺乏地理圖資，而其保護等級應不是第二就是第三級。'
                      )
              ),
              h4(class = 'limitType', strong('資料層面的問題')),
              tags$ol(class = 'list',
                      tags$li(
                        '目前台灣海洋保護區中「相關漁具漁法及特定漁業禁漁區」的資料仍然缺乏，其與其他海洋保護區的重疊程度也難以估算。'
                      )
              )
            )
          )
      ),
      
      hr(),
      h3('指標內容視覺化', class = 'secTitles'),
      
      tabsetPanel(
        tabPanel('Data from FATW',
          br(),
          sidebarLayout(
            sidebarPanel(
              
              sliderInput(
                'year',
                label = h3(strong('時間軸'), class = 'inputTitle2'),
                min = 1984, max = 2016, value = 2016,
                step = 1
              ),
              selectInput(
                'denominator',
                label = h3(strong('計算面積比時的分母'), class = 'inputTitle2'),
                choices = list(
                  '距岸 12 浬水域面積 (根據漁業署)' = 1,
                  '臺灣管轄海洋面積 (根據 WDPA)' = 2
                ),
                selected = 1
              ),
              br(),
              h3(strong('計算面積比時的分子'), class = 'inputTitle2'),
              checkboxGroupInput('selectedLaw',
                                 label = h4(strong('台灣 MPA 的法令依據'), class = 'inputTitle'),
                                 choices = list(
                                   '國家公園法' = 1,
                                   '野生動物保育法' = 2,
                                   '文化資產保存法' = 3,
                                   '都市計畫法' = 4,
                                   '發展觀光條例' = 5,
                                   '漁業法' = 6
                                 ),
                                 selected = 1:6
              ),
              checkboxGroupInput('selectedLevel',
                                 label = h4(strong('台灣 MPA 的保護等級'), class = 'inputTitle'),
                                 choices = list(
                                   '等級一「禁止進入或影響」' = 1,
                                   '等級二「禁止採捕」' = 2,
                                   '等級三「分區多功能使用」' = 3
                                 ),
                                 selected = 1:3
              ),
              div(
                class = 'single',
                checkboxInput(
                  'includeIt',
                  label = strong('納入「相關漁具漁法及特定漁業禁漁區」')
                ),
                checkboxInput(
                  'noOverlap',
                  label = strong('假設「相關漁具漁法及特定漁業禁漁區」彼此之間及與其他 MPA 之間在空間範圍上毫無重疊，並假設其保護等級皆為第三級、無涉及任何陸域面積以及自 1984 年起便已設立。')
                )
              )
            ),
            
            mainPanel(
              h3(class = 'inputTitle', strong('說明')),
              p(class = 'visualization',
                '本頁面提供數個可與瀏覽者互動的參數，旨在幫助瀏覽者瞭解計算台灣海洋保護區所佔面積比時有哪些不得不考慮的問題。「時間軸」讓您指定要處在哪個年代計算這項指標，「計算面積比時的分母」讓您指定計算面積比時的分母為何，「台灣 MPA 的法令依據」和「台灣 MPA 的保護等級」分別指定基於那些法規及符合哪一保護等級的海洋保護區可被列入計算。參數欄最末兩項是非題則讓您決定在計算面積比時是否要納入目前除面積值外尚無其他已知相關之公開資料的「相關漁具漁法及特定漁業禁漁區」，以及要令其計算變得可行需奠基在那些假設上。'
              ),
              hr(),
              h3('海洋保護區面積'),
              h4('減去陸域部分和各保護區重疊的部分'),
              uiOutput('output_II01_02'),
              hr(),
              h3('總水域面積'),
              uiOutput('output_II01_03'),
              hr(),
              h3('海洋保護區佔總水域面積之比率'),
              uiOutput('output_II01_01')
            )
          )
        ),
        tabPanel('Data from WDPA'
          
        )
      )
    ),
    
    tabPanel('II.02'
      
    )
  )
)