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
14.2.2 Mean Trophic Level (MTL) and Fishing in Balance Index (FiB) Quantitative target for 2020: MTL and FiB values are maintained at the current level, and the data for constructing the index will be collected to compile Taiwan’s MTL and FiB indicators.
#### Aichi Biodiversity Targets
Target 6: By 2020, based on the maintenance of the ecosystem, all aquatic resources such as fish, invertebrates and aquatic plants can be managed and harvested in a sustainable and legal manner to avoid overfishing. In addition, the restoration plans and measures for targeted depleted fish species would be implemented, and the impact of fishing on threatened fish stocks and fragile ecosystems would be contained within safe ecological limits.
### Background
Fisheries scientist Daniel Pauly proposed the Mean Trophic Index (MTI) and the phenomenon of "fishing down marine food web" in 1998, which triggered many interesting discussions including a question to the meaning of the MTI trend: " The downward trend of MTI may be irrelevant with the growth and decline of the top level consumer groups in the ecosystem, but rather reflect the fishery policy of the managers tending to catch the species in the bottom of the food web with large populations to achieve higher total catch." Pauly responded formally to this doubt in his 2005 publication, stating the situation is probable, and stressing that if such policies exist, efforts should be made toward reducing energy (or biomass) waste. In other words, the decline in MTI should be accompanied by the increase in catch, and the sum of the two changes should be balanced, which means that the management of fishery resources develops in the direction of sustainable way.
### Definition and Calculation
First we set the base year 0, and use its catch and MTI as the comparison standard. It is expressed as: $$ F_iB=log\Big[Y_i\Big(\frac{1}{TE}\Big)^{TL_i}\Big]-log\Big[Y_0(\frac{1}{TE})^{TL_0}\Big] $$
* $Y_i= total catch in i$ year
* $Y_0=$ total catch in the base year
* $MTI_i= Mean Trophic Index of year i$
* $MTI_0=$ Mean Tropic index in the base year
* $TE=$ transfer efficiency between trophic levels of the food web
* $F_iB_i= fishing-in-balance index of year i$

To help readers understand the equation, we hypothesize that the transfer efficiency is 0.1 and convert it into the following form： $$ FiB_i = log\Big(\frac{Y_i}{Y_0}\Big) + (MTI_i-MTI_0) $$ The annual MTI change from the standard year is -1 (for example, from 4 to 3), which means that the fishing target in the food web has dropped by one level. Since the fishing target is transferred to the lower part of the food web with larger populations, the yield of catch in year i (Yi) should be greater than the standard year (Y0); if we assumed that the trophic level efficiency can be fully reflected in the biomass change, the ratio between Yi and Y0 should be 10, and the logarithm of dividing the two will get 1. Then FiB = 1 + (-1) = 0. It is worth mentioning that when the yield of catch and MTI in year i are maintained at the standard year level, FiB will still be zero. If this state is maintained continuously, that is, FiB is always zero, which is the ideal "balanced" or "sustainable" fishery state.

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