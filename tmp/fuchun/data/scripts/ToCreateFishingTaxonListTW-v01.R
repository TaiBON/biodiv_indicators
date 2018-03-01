pkgs <- c('data.table')
install.packages(pkgs)
library(data.table)


#### 取得來自漁業署漁業年報的漁獲分類群列表 ####

## 2013 漁業年報中的版本

# 


## 2016 漁業年報中的版本

# 自 pre-procesed 中匯入資料
FTXLFATW_2016 <- fread(file = "./pre-processed/FishingTaxonListFATW_2016_01.txt",
                       skip = 1, header = F, sep = "\t", stringsAsFactors = F,
                       encoding = "UTF-8")

# 擷取所需的欄位並為之命名
FTXLFATW_2016 <- FTXLFATW_2016[, c(1,2,4)]
names(FTXLFATW_2016) <- c('taxonID', 'vernacularName', 'scientificName')

# 將 scientificName 中的 " spp." 一律取代為 ""
FTXLFATW_2016[, scientificName := gsub(" spp.", replacement = "", scientificName)]

# 追加 year 欄位
FTXLFATW_2016[, year := 2016]

# 追加 rank 欄位
FTXLFATW_2016[, rank := ""]

# 將學名明確且單一之分類群的 rank 設為 species
FTXLFATW_2016[scientificName %like% " ", rank := "species"]

# 擷取出 scientificName 中為空值者
FTXLFATW_2016[scientificName == ""]



