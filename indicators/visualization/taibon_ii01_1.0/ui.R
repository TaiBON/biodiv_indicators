library(shiny)
library(data.table)

ui <- fluidPage(
  
  theme = 'style.css',
  
  sidebarLayout(
    
    sidebarPanel(
      
      h3(class = 'inputTitle', strong('指標參數調節欄')),

      br(),
      h3(strong('計算面積比時的分子'), class = 'inputTitle2'),
      br(),
      
      div(
        class = 'single',
        radioButtons(
          'includeIt',
          strong('本計畫採用之資料集，有部分海洋保護區缺乏地理圖資相關資訊，本團隊難以評估其劃設與面積計算方式是否合理，其中包括幅員廣闊、足以顯著影響指標計算結果的「相關漁具漁法及特定漁業禁漁區」。請問是否要將這些海洋保護區納入計算？'),
          choices = list("先不用，謝謝" = 1,
                         "請納入「相關漁具漁法及特定漁業禁漁區」以外的部分，謝謝" = 2,
                         "請全部納入，謝謝" = 3),
          selected = 1)
      ),
      
      checkboxGroupInput('selectedLaw',
                         label = h4(strong('請勾選您認為應納入計算的 MPA 法令依據'), class = 'inputTitle'),
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
                         label = h4(strong('請勾選您認為應納入的 MPA 保護等級'), class = 'inputTitle'),
                         choices = list(
                           '等級一「禁止進入或影響」' = 1,
                           '等級二「禁止採捕」' = 2,
                           '等級三「分區多功能使用」' = 3
                         ),
                         selected = 1:3
      )
    ),
    
    mainPanel(
      h3('12 浬領海面積（平方公里）'),
      p("65076.96", class = "const"),
      hr(),
      h3('海洋保護區面積（平方公里）'),
      h4('減去陸域部分和各保護區重疊的部分'),
      uiOutput('mpa_area'),
      hr(),
      h3('海洋保護區佔領海面積之比率'),
      uiOutput('mpa_ratio'),
      hr(),
      h3('與愛知目標或 SDGs 預期目標 (20%) 的差距'),
      uiOutput('mpa_twenty')
    )
  )
)