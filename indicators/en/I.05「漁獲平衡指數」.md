# I.05 Fishing-in-balance index

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

## Brief description
The FiB index is used to estimate whether the fishery catches at all levels are balanced.

### Themes
Fishery resources
### PSBR model type
State(S)
### Corresponding targets
#### SDGs
14.2.2 Mean Trophic Level (MTL) and Fishing in Balance Index (FiB) Quantitative target for 2020：MTL and FiB values are maintained at the current level, and data for constructing the index will be collected to compile Taiwan’s MTL and FiB indicators.
#### Aichi Biodiversity Targets
Target 6: By 2020, based on the maintenance of the ecosystem, all aquatic resources such as fish, invertebrates and aquatic plants can be managed and harvested in a sustainable and legal manner to avoid overfishing. In addition, the restoration plans and measures for targeted depleted fish species would be implemented, and the impact of fishing on threatened fish stocks and fragile ecosystems would be contained within safe ecological limits.
### Background
漁業學家 Daniel Pauly 於 1998 年提出平均營養指數 (Mean Trophic Index, MTI) 及「漁獲物種漸趨海洋食物網底層 (fishing down marine food wed)」現象後，觸發許多有趣的討論，包括一項對 MTI 趨勢意涵的質疑：「MTI 趨勢向下，可能與生態系中高階消費者的族群消長無關，而是反映管理者的漁業政策傾向捕撈族群量較大的食物網底層以獲取較高的整體漁獲量。」 Pauly 於 2005 年的發表中正式回應此疑慮，表明此情況確有可能存在，並強調此類政策若是存在，應朝減少能量（或生物量）浪費的方向努力。換言之，MTI 的下降應伴隨漁獲量的上升，且兩者變動量的總和應趨於平衡，才表示對漁業資源的管理是朝永續漁業的方向發展。
### Definition and Calculation
先訂出基準年，以其漁獲量和 MTI 為比較標準。以數學式表示為： $$ F_iB=log\Big[Y_i\Big(\frac{1}{TE}\Big)^{TL_i}\Big]-log\Big[Y_0(\frac{1}{TE})^{TL_0}\Big] $$
* $Y_i= total yield of catch in i$ year
* $Y_0=$ total yield of catch in the standard year
* $MTI_i= Mean Trophic Index (MTI) of i$ years
* $MTI_0=$ Mean Tropic Index (MTI) index in the standard year
* $TE=$ Trophic level transfer efficiency between trophic levels of the food web
* $F_iB_i= i$ year fishing-in-balance index

為幫助讀者理解，我們假設能量轉換率為 0.1，並將其轉成以下形式： $$ FiB_i = log\Big(\frac{Y_i}{Y_0}\Big) + (MTI_i - MTI_0) $$ 設想 i 年的 MTI 較之基準年變化量為 -1（如從 4 降至 3），也就是捕撈對象在食物網中整整下降了一個層級。由於捕撈對象轉至族群量較大的食物網下層，i 年的漁獲量 (Yi) 應大於基準年 (Y0)；若假設能量轉換率可完全反映在生物量變化上，Yi 和 Y0 的差距應該會是 10 倍，兩者相除取對數將得到 1。於是 FiB = 1 + (-1) = 0。值得強調的是，當 i 年的漁獲量、MTI 皆維持在基準年水平，FiB 仍會是 0。若此狀態持續維持，也就是 FiB 始終為 0，即理想的「平衡」或「永續」漁業狀態。

FiB 趨勢的上升、下降有時會被導向純然的「鼓勵多補高階或低階消費者」爭論中，這可能是一種錯誤的討論方向。事實上導致其上升、下降的因素有多種：

當 FiB < 0，可能是 i 年漁獲量之增長小於 MTI 下降的程度，或 i 年漁獲量之減少大於 MTI 上升的程度。前者可能源於部分漁獲並未包含在漁業統計資料中（如棄獲），或漁業對海洋生態系中生物量的取用已超出生態系功能可正常運作的程度；後者則可能反映由於漁業傾向捕撈高階消費者而導致漁獲量降低。

當 FiB > 0，可能是 i 年漁獲量之增長大於 MTI 下降的程度，或 i 年漁獲量之減少小於 MTI 上升的程度。可能成因包括外來族群的移入（如新的鮪魚族群移入臺灣海域）、漁場範圍的擴張、區域內基礎生產力的上升（如環境優氧化）等。

故當 FiB 持續偏離平衡狀態，特別是當 FiB 持續下降，僅是點出現有管理方式不足以讓漁業資源維持在永續經營的水平上。至於政策上更明確的改善方向，需更多層面的設計與監測才可能找到解答。
### Updates
資料來源為 Sea Around Us 中之 Region-based Marine Trophic Index of the catch in the waters of Taiwan，資料僅到2014年。
### Trends
### Data Management Authorities
漁業署
### Data Source/URL
[Sea Around Us網站](http://www.seaaroundus.org/)