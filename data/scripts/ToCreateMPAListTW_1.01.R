
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
## 用 Excel 清理過一輪，主要是將所有坐標點位的格式統一以利後續操作。
mpalist.fatw.raw <- fread(file = "./pre-processed/MPAList_FATW_2018_01.txt",
                          header = T, sep = "\t", stringsAsFactors = F,
                          encoding = "UTF-8")

# 先剔除無法從原始資料中攫取出地理範圍所需點位的海洋保護區
## 這些海洋保護區在欄位 "cleanedCoordinate" 中的欄位數值會是 NA
mpalist.fatw.tmp <- mpalist.fatw.raw[!is.na(cleanedCoordinate)]

# 看一下是哪些海洋保護區在上步驟中被暫時剔除了
mpalist.fatw.na <- mpalist.fatw.raw[is.na(cleanedCoordinate)][!is.na(parentMPA)]
unique(mpalist.fatw.na$nameOfMPA)
## 「琉球漁業資源保育區」和「綠島漁業資源保育區」，兩者的環島分區面積必須有小琉球的
## 完整圖資才能計算
## 「墾丁國家公園」，其其他海域一般管制區必須有墾丁國家公園的完整圖資才能計算
## 「東沙環礁國家公園」，其一般管制區需有官方文件中所提「東南側臨海之海域範圍」的完
## 整圖資才能計算
## 「澎湖南方四島國家公園」，其海域遊憩區和一般管制區必須有此國家公園的完整圖資才能
## 計算
## 「臺江國家公園」，其一般管制區(一)的座標點位目前在「度」以下的數值無法被辨識
## 「臺江國家公園」，其一般管制區(二)於官方文件中有明確指出目前尚無明確的地理圖資
## 「澎湖玄武岩自然保留區」，各島嶼除小白沙嶼於官方文中點名為待調查，其餘島嶼的座標
## 有可能有錯

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
mpalist.fatw.tmp[typeOfData == "POLYGON",
                 centroidX := mean(decimalLongitude),
                 by = nameOfMPA][typeOfData == "POLYGON",
                                 centroidY := mean(decimalLatitude),
                                 by = nameOfMPA]
mpalist.fatw.tmp[,
                 atan2 := atan2(decimalLongitude - centroidX,
                                decimalLatitude - centroidY)]

# 列出地理圖資類型屬於 POINT、LINESTRING、POLYGON 的海洋保護區
mpalist.fatw.plp <- unique(mpalist.fatw.tmp[, .(nameOfMPA, parentMPA, typeOfData)])

# 將各海洋保護區的地理圖資轉成 WKT 格式
mpalist.fatw.wkt <- NULL
for(i in 1:nrow(mpalist.fatw.plp)) {
  
  mpa.name <- mpalist.fatw.plp$nameOfMPA[i]
  
  mpa.tmp <- mpalist.fatw.tmp[nameOfMPA == mpa.name][order(atan2)]
  mpa.sub.num <- nrow(mpa.tmp)
  type <- unique(mpa.tmp[, typeOfData])
  
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
names(mpalist.fatw.wkt)[4] <- "WKT"

# 匯出結果
fwrite(mpalist.fatw.wkt, file = "../processed/MPAListProcessed_FATW_2018_01.csv", sep = ",")
fwrite(mpalist.fatw.wkt, file = "../processed/MPAListProcessed_FATW_2018_01.txt", sep = "\t")


