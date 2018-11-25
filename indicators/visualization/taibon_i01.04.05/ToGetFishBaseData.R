getwd()

install.packages("rvest")
library(rvest)
library(data.table)

## 請先準備好所需的分類群名錄，步驟如下：
## (1) 學名比對清理 (請確定名錄中的學名在 FishBase 上皆為有效名)
## (2) 在 R Script 所在的路徑產生一個叫 data 的資料夾
## (3) 將分類群名錄的檔名取為 TaxonLists.txt，內容以 TAB 分隔
## (4) 將 TaxonLists.txt 置於 data 底下


#### 導入分類群名錄

TaxonLists <- fread(file = 'data/TaxonLists.txt', header = TRUE,
                    sep = "\t", stringsAsFactors = FALSE,
                    encoding = "UTF-8")

#### 產生屬和種小名的欄位
TaxonLists[, genus := strsplit(scientificNameChecked, " ")[[1]][1], by = taxonID]
TaxonLists[, specificEpithet := strsplit(scientificNameChecked, " ")[[1]][2], by = taxonID]


#### 產生一個 URL 總表

urlHead <- "http://fishbase.org/summary/"
urlTail <- ".html"

TaxonUrlLists <- NULL

for(i in c(1:nrow(TaxonLists))) {
  TaxonUrlLists[i] <-
    paste(urlHead, TaxonLists[i,5], "-",
          TaxonLists[i,6], urlTail, sep = "")
}


#### 自 FishBase 下載 TL 資料

TaxonTLs <- NULL

for(i in c(1:nrow(TaxonLists))) {
  page <- read_html(TaxonUrlLists[i])
  data <- html_node(page, ".smallSpace .smallSpace:nth-child(3)")
  TaxonTLs[i] <- html_text(data)
  
  if(nchar(TaxonUrlLists[i]) < 37) {
    # nchar("\r\n\t\t\t\t\tTrophic Level  (Ref. 69278):  ") = 37
    data <- html_node(page, ".smallSpace .smallSpace .smallSpace:nth-child(1)")
    TaxonTLs[i] <- html_text(data)
  }
}


#### 將所下載到的 TL 資料清出來並與 TaxonLists 合併

TL <- substr(TaxonTLs, start = 38, stop = 40)
TaxonLists <- cbind(TaxonLists, trophicLevel = TL)

fwrite(TaxonLists, file = 'TaxonTLs.txt', sep = "\t")

