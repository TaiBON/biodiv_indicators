library(data.table)



#### 取得 ####

# 自 pre-procesed 中匯入資料
MPAL_FATW_TMP <- fread(file = "./pre-processed/MPAList_FATW_2018_01.txt",
                       header = T, sep = "\t", stringsAsFactors = F,
                       encoding = "UTF-8")

# 
MPAL_FATW_TMP <- MPAL_FATW_TMP[!is.na(`_以Excel統一座標的格式`)]

#
MPAL_FATW_TMP[,
              
              latitude := as.numeric(substr(`_以Excel統一座標的格式`, 1,
                                            regexpr("°", `_以Excel統一座標的格式`)-1)) +
                (as.numeric(substr(`_以Excel統一座標的格式`,
                                   regexpr("°", `_以Excel統一座標的格式`) + 1,
                                   regexpr("'", `_以Excel統一座標的格式`) - 1))/60)
              ][regexpr('s', `_以Excel統一座標的格式`) > 0,
                latitude := latitude +
                  (as.numeric(substr(`_以Excel統一座標的格式`,
                                     regexpr("'", `_以Excel統一座標的格式`) + 1,
                                     regexpr('s', `_以Excel統一座標的格式`) - 1))/3600)
              ]








