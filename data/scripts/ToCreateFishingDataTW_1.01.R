
#### Author comment ####
# 作者姓名：楊富鈞
# 電子郵件：yuukumo0312@gmail.com
# 辦公室電話：02-2787-2220#26


#### File description comment ####
# 所屬計畫：林務局國家生物多樣性監測與報告系統規劃－海域
# 此 script 的目的：將漁業署官網漁業統計年報中的漁獲資料轉為有利資料交換的格式


#### source() and library() ####
library(data.table)
library(readODS)


#### Executed statements (2014-2016) ####

# 檔案位置
data.path <- '../raw/漁業署/漁業統計年報/民國105年(2016)漁業統計年報/10507-1-漁業生產量值--漁業種類魚類別(1070213).ods'

# 讀入所有 sheets 中的漁獲資料
fishing.data.raw <- NULL
for(i in 1:getNrOfSheetsInODS(data.path)) {
  if(i == getNrOfSheetsInODS(data.path)) {
    fishing.data.raw.tmp <- read_ods(data.path, sheet = i, col_names = FALSE, skip = 9)[1:58, 3:8]
  } else {
    fishing.data.raw.tmp <- read_ods(data.path, sheet = i, col_names = FALSE, skip = 9)[1:58, 3:14]
  }
  fishing.data.raw.tmp <- as.matrix(fishing.data.raw.tmp)
  fishing.data.raw <- cbind(fishing.data.raw, fishing.data.raw.tmp)
}
fishing.data.raw <- fishing.data.raw[, seq(1, ncol(fishing.data.raw), by = 2)]

# 列出所有 sheets 中的漁獲種類
taxon.list <- NULL
for(i in 1:getNrOfSheetsInODS(data.path)) {
  if(i == getNrOfSheetsInODS(data.path)) {
    taxon.list.tmp <- read_ods(data.path, sheet = i, col_names = FALSE, skip = 5)[1, 2:4]
  } else {
    taxon.list.tmp <- read_ods(data.path, sheet = i, col_names = FALSE, skip = 5)[1, 3:8]
  }
  taxon.list.tmp <- as.matrix(taxon.list.tmp)
  taxon.list <- cbind(taxon.list, taxon.list.tmp)
}

# 列出所有 sheets 中的漁法種類
fishing.methods <- read_ods(data.path, sheet = 1, col_names = FALSE, skip = 9)[1:58, 1:2]

# 合併漁獲量、漁獲種類、漁法種類
fishing.data.raw <- cbind(fishing.methods, fishing.data.raw)
names(fishing.data.raw) <- c("漁法代碼", "漁法名稱", taxon.list[1, ])

fishing.data.raw <- as.data.table(fishing.data.raw)
fishing.data.raw <- melt(fishing.data.raw, id.vars = c("漁法代碼", "漁法名稱"),
                         measure.vars = names(fishing.data.raw)[-(1:2)],
                         variable.name = "漁獲種類",
                         value.name = "漁獲量噸數")
fishing.data.raw <- fishing.data.raw[!(漁獲種類 %in% c("合計", "小計"))]

fwrite(fishing.data.raw, file = "../processed/FishingDataProcessed_FATW_2018_01.txt", sep = "\t")


#### 2013 ####

TaxonList <- fread(file = './Data/TaxonLists.txt', sep = '\t',
                   header = T, stringsAsFactors = F,
                   encoding = 'UTF-8')
identical(TaxonList[year == 2016, taxonID],
          TaxonList[year == 2013, taxonID])
identical(TaxonList[year == 2013, taxonID],
          TaxonList[year == 2012, taxonID])
TaxonList <- TaxonList[year == 2013, taxonID]
TaxonList <- c('fishingMethodCodeAppliedByFA', TaxonList)
length(TaxonList)

RawData <- fread(file = './Data/FishingData2013.txt', sep = '\t',
                 header = F, stringsAsFactors = F,
                 encoding = 'UTF-8')
RawData <- as.matrix(RawData)
nrow(RawData)
ncol(RawData)

Data <- NULL
Intvl <- 64
for (i in 1:16) {
  DataTmp <- RawData[c((3+Intvl*(i-1)):(9+Intvl*(i-1)),
                       (11+Intvl*(i-1)):(26+Intvl*(i-1)),
                       (28+Intvl*(i-1)):(40+Intvl*(i-1))),
                     seq(1, 15, 2)]
  Data <- cbind(Data, DataTmp)
}
Data <- Data[, -c(2, 3, 5, 13, 21, 27, 37, 56, 74,
                  80, 92, 96, 110, 122, 124:128,
                  seq(9, 121, 8))]
ncol(Data)

colnames(Data) <- TaxonList

Data <- as.data.table(Data)
Data <- melt(Data, id.vars = 'fishingMethodCodeAppliedByFA',
             variable.name = 'taxonID',
             value.name = 'fishingQuantityInTon')

Data2013 <- Data[, year := 2013]


#### 2011-2012 ####

TaxonList <- fread(file = './Data/TaxonLists.txt', sep = '\t',
                   header = T, stringsAsFactors = F,
                   encoding = 'UTF-8')
identical(TaxonList[year == 2013, taxonID],
          TaxonList[year == 2012, taxonID])
identical(TaxonList[year == 2012, taxonID],
          TaxonList[year == 2011, taxonID])
TaxonList <- TaxonList[year == 2012, taxonID]
TaxonList <- c('fishingMethodCodeAppliedByFA', TaxonList)
length(TaxonList)

RawData <- fread(file = './Data/FishingData2012.txt', sep = '\t',
                 header = F, stringsAsFactors = F,
                 encoding = 'UTF-8')
RawData <- as.matrix(RawData)
nrow(RawData)
ncol(RawData)

Data <- NULL
Intvl <- 64
for (i in 1:15) {
  DataTmp <- RawData[c((3+Intvl*(i-1)):(9+Intvl*(i-1)),
                       (11+Intvl*(i-1)):(26+Intvl*(i-1)),
                       (28+Intvl*(i-1)):(40+Intvl*(i-1))),
                     seq(1, 15, 2)]
  Data <- cbind(Data, DataTmp)
}
Data <- Data[, -c(2, 3, 5, 13, 21, 27, 37, 56, 74, 80,
                  91, 95, 109, 118, 120,
                  seq(9, 113, 8))]
ncol(Data)

colnames(Data) <- TaxonList

Data <- as.data.table(Data)
Data <- melt(Data, id.vars = 'fishingMethodCodeAppliedByFA',
             variable.name = 'taxonID',
             value.name = 'fishingQuantityInTon')

Data2011 <- Data[, year := 2011]
Data2012 <- Data[, year := 2012]


#### 2008-2010 ####

TaxonList <- fread(file = './Data/TaxonLists.txt', sep = '\t',
                   header = T, stringsAsFactors = F,
                   encoding = 'UTF-8')
TaxonList <- TaxonList[year == 2008, taxonID]
TaxonList <- c('fishingMethodCodeAppliedByFA', TaxonList)
length(TaxonList)

RawData <- fread(file = './Data/FishingData2008.txt', sep = '\t',
                 header = F, stringsAsFactors = F,
                 encoding = 'UTF-8')
RawData <- as.matrix(RawData)
nrow(RawData)
ncol(RawData)

Data <- NULL
# 2010 年為 52
Intvl <- 51
for (i in 1:(nrow(RawData)/Intvl)) {
  DataTmp <- RawData[(3+Intvl*(i-1)):(Intvl+Intvl*(i-1))]
  Data <- cbind(Data, DataTmp)
}

# 2010 年多了 '604'
methods <- c('000','100','101','102','103','104','106',
             '108','199','200','201','202','203','204',
             '205','206','209','211','212','213','214',
             '219','221','299','300','301','302','303',
             '304','305','306','307','308','309','310',
             '399','400','401','402','499','500','501',
             '502','599','600','601','602','603',
             '699')

Data <- cbind(methods, Data)
colnames(Data) <- TaxonList
Data <- Data[c(3:9, 11:24, 26:36),]

Data <- as.data.table(Data)
Data <- melt(Data, id.vars = 'fishingMethodCodeAppliedByFA',
             variable.name = 'taxonID',
             value.name = 'fishingQuantityInTon')

Data2008 <- Data[, year := 2008]
Data2009 <- Data[, year := 2009]
Data2010 <- Data[, year := 2010]


#### 2003-2007 ####

TaxonList <- fread(file = './Data/TaxonLists.txt', sep = '\t',
                   header = T, stringsAsFactors = F,
                   encoding = 'UTF-8')
TaxonList <- TaxonList[year == 2007][,taxonID]
TaxonList <- c('fishingMethodCodeAppliedByFA', TaxonList)
length(TaxonList)

RawData <- fread(file = './Data/FishingData2007.txt', sep = '\t',
                 header = F, stringsAsFactors = F,
                 encoding = 'UTF-8')
RawData <- as.matrix(RawData)
nrow(RawData)
ncol(RawData)

Data <- NULL
Intvl <- 55
for (i in 1:22) {
  DataTmp <- RawData[c((3+Intvl*(i-1)):(9+Intvl*(i-1)),
                       (11+Intvl*(i-1)):(24+Intvl*(i-1)),
                       (26+Intvl*(i-1)):(36+Intvl*(i-1))),
                     seq(1, 15, 2)]
  Data <- cbind(Data, DataTmp)
}
Data <- Data[, -c(2, seq(9, 169, 8))]

colnames(Data) <- TaxonList

Data <- as.data.table(Data)
Data <- melt(Data, id.vars = 'fishingMethodCodeAppliedByFA',
             variable.name = 'taxonID',
             value.name = 'fishingQuantityInTon')

Data2003 <- Data[, year := 2003]
Data2004 <- Data[, year := 2004]
Data2005 <- Data[, year := 2005]
Data2006 <- Data[, year := 2006]
Data2007 <- Data[, year := 2007]


Result <- rbind(Data2003, Data2004, Data2005, Data2006,
                Data2007, Data2008, Data2009, Data2009,
                Data2010, Data2011, Data2012, Data2013,
                Data2014, Data2015, Data2016)
fwrite(Result, file = './DataExported/FishingDataAfter2003.txt',
       sep = '\t')


#### 1959-2001 ####

RawData <- fread(file = './Data/FishingDataBefore2003.txt',
                 sep = '\t', header = F,
                 stringsAsFactors = F,
                 encoding = 'UTF-8')
RawData <- as.matrix(RawData)
nrow(RawData)
ncol(RawData)

Data <- NULL
Intvl <- 63
for (i in 1:8) {
  DataTmp <- RawData[c((3+Intvl*(i-1)):(12+Intvl*(i-1)),
                       (14+Intvl*(i-1)):(29+Intvl*(i-1)),
                       (31+Intvl*(i-1)):(43+Intvl*(i-1))),
                     seq(1, 13, 2)]
  Data <- cbind(Data, DataTmp)
}

Data <- Data[, -c(seq(8, 50, 7), 54:56)]
ncol(Data)

colnames(Data) <- c('fishingMethodCodeAppliedByFA',
                    1959:2003)

Data <- as.data.table(Data)
Data <- melt(Data, id.vars = 'fishingMethodCodeAppliedByFA',
             variable.name = 'year',
             value.name = 'fishingQuantityInTon')

fwrite(Data, file = './DataExported/FishingDataBefore2003.txt',
       sep = '\t')

