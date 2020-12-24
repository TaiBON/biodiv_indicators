# I.05 "Fishing-in-balance index"

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

## Brief description
The index is used to estimate whether the fish landings at all levels are balanced.
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
Fisheries scientist Daniel Pauly proposed the Mean Trophic Index (MTI) and the phenomenon of "fishing down marine food web" in 1998, which triggered many interesting discussions including an argument against the interpretation of the MTI trend: "The downward trend of MTI may be irrelevant to the decline of the top-level consumer populations in the ecosystem, but rather reflect the fishery policy of the managers tending to catch the species at the bottom of the food web with large populations to achieve higher total fish landings." Pauly responded formally to this argument in his 2005 publication, stating that the situation is probable and emphasizing that if such policies exist, efforts should be made toward reducing energy (or biomass) waste. In other words, the decline in MTI should be accompanied by the increase in fish landings, and the sum of the two changes should be balanced, in that way, the management of fishery resources is developing towards sustainability.
### Definition and Calculation
First we set the baseline year, and use its fish landings and MTI as the comparison standard. It is expressed as: $$ F_iB=log\Big[Y_i\Big(\frac{1}{TE}\Big)^{TL_i}\Big]-log\Big[Y_0(\frac{1}{TE})^{TL_0}\Big] $$
* $Y_i= total fish landings in i$ year
* $Y_0=$ total fish landings in the baseline year
* $MTI_i= Mean Trophic Index of year i$
* $MTI_0=$ Mean Tropic index of the baseline year
* $TE=$ energy transfer efficiency among trophic levels of the food web
* $F_iB_i= fishing-in-balance index of year i$

To help readers understand the equation, we hypothesize that the energy transfer efficiency is 0.1 and convert the equation into the following form: $$ FiB_i = log\Big(\frac{Y_i}{Y_0}\Big) + (MTI_i-MTI_0) $$ The annual MTI change from the baseline year is -1 (for example, from 4 to 3), which means that the fishing targets in the food web have dropped by one level. Since the fishing targets are transferred to the speices with larger populations in the lower level of the food web, the fish landings in year i (Yi) should be greater than the baseline year (Y0); if we assumed that the energy transfer efficiency can be fully reflected in the biomass change, the ratio between Yi and Y0 should be 10, and the logarithm of dividing the two will be 1. Then FiB = 1 + (-1) = 0. It is worth mentioning that when the fish landings and MTI in year i are maintained at the level of baseline year, FiB will still be zero. If this state is maintained continuously, i. e., FiB is always zero, the ideal "balanced" or "sustainable" fishery state is reached.

The rise and fall of the FiB trend sometimes lead to a debate of "encouraging to catch more tertiary or primary consumers", which can be the wrong direction for discussion. In fact, there are a variety of factors that lead to the fluctuation of FiB:

FiB < 0. It may be because the increase in the fish landings in year i is less than the decrease in MTI, or the decrease in the fish landings in year i is greater than the increase in MTI. The former may be due to the fact that part of the fish landings is not included in the fishery statistic data (such as discarded catch), or fishery has taken more organisms from the marine ecosystem than what the ecosystem can recover from under normal function; the latter may reflect that fisheries tend to catch teritary consumers, which leads to lower fish landings.

FiB > 0. It may be because the increase in the fish landings in year i is greater than the decrease in MTI, or the decrease in the fish landings in year i is less than the increase in MTI. Other possible causes include the migration of foreign populations (such as the migration of new tuna populations into the sea area of Taiwan), the expansion of fishing grounds, and the increase of basic productivity in the regions (such as environmental eutrophication).

When FiB keeps deviating from the balanced state, especially when FiB keeps decreasing, it is the management methods that are insufficient to maintain fishery resources at a sustainable level. As for a clearer policy direction for improvement, the designs and monitorings in many aspects are needed to be sovled.
### Updates
資料來源為 Sea Around Us中之Region-based Marine Trophic Index of the catch in the waters of Taiwan，過去資料僅到2014年，目前已更新到2016年。 臺灣2016年的漁獲平衡指數(FiB)為2.68。
### Trends
### Data Management Authorities
Fisheries Agency, Council of Agriculture
### Data Source/URL
[The website of "Sea Around Us"](http://www.seaaroundus.org/)