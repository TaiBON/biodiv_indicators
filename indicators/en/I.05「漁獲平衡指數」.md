# I.05 Fishing-in-balance index

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Themes
Fishery resources
### PSBR model type
State(S)
### Corresponding targets
#### SDGs
14.2.2 平均營養位階(MTL)及漁獲平衡指數(FiB) 2020年量化目標：MTL值及FiB值維持現有水準，另蒐集建構指數編制資料，俾自行編制我國之MTL及FiB指標。
#### Aichi Biodiversity Targets
Target 6 By 2020 all fish and invertebrate stocks and aquatic plants are managed and harvested sustainably, legally and applying ecosystem based approaches, so that overfishing is avoided, recovery plans and measures are in place for all depleted species, fisheries have no significant adverse impacts on threatened species and vulnerable ecosystems and the impacts of fisheries on stocks, species and ecosystems are within safe ecological limits.
### Background
Fisheries scientist Daniel Pauly proposed the Mean Trophic Index (MTI) and " fishing down marine food web" in 1998, which triggered many interesting discussions including a question to the meaning of the MTI trend：" The downward trend of MTI may irrelevant with the growth and decline of the tertiary consumer groups in the ecosystem, but reflect the fishery policy of the managers tend to fish the species in the bottom of the food web with large populations to enhance the yield of catch." Pauly responded formally to this doubt in his 2005 publication to state the situation is possible. Also, he emphasized that if such policies exist, efforts should be made to reduce energy (or biomass) waste. In other words, the decline in MTI should be accompanied by the increase in yield of catch, and the sum of the two changes should be balanced, which means that the management of fishery resources is developing in the direction of sustainable fisheries.
### Definition and Calculation
Setting the standard year and use the yield of catch and MTI as comparison standard. The formula is ： $$ F_iB=log(Y_i(\frac{1}{TE})^{TL_i}-log(Y_0(\frac{1}{TE})^{TL_0}) $$
* $Y_i= total yield of catch in i$ year
* $Y_0=$ total yield of catch in the standard year
* $MTI_i= Mean Trophic Index (MTI) of i$ years
* $MTI_0=$ Mean Tropic Index (MTI) index in the standard year
* $TE=$ Trophic level transfer efficiency between trophic levels of the food web
* $F_iB_i= i$ year fishing-in-balance index

To help readers understand the equation, we assume that the trophic level efficiency is 0.1 and convert it into the following form： $$ FiB_i = log\Big(\frac{Y_i}{Y_0}\Big) + (MTI_i-MTI_0) $$ The annual MTI change from the standard year is -1 (for example, from 4 to 3), which means that the fishing target in the food web has dropped by one level. Since the fishing target is transferred to the lower part of the food web with larger populations, the yield of catch in year i (Yi) should be greater than the standard year (Y0); if we assumed that the trophic level efficiency can be fully reflected in the biomass change, the ratio between Yi and Y0 should be 10, and the logarithm of dividing the two will get 1. Then FiB = 1 + (-1) = 0. It is worth mentioning that when the yield of catch and MTI in year i are maintained at the standard year level, FiB will still be zero. If this state is maintained continuously, that is, FiB is always zero, which is the ideal "balanced" or "sustainable" fishery state.

The rise and fall of the FiB trend sometimes lead to a "encourage more tertiary or primary consumers" debate, which can be the wrong direction for discussion. In fact, there are a variety of factors that lead to the fluctuation of FiB：

FiB < 0. It may be caused by the increase in the yield of catch in year i is less than the decrease in MTI, or the decrease in the yield of catch in year i is greater than the increase in MTI. The former may be due to the fact that part of the catch is not included in the fishery statistic data (such as discards), or the use of the biomass that fishery used in the marine ecosystem has exceeded the extent that the ecosystem can function normally; the latter may reflect the tendency of fisheries fishing for teritary consumers leads to lower catches.

FiB > 0. It may be caused by the increase in the yield of catch in year i is greater than the decrease in MTI, or the decrease in the catch in year i is less than the increase in MTI. Other possible causes include the migration of foreign populations (such as the migration of new tuna populations into the sea area of Taiwan), the expansion of fishing grounds, and the increase of basic productivity in regions (such as environmental eutrophication).

故當 FiB 持續偏離平衡狀態，特別是當 FiB 持續下降，僅是點出現有管理方式不足以讓漁業資源維持在永續經營的水平上。至於政策上更明確的改善方向，需更多層面的設計與監測才可能找到解答。
### Updates
資料來源為 Sea Around Us中之Region-based Marine Trophic Index of the catch in the waters of Taiwan，資料僅到2014年。
### Trends
### Data Management Authorities
Fisheries Agency, Council of Agriculture
### Data Source/URL
[Website of Sea Around Us](http://www.seaaroundus.org/)