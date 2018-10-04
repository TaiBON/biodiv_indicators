getwd()
library(data.table)


#### 2014-2016 ####

RawData <- fread(file = './pre-processed/FishingData2016.txt', sep = '\t',
                 header = F, stringsAsFactors = F,
                 encoding = 'UTF-8')
RawData <- as.matrix(RawData)
nrow(RawData)
ncol(RawData)

Data <- NULL
Intvl <- 68
for (i in 1:16) {
  DataTmp <- RawData[c((3+Intvl*(i-1)):(9+Intvl*(i-1)),
                       (11+Intvl*(i-1)):(26+Intvl*(i-1)),
                       (28+Intvl*(i-1)):(44+Intvl*(i-1))),
                     seq(1, 15, 2)]
  Data <- cbind(Data, DataTmp)
}
Data <- Data[, -c(2, 3, 5, 13, 21, 27, 31, 40, 60,
                  78, 84, 94, 100, 114, 125, 127, 128,
                  seq(9, 121, 8))]
ncol(Data)

TaxonList <- fread(file = './pre-processed/FishingTaxonList_FATW.txt', sep = '\t',
                   header = T, stringsAsFactors = F,
                   encoding = 'UTF-8')
identical(TaxonList[year == 2016, taxonID],
          TaxonList[year == 2015, taxonID],
          TaxonList[year == 2014, taxonID])
TaxonList <- TaxonList[year == 2016][,taxonID]
TaxonList <- c('fishingMethodCodeAppliedByFA', TaxonList)
length(TaxonList)

colnames(Data) <- TaxonList

Data <- as.data.table(Data)
Data <- melt(Data, id.vars = 'fishingMethodCodeAppliedByFA',
             variable.name = 'taxonID',
             value.name = 'fishingQuantityInTon')

Data2014 <- Data[, year := 2014]
Data2015 <- Data[, year := 2015]
Data2016 <- Data[, year := 2016]


#### 2013 ####

TaxonList <- fread(file = './pre-processed/FishingTaxonList_FATW.txt', sep = '\t',
                   header = T, stringsAsFactors = F,
                   encoding = 'UTF-8')
identical(TaxonList[year == 2016, taxonID],
          TaxonList[year == 2013, taxonID])
identical(TaxonList[year == 2013, taxonID],
          TaxonList[year == 2012, taxonID])
TaxonList <- TaxonList[year == 2013, taxonID]
TaxonList <- c('fishingMethodCodeAppliedByFA', TaxonList)
length(TaxonList)

RawData <- fread(file = './pre-processed/FishingData2013.txt', sep = '\t',
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

TaxonList <- fread(file = './pre-processed/FishingTaxonList_FATW.txt', sep = '\t',
                   header = T, stringsAsFactors = F,
                   encoding = 'UTF-8')
identical(TaxonList[year == 2013, taxonID],
          TaxonList[year == 2012, taxonID])
identical(TaxonList[year == 2012, taxonID],
          TaxonList[year == 2011, taxonID])
TaxonList <- TaxonList[year == 2012, taxonID]
TaxonList <- c('fishingMethodCodeAppliedByFA', TaxonList)
length(TaxonList)

RawData <- fread(file = './pre-processed/FishingData2012.txt', sep = '\t',
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

TaxonList <- fread(file = './pre-processed/FishingTaxonList_FATW.txt', sep = '\t',
                   header = T, stringsAsFactors = F,
                   encoding = 'UTF-8')
TaxonList <- TaxonList[year == 2008, taxonID]
TaxonList <- c('fishingMethodCodeAppliedByFA', TaxonList)
length(TaxonList)

RawData <- fread(file = './pre-processed/FishingData2008.txt', sep = '\t',
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

TaxonList <- fread(file = './pre-processed/FishingTaxonList_FATW.txt', sep = '\t',
                   header = T, stringsAsFactors = F,
                   encoding = 'UTF-8')
TaxonList <- TaxonList[year == 2007][,taxonID]
TaxonList <- c('fishingMethodCodeAppliedByFA', TaxonList)
length(TaxonList)

RawData <- fread(file = './pre-processed/FishingData2007.txt', sep = '\t',
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
fwrite(Result, file = '../processed/FishingDataAfter2003Processed_FATW_2018_01.txt',
       sep = '\t')


#### 1959-2001 ####

RawData <- fread(file = './pre-processed/FishingDataBefore2003.txt',
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

fwrite(Data, file = '../processed/FishingDataBefore2003Processed_FATW_2018_01.txt',
       sep = '\t')

