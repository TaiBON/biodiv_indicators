pkgs <- c('data.table')
install.packages(pkgs)
library(data.table)



#### 取得來自漁業署漁業年報的漁獲分類群列表 ####


## 2013 漁業年報中的版本

# 自 pre-procesed 中匯入資料
FTXL_FATW_2013 <- fread(file = "./pre-processed/FishingTaxonList_FATW_2013_01.txt",
                        skip = 1, header = F, sep = "\t", stringsAsFactors = F,
                        encoding = "UTF-8")

# 擷取所需的欄位並為之命名
FTXL_FATW_2013 <- FTXL_FATW_2013[, c(1,2,4)]
names(FTXL_FATW_2013) <- c('taxonID', 'vernacularName', 'scientificName')

# 將 scientificName 中的 "sp." 或 "spp." 一律取代為 ""
FTXL_FATW_2013[, scientificName := gsub(" sp.| spp.", replacement = "", scientificName)]
#
FTXL_FATW_2013[, scientificName := gsub(" (?", replacement = "", scientificName)]


## 2016 漁業年報中的版本

# 自 pre-procesed 中匯入資料
FTXL_FATW_2016 <- fread(file = "./pre-processed/FishingTaxonList_FATW_2016_01.txt",
                       skip = 1, header = F, sep = "\t", stringsAsFactors = F,
                       encoding = "UTF-8")

# 擷取所需的欄位並為之命名
FTXL_FATW_2016 <- FTXL_FATW_2016[, c(1,2,4)]
names(FTXL_FATW_2016) <- c('taxonID', 'vernacularName', 'scientificName')

# 將 scientificName 中的 "sp." 或 "spp." 一律取代為 ""
FTXL_FATW_2016[, scientificName := gsub(" sp.| spp.", replacement = "", scientificName)]

# 將 scientificName 中以中文頓號 (、) 分隔的方式改為以 "|" 分隔
FTXL_FATW_2016[, scientificName := gsub("、|、 | 、", replacement = "|", scientificName)]

# 新增 taxonRank 欄位並將學名明確且單一之分類群的 taxonRank 設為 species
FTXL_FATW_2016[scientificName %like% " ", taxonRank := "species"]
# 將帶有 "var." 之分類群的 taxonRank 設為 variety
FTXL_FATW_2016[scientificName %like% "var.", taxonRank := "variety"]
# 將學名以 "idae"、"aceae" 結尾之分類群的 taxonRank 設為 family
FTXL_FATW_2016[scientificName %like% "dae$|eae$", taxonRank := "family"]
# 將學名以 "formes" 結尾之分類群的 taxonRank 設為 order
FTXL_FATW_2016[scientificName %like% "formes$", taxonRank := "order"]

# 將已完成和未完成 (只能以人工) taxonRank 判定的 taxa 分離出來
FTXL_FATW_2016_A <- FTXL_FATW_2016[!is.na(taxonRank)]
FTXL_FATW_2016_B <- FTXL_FATW_2016[is.na(taxonRank)][order(scientificName)]

# 將必須進行人工判定 taxonRank 的 taxa 匯出做處理
fwrite(FTXL_FATW_2016_B, file = "./in-process/FTXL_FATW_2016_B.txt", sep = "\t")
# 處理完畢後再匯入
FTXL_FATW_2016_B <- fread(file = "./in-process/FTXL_FATW_2016_B.txt", header = T,
                         sep = "\t", stringsAsFactors = F,
                         encoding = "UTF-8")

# 將被分割的表單重新合併
FTXL_FATW_2016 <- rbind(FTXL_FATW_2016_A, FTXL_FATW_2016_B)

# 追加 year 欄位
FTXL_FATW_2016[, year := 2016]




