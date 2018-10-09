library(shiny)

shinyUI(fluidPage(
    mainPanel( tabsetPanel(type = "tabs",
                           tabPanel("水溫", plotOutput("p1")),
                           tabPanel("pH",  plotOutput("p2")),
                           tabPanel("溶氧量",  plotOutput("p3")),
                           tabPanel("鉛",  plotOutput("p4")),
                           tabPanel("汞",  plotOutput("p5")),
                           tabPanel("銅",  plotOutput("p6")),
                           tabPanel("鋅",  plotOutput("p7")),
                           tabPanel("鎘",  plotOutput("p8")))
  
)))
