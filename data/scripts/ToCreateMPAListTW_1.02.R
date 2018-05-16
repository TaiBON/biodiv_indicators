
#### Author comment ####
# 作者姓名：楊富鈞
# 電子郵件：yuukumo0312@gmail.com
# 辦公室電話：02-2787-2220#26


#### File description comment ####
# 所屬計畫：林務局國家生物多樣性監測與報告系統規劃－海域
# 此 script 的目的：將漁業署官網中的海洋保護區資料轉為有利資料交換的格式


#### source() and library() ####
library(data.table)


#### Executed statements ####

# 自 data/scripts/pre-procesed 中匯入資料
## 此匯入的海洋保護區地理範圍資料並非漁業署官網上最原始的版本 (in .pdf)，而是已經
## 在 Excel 中有過清理，主要是將所有坐標點位的格式統一以利後續操作。
mpalist.fatw.raw <- fread(file = "./pre-processed/MPAList_FATW_2018_02.txt",
                          header = T, sep = "\t", stringsAsFactors = F,
                          encoding = "UTF-8")

# 
mpalist.fatw.tmp.1 <- unique(mpalist.fatw.raw[, c("nameOfMPA", "parentMPA", "basedOn", "level",
                                                  "areaTotalByFATW", "areaTerrestrialByFATW",
                                                  "areaMarineByFATW")])
mpalist.fatw.tmp.1 <- mpalist.fatw.tmp.1[!is.na(level) & !is.na(areaTotalByFATW)]

#
mpalist.fatw.tmp <- mpalist.fatw.raw[!is.na(cleanedCoordinate) & !is.na(typeOfWKT)]

# 抽出各海洋保護區地理範圍所需點位之緯度的度、分、秒並將其轉為十進位制
mpalist.fatw.tmp[,
                 decimalLatitude := as.numeric(substr(cleanedCoordinate, 1,
                                                      regexpr("°",
                                                              cleanedCoordinate)-1)) +
                   (as.numeric(substr(cleanedCoordinate,
                                      regexpr("°", cleanedCoordinate) + 1,
                                      regexpr("'", cleanedCoordinate) - 1))/60)
                 ][regexpr('s', cleanedCoordinate) > 0,
                   decimalLatitude := decimalLatitude +
                     (as.numeric(substr(cleanedCoordinate,
                                        regexpr("'", cleanedCoordinate) + 1,
                                        regexpr('s', cleanedCoordinate) - 1))/3600)
                   ]

# 抽出各海洋保護區地理範圍所需點位之經度的度、分、秒並將其轉為十進位制
mpalist.fatw.tmp[,
                 
                 decimalLongitudeTmp := regmatches(
                   cleanedCoordinate,
                   regexpr(" .*", cleanedCoordinate))
                 ][,
                   decimalLongitude := as.numeric(substr(decimalLongitudeTmp, 2,
                                                         regexpr("°", decimalLongitudeTmp)-1)) +
                     (as.numeric(substr(decimalLongitudeTmp,
                                        regexpr("°", decimalLongitudeTmp) + 1,
                                        regexpr("'", decimalLongitudeTmp) - 1))/60)
                   ][regexpr('sE', decimalLongitudeTmp) > 0,
                     decimalLongitude := decimalLongitude +
                       (as.numeric(substr(decimalLongitudeTmp,
                                          regexpr("'", decimalLongitudeTmp) + 1,
                                          regexpr('s', decimalLongitudeTmp) - 1))/3600)
                     ][, decimalLongitudeTmp := NULL]

# 將經緯度四捨五入至小數點後第四位並置入新欄位 "coordinate"
mpalist.fatw.tmp[, coordinate := paste(round(decimalLongitude, 4),
                                       round(decimalLatitude, 4),
                                       sep = " ")]

# 以順時針重新排序各 POLYGON 的端點
## 先計算出各 POLYGON 的重心坐標，接著計算各端點以重心為原點時所夾的角度，
## 此角度為後續排序時的根據。
mpalist.fatw.tmp[typeOfWKT == "POLYGON",
                 centroidX := mean(decimalLongitude),
                 by = nameOfMPA][typeOfWKT == "POLYGON",
                                 centroidY := mean(decimalLatitude),
                                 by = nameOfMPA]
mpalist.fatw.tmp[,
                 atan2 := atan2(decimalLongitude - centroidX,
                                decimalLatitude - centroidY)]

# 列出地理圖資類型屬於 MULTIPOINT、POLYGON 的海洋保護區
mpalist.fatw.plp <- unique(mpalist.fatw.tmp[, .(nameOfMPA, parentMPA, basedOn,
                                                level, typeOfCase, typeOfWKT)])

# 將各海洋保護區的地理圖資轉成 WKT 格式
mpalist.fatw.wkt <- NULL
for(i in 1:nrow(mpalist.fatw.plp)) {
  
  mpa.name <- mpalist.fatw.plp$nameOfMPA[i]
  
  mpa.tmp <- mpalist.fatw.tmp[nameOfMPA == mpa.name][order(atan2)]
  mpa.sub.num <- nrow(mpa.tmp)
  type <- unique(mpa.tmp[, typeOfWKT])
  
  mpalist.fatw.wkt.tmp <- NULL
  for(i in 1:mpa.sub.num) {
    mpalist.fatw.wkt.tmp <- paste(mpalist.fatw.wkt.tmp,
                                  mpa.tmp[i][, coordinate],
                                  sep = ", ")
  }
  
  mpalist.fatw.wkt.tmp <- substr(mpalist.fatw.wkt.tmp,
                                 regexpr(', ',
                                         mpalist.fatw.wkt.tmp)+2, nchar(mpalist.fatw.wkt.tmp))
  
  if(type == "POLYGON") {
    mpalist.fatw.wkt.tmp <- paste(type, "((", mpalist.fatw.wkt.tmp, "))", sep = "")
  } else {
    mpalist.fatw.wkt.tmp <- paste(type, "(", mpalist.fatw.wkt.tmp, ")", sep = "")
  }
  
  mpalist.fatw.wkt <- c(mpalist.fatw.wkt, mpalist.fatw.wkt.tmp)
}

#
mpalist.fatw.wkt <- cbind(mpalist.fatw.plp, mpalist.fatw.wkt)
names(mpalist.fatw.wkt)[7] <- "WKT"

#
setkey(mpalist.fatw.wkt, nameOfMPA)
setkey(mpalist.fatw.tmp.1, nameOfMPA)
mpalist.fatw <- mpalist.fatw.tmp.1[mpalist.fatw.wkt, nomatch = NA][,
  .(nameOfMPA,
    parentMPA = i.parentMPA,
    basedOn = i.basedOn,
    level = i.level,
    areaTotalByFATW,
    areaTerrestrialByFATW,
    areaMarineByFATW,
    typeOfCase,
    WKT)][order(basedOn)]

# 匯出結果
fwrite(mpalist.fatw, file = "../processed/MPAListProcessed_FATW_2018_01.csv", sep = ",")
fwrite(mpalist.fatw, file = "../processed/MPAListProcessed_FATW_2018_01.txt", sep = "\t")

