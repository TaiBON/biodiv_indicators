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

The rise and fall of the FiB trend sometimes lead to a "encourage more tertiary or primary consumers" debate, which can be the wrong direction for discussion. In fact, there are a variety of factors that lead to the fluctuation of FiB：

FiB < 0. It may be caused by the increase in the yield of catch in year i is less than the decrease in MTI, or the decrease in the yield of catch in year i is greater than the increase in MTI. The former may be due to the fact that part of the catch is not included in the fishery statistic data (such as discards), or the use of the biomass that fishery used in the marine ecosystem has exceeded the extent that the ecosystem can function normally; the latter may reflect the tendency of fisheries fishing for teritary consumers leads to lower catches.

FiB > 0. It may be caused by the increase in the yield of catch in year i is greater than the decrease in MTI, or the decrease in the catch in year i is less than the increase in MTI. Other possible causes include the migration of foreign populations (such as the migration of new tuna populations into the sea area of Taiwan), the expansion of fishing grounds, and the increase of basic productivity in regions (such as environmental eutrophication).

When FiB keeps deviating from the equilibrium state, especially when FiB keeps decreasing, it is the management methods that are insufficient to maintain fishery resources at a sustainable level. As for a clearer policy direction for improvement, the designs and monitorings in many aspects are needed to find answers.
### Updates
The data until 2014 is from the Region-based Marine Trophic Index of the catch in the waters of Taiwan in the website "Sea Around Us".
### Trends
### Data Management Authorities
Fisheries Agency, Council of Agriculture
### Data Source/URL
[The website of "Sea Around Us"](http://www.seaaroundus.org/)