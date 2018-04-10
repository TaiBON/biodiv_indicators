library(data.table)



#### 清理出漁業署 2018 年的海洋保護區地理範圍資料 ####

# 自 pre-procesed 中匯入資料
## 此匯入的海洋保護區地理範圍資料並非漁業署官網上最原始的版本 (in .pdf)，而是已經用 Excel
## 清理過一輪，主要是將所有點位資料的格式統一以利後續操作。
MPAList_FATW_2018_01 <- fread(file = "./pre-processed/MPAList_FATW_2018_01.txt",
                              header = T, sep = "\t", stringsAsFactors = F,
                              encoding = "UTF-8")

# 先剔除無法從原始資料中攫取出地理範圍所需點位的海洋保護區
## 這些海洋保護區在欄位 "_以Excel統一座標的格式" 中的欄位數值會是 NA
MPAL_FATW_TMP <- MPAList_FATW_2018_01[!is.na(`_以Excel統一座標的格式`)]

# 看一下是哪些海洋保護區在上步驟中被暫時剔除了
MPAL_FATW_TMP_NA <- MPAList_FATW_2018_01[is.na(`_以Excel統一座標的格式`)][!is.na(`_所屬的海洋保護區`)]
unique(MPAL_FATW_TMP_NA$`_海洋保護區或其子區的名稱`)
## 「琉球漁業資源保育區」和「綠島漁業資源保育區」，兩者的環島分區面積必須有小琉球的完整圖資才能計算
## 「墾丁國家公園」，其其他海域一般管制區必須有墾丁國家公園的完整圖資才能計算
## 「東沙環礁國家公園」，其一般管制區需有官方文件中所提「東南側臨海之海域範圍」的完整圖資才能計算
## 「澎湖南方四島國家公園」，其海域遊憩區和一般管制區必須有此國家公園的完整圖資才能計算
## 「臺江國家公園」，其一般管制區(一)的座標點位目前在「度」以下的數值無法被辨識
## 「臺江國家公園」，其一般管制區(二)於官方文件中有明確指出目前尚無明確的地理圖資
## 「澎湖玄武岩自然保留區」，各島嶼除小白沙嶼於官方文中點名為待調查，其餘島嶼的座標有可能有錯

# 抽出各海洋保護區地理範圍所需點位之緯度的度、分、秒並將其轉為十進位制
MPAL_FATW_TMP[,
              
              decimalLatitude := as.numeric(substr(`_以Excel統一座標的格式`, 1,
                                                   regexpr("°", `_以Excel統一座標的格式`)-1)) +
                (as.numeric(substr(`_以Excel統一座標的格式`,
                                   regexpr("°", `_以Excel統一座標的格式`) + 1,
                                   regexpr("'", `_以Excel統一座標的格式`) - 1))/60)
              ][regexpr('s', `_以Excel統一座標的格式`) > 0,
                decimalLatitude := decimalLatitude +
                  (as.numeric(substr(`_以Excel統一座標的格式`,
                                     regexpr("'", `_以Excel統一座標的格式`) + 1,
                                     regexpr('s', `_以Excel統一座標的格式`) - 1))/3600)
              ]

# 抽出各海洋保護區地理範圍所需點位之經度的度、分、秒並將其轉為十進位制
MPAL_FATW_TMP[,
              
              decimalLongitudeTmp := regmatches(
                `_以Excel統一座標的格式`,
                regexpr(" .*", `_以Excel統一座標的格式`))
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

# 
MPAL_FATW_TMP[, coordinate := paste(round(decimalLatitude, 5),
                                    round(decimalLongitude,5),
                                    sep = " ")]

##
MPAs <- unique(MPAL_FATW_TMP[`_地理圖資的類型` %in% c(),])

WKTL <- NULL
for(i in 1:length(MPAs)) {
  NAME <- MPAs[i]
  NUM <- nrow(MPAL_FATW_TMP[`_海洋保護區或其子區的名稱` == NAME])
  for(i in 1:NUM) {
    paste(MPAL_FATW_TMP[`_海洋保護區或其子區的名稱` == NAME][i][, coordinate],
          sep = ", ")
  }
}


# 匯出結果
fwrite(MPAL_FATW_TMP, file = "../processed/pMPAL_FATW_TMP_2018_01.txt", sep = "\t")

