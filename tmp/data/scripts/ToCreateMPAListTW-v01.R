library(data.table)



#### 清理出漁業署 2018 年的海洋保護區地理範圍資料 ####

# 自 pre-procesed 中匯入資料
## 此匯入的海洋保護區地理範圍資料並非漁業署官網上最原始的版本 (in .pdf)，而是已經用 Excel
## 清理過一輪，主要是將所有點位資料的格式統一以利後續操作。
## "MPAList_FATW_2018_01" 代表 2018 年來自漁業署的海洋保護區列表第一版
MPAList_FATW_2018_01 <- fread(file = "./pre-processed/MPAList_FATW_2018_01.txt",
                              header = T, sep = "\t", stringsAsFactors = F,
                              encoding = "UTF-8")

# 先剔除無法從原始資料中攫取出地理範圍所需點位的海洋保護區
## 這些海洋保護區在欄位 "cleanedCoordinate" 中的欄位數值會是 NA
MPAL_FATW_TMP <- MPAList_FATW_2018_01[!is.na(cleanedCoordinate)]

# 看一下是哪些海洋保護區在上步驟中被暫時剔除了
MPAL_FATW_TMP_NA <- MPAList_FATW_2018_01[is.na(cleanedCoordinate)][!is.na(parentMPA)]
unique(MPAL_FATW_TMP_NA$nameOfMPA)
## 「琉球漁業資源保育區」和「綠島漁業資源保育區」，兩者的環島分區面積必須有小琉球的完整圖資才能計算
## 「墾丁國家公園」，其其他海域一般管制區必須有墾丁國家公園的完整圖資才能計算
## 「東沙環礁國家公園」，其一般管制區需有官方文件中所提「東南側臨海之海域範圍」的完整圖資才能計算
## 「澎湖南方四島國家公園」，其海域遊憩區和一般管制區必須有此國家公園的完整圖資才能計算
## 「臺江國家公園」，其一般管制區(一)的座標點位目前在「度」以下的數值無法被辨識
## 「臺江國家公園」，其一般管制區(二)於官方文件中有明確指出目前尚無明確的地理圖資
## 「澎湖玄武岩自然保留區」，各島嶼除小白沙嶼於官方文中點名為待調查，其餘島嶼的座標有可能有錯

# 抽出各海洋保護區地理範圍所需點位之緯度的度、分、秒並將其轉為十進位制
MPAL_FATW_TMP[,
              
              decimalLatitude := as.numeric(substr(cleanedCoordinate, 1,
                                                   regexpr("°", cleanedCoordinate)-1)) +
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
MPAL_FATW_TMP[,
              
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

# 將經緯度四捨五入至小數點後第四位並置入新建欄位 "coordinate"
MPAL_FATW_TMP[, coordinate := paste(round(decimalLongitude, 4),
                                    round(decimalLatitude, 4),
                                    sep = " ")]

# 原始資料中各 POLYGON 的端點並非皆以順時針有序排列
# 解決方案為先計算出各 POLYGON 的重心坐標，接著計算各端點以重心為原點時所夾的角度，
# 此角度可做為後續排序時的依據。
MPAL_FATW_TMP[typeOfData == "POLYGON", centroidX := mean(decimalLongitude), by = nameOfMPA][
  typeOfData == "POLYGON", centroidY := mean(decimalLatitude), by = nameOfMPA][
    , atan2 := atan2(decimalLongitude - centroidX, decimalLatitude - centroidY)]

# 列出現有地理圖資類型屬於 POINT、LINE、POLYGON 的海洋保護區
MPAL_PLP <- unique(MPAL_FATW_TMP[typeOfData %in% c("POINT", "LINE", "POLYGON"),
                                 .(nameOfMPA, parentMPA, typeOfData)])

# 將各海洋保護區的地理圖資轉成 WKT 格式
MPAL_WKT <- NULL
for(i in 1:nrow(MPAL_PLP)) {
  MPA_NAME <- MPAL_PLP$nameOfMPA[i]
  MPA_TMP <- MPAL_FATW_TMP[nameOfMPA == MPA_NAME][order(atan2)]
  NUM <- nrow(MPA_TMP)
  TYPE <- unique(MPA_TMP[, typeOfData])
  
  MPAL_WKT_TMP <- NULL
  for(i in 1:NUM) {
    MPAL_WKT_TMP <- paste(MPAL_WKT_TMP, MPA_TMP[i][, coordinate],
                          sep = ", ")
  }
  MPAL_WKT_TMP <- substr(MPAL_WKT_TMP, regexpr(', ', MPAL_WKT_TMP)+2, nchar(MPAL_WKT_TMP))
  
  if(TYPE == "POLYGON") {
    MPAL_WKT_TMP <- paste(TYPE, "((", MPAL_WKT_TMP, "))", sep = "")
  } else {
    MPAL_WKT_TMP <- paste(TYPE, "(", MPAL_WKT_TMP, ")", sep = "")
  }
  
  MPAL_WKT <- c(MPAL_WKT, MPAL_WKT_TMP)
}

#
MPAL_WKT <- cbind(MPAL_PLP, MPAL_WKT)
names(MPAL_WKT)[4] <- "WKT"

# 匯出結果
fwrite(MPAL_WKT, file = "../processed/pMPAL_FATW_TMP_2018_01.txt", sep = "\t")
fwrite(MPAL_WKT, file = "../processed/pMPAL_FATW_TMP_2018_01.csv", sep = ",")

