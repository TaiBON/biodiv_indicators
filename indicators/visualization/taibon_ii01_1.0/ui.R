library(shiny)
library(ggplot2)
library(data.table)

ui <- fluidPage(
  
  theme = 'style.css',
  
  sidebarLayout(
    
    sidebarPanel(
      
      h3(class = 'inputTitle', strong('參數欄')),

      br(),
      h3(strong('計算面積比時的分子'), class = 'inputTitle2'),
      checkboxGroupInput('selectedLaw',
                         label = h4(strong('請勾選所欲納入的 MPA 法令依據'), class = 'inputTitle'),
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
                         label = h4(strong('請勾選所欲納入的 MPA 保護等級'), class = 'inputTitle'),
                         choices = list(
                           '等級一「禁止進入或影響」' = 1,
                           '等級二「禁止採捕」' = 2,
                           '等級三「分區多功能使用」' = 3
                         ),
                         selected = 1:3
      ),
      div(
        class = 'single',
        radioButtons(
          'includeIt_1',
          label = h4(strong('是否納入資料來源中沒有地理圖資相關資訊的 MPA？'), class = 'inputTitle'),
          choices = list("先不用，謝謝" = 1,
                         "請直接納入，謝謝" = 2),
          selected = 1),
        radioButtons(
          'includeIt_2',
          label = h4(strong('是否納入基於漁業法且保護等級為第三級的「相關漁具漁法及特定漁業禁漁區」？（相關問題請見指標詳情）'),
                     class = 'inputTitle'),
          choices = list("先不用，謝謝" = 1,
                         "請直接納入，謝謝" = 2),
          selected = 1)
      )
    ),
    
    mainPanel(
      h3('12 浬領海面積'),
      hr(),
      h3('海洋保護區面積'),
      h4('減去陸域部分和各保護區重疊的部分'),
      uiOutput('mpa.area'),
      hr(),
      h3('海洋保護區佔總水域面積之比率'),
      uiOutput('mpa.ratio'),
      hr(),
      h3('距愛知目標或 SDGs 預期目標還有')
    )
  )
)