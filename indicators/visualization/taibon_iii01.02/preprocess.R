library(data.table)

Data <- NULL
for (i in 2:16) {
  Y <- 2000 + i
  path = paste('./data/Sea-', Y, '-modified.csv', sep = '')
  DataTmp <- fread(file = path, sep = ',', header = F,
                   stringsAsFactors = F, encoding = 'UTF-8')
  DataTmp[, year := Y]
  DataTmp <- as.matrix(DataTmp)
  Data <- rbind(Data, DataTmp)
}

Data <- as.data.table(Data)
names(Data)[1:(ncol(Data)-1)] <- c('waterBody', 'siteName', 'waterQuality', 'dateTmp',
                                     'siteCode', 'samplingDepth', 'temperature', 'waterTempeature',
                                     'salinity', 'pH', 'DOByTitration', 'DOByElectrode',
                                     'DOSaturation', 'SS', 'chlorophyllA', 'ammoniaN',
                                     'nitrateN', 'PH4N', 'nitriteN', 'silicate',
                                     'Cd', 'Cr', 'Cu', 'Zn', 'Pb', 'Hg')
fwrite(Data, './data/ocean.txt', sep = '\t')

Data <- NULL
for (i in 2:16) {
  Y <- 2000 + i
  path = paste('./data/Beach-', Y, '-modified.csv', sep = '')
  DataTmp <- fread(file = path, sep = ',', header = F,
                   stringsAsFactors = F, encoding = 'UTF-8')
  DataTmp[, year := Y]
  DataTmp <- as.matrix(DataTmp)
  Data <- rbind(Data, DataTmp)
}
Data <- as.data.table(Data)
names(Data)[1:(ncol(Data)-1)] <- c('waterBody', 'siteName', 'waterQuality', 'dateTmp',
                                   'siteCode', 'waterTempeature',
                                   'pH', 'turbidity', 'temperature', 'DOByElectrode',
                                   'ammoniaN', 'nitrateN', 'nitriteN', 'salinity', 'silicate',
                                   'DOByTitration', 'DOSaturation', 'PH4N', 'eColi', 'entercocci')
fwrite(Data, './data/ocean.txt', sep = '\t')

