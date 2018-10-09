library(data.table)

FrogA=fread("C:/Users/user/Documents/GitHub/biodiv_indicators/data/raw/陸域/2008-2014蛙類資料整理.csv",header =T,encoding="UTF-8")
FrogB=fread("C:/Users/user/Documents/GitHub/biodiv_indicators/data/raw/陸域/2015-2017_蛙類調查資料.csv",header =T,encoding="UTF-8")
FrogN=fread("C:/Users/user/Documents/GitHub/biodiv_indicators/data/raw/陸域/臺灣蛙類原生_外來名錄對應.csv",header =T,encoding="UTF-8")
head(FrogA)
head(FrogB)
###砍掉非數值資料與0
AA=FrogA[!(數量=="不計數"|數量=="單獨"|數量=="無")][!(數量==123456789|數量==0)][,c("年","蛙種","數量")]
BB=FrogB[!(數量=="不計數"|0)][,c("年","蛙種","數量")] 
AB=rbind(AA,BB)
######將大於的數值(例如">500"之類的數值)以該數值計
AB$數量 <- gsub(">","",AB$數量,fixed=T)
######將35-50 類的數量以平均數計

unique(AB$數量)
CC=AB[,數量:=(as.numeric(gsub("\\d{1,}~","",數量))+as.numeric(gsub("~\\d{1,}","",數量)))/2][,AB[!(is.na(數量))]]
setkey(CC,蛙種)
setkey(FrogN,species)
r1=CC[FrogN,]
r2=r1[,sum(數量),by=.(年,status)]
r3=r1[,sum(數量),by=.(年,蛙種)]
write.csv(r2,"E:/蛙類test.csv")

write.csv(CC,"C:/Users/user/Desktop/蛙資料整理.csv")
