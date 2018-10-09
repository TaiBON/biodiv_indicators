library(shiny)
library(ggplot2)
options(scipen = 999)

shinyServer(function(input, output) {
  output$p1 <- renderPlot({
    qplot(years, WT, data = data,
          geom ="path",xlab=("Year"),ylab = "water temperature (°C)",ylim = c(23, 30),size=I(1), 
          colour = I("sky blue"))+theme(axis.text=element_text(size=16),
          axis.title=element_text(size=20))  
  }, height = 500, width = 809)

  output$p2 <- renderPlot({
    qplot(years, pH, data = data,
          geom ="path",xlab=("Year"),ylab = "pH",ylim = c(7.5,8.5),size=I(1), 
          colour = I("sky blue"))+theme(axis.text=element_text(size=16),
                                    axis.title=element_text(size=20))  
  }, height = 500, width = 809)
  
  output$p3 <- renderPlot({
    ggplot(data=data)+geom_line(aes(years,OD1,colour=I("orange")),size=1)+
      ylab("OD(mg/L)")+xlab("Year")+ylim(c(6,7))+geom_line(aes(years,OD2,colour=I("sky blue")),size=1)+
      scale_color_discrete(name='',labels = c("Winkler method", "Clark electrode method"))+
      theme(axis.text=element_text(size=16),axis.title=element_text(size=20),
            legend.text = element_text(size=20),legend.position = 'bottom')+ 
      guides(linetype = guide_legend(ncol = 2,keywidth=4))
  }, height = 500, width = 809)
  
  output$p4 <- renderPlot({
    qplot(years, Pb, data = data,
          geom ="path",xlab=("Year"),ylab = "Pb (mg/L)",size=I(1),
          colour = I("sky blue"))+
      theme(axis.text=element_text(size=16),
            axis.title=element_text(size=20))  
  }, height = 500, width = 809)
  
  output$p5 <- renderPlot({
    qplot(years, Hg, data = data,
          geom ="path",xlab=("Year"),ylab = "Hg (mg/L)",size=I(1),
          colour = I("sky blue"))+
      theme(axis.text=element_text(size=16),
            axis.title=element_text(size=20))  
  }, height = 500, width = 809)

  output$p6 <- renderPlot({
    qplot(years, Cu, data = data,
          geom ="path",xlab=("Year"),ylab = "Cu (mg/L)",size=I(1),
          colour = I("sky blue"))+
      theme(axis.text=element_text(size=16),
            axis.title=element_text(size=20))  
  }, height = 500, width = 809)  
  
  output$p7 <- renderPlot({
    qplot(years, Zn, data = data,
          geom ="path",xlab=("Year"),ylab = "Zn (mg/L)",size=I(1),
          colour = I("sky blue"))+
      theme(axis.text=element_text(size=16),
            axis.title=element_text(size=20))  
  }, height = 500, width = 809)
  
  output$p8 <- renderPlot({
    qplot(years, Cd, data = data,
          geom ="path",xlab=("Year"),ylab = "Cd (mg/L)",size=I(1),
          colour = I("sky blue"))+
      theme(axis.text=element_text(size=16),
            axis.title=element_text(size=20))  
  }, height = 500, width = 809)  
})
  
  