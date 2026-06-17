# I.05 "Fishing-in-balance index"

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Brief Description
The index is used to estimate whether the fish landings at all levels are balanced.
### Themes
Fishery resources
### PSBR Model Type
狀態（S）
### Corresponding Targets
#### 永續發展目標
目標 14.2.2：平均營養位階（MTL）及漁獲平衡指數（FiB）<br> 2020 年量化目標：MTL值及FiB值維持現有水準，另蒐集建構指數編制資料，俾自行編制我國之MTL及FiB指標。<br>
#### 昆–蒙目標
目標 10：確保農業、水產養殖、漁業與林業能永續地經營管理，特別是透過永續地利用生物多樣性資源，包括大幅度應用生物多樣性友善作法，例如以永續集約化、農業生態學及其他創新方法來增強前述生產系統的韌性、長期效率與生產力，進而促進糧食安全並保護、復育生物多樣性，以維持自然對人類的貢獻，包括生態系功能與服務。<br>
#### 愛知目標
目標 6：到 2020 年，所有魚類、無脊椎動物和水生植物等水產資源都能以維護生態系統為基礎，並以永續、合法的方式進行捕撈及管理，避免過漁現象；另外針對所有枯竭的魚種執行復原計畫及措施，並將漁撈對受威脅的魚群和脆弱生態系的影響控制在安全的生態限度內。<br>
### Background
漁業學家 Daniel Pauly 於 1998 年提出平均營養指數（Mean Trophic Index, MTI）及「漁獲物種漸趨海洋食物網底層（fishing down marine food wed）」現象後，觸發許多有趣的討論，包括一項對 MTI 趨勢意涵的質疑：「MTI 趨勢向下，可能與生態系中高階消費者的族群消長無關，而是反映管理者的漁業政策傾向捕撈族群量較大的食物網底層以獲取較高的整體漁獲量。」 Pauly 於 2005 年的發表中正式回應此疑慮，表明此情況確有可能存在，並強調此類政策若是存在，應朝減少能量（或生物量）浪費的方向努力。換言之，MTI 的下降應伴隨漁獲量的上升，且兩者變動量的總和應趨於平衡，才表示對漁業資源的管理是朝永續漁業的方向發展。
### Definition and Calculation
First we set the baseline year, and use its fish landings and MTI as the comparison standard. It is expressed as: $$ F_iB=log\Big[Y_i\Big(\frac{1}{TE}\Big)^{TL_i}\Big]-log\Big[Y_0(\frac{1}{TE})^{TL_0}\Big] $$
* $Y_i= total fish landings in i$ year
* $Y_0=$ total fish landings in the baseline year
* $MTI_i= Mean Trophic Index of year i$
* $MTI_0=$ Mean Tropic index of the baseline year
* $TE=$ energy transfer efficiency among trophic levels of the food web
* $F_iB_i= fishing-in-balance index of year i$

為幫助讀者理解，我們假設能量轉換率為 0.1，並將其轉成以下形式： $$ FiB_i = log\Big(\frac{Y_i}{Y_0}\Big) + (MTI_i - MTI_0) $$ 設想 i 年的 MTI 較之基準年變化量為 -1（如從 4 降至 3），也就是捕撈對象在食物網中整整下降了一個層級。由於捕撈對象轉至族群量較大的食物網下層，i 年的漁獲量（Y<sub>i</sub>）應大於基準年（Y<sub>0</sub>）；若假設能量轉換率可完全反映在生物量變化上，Y<sub>i</sub> 和 Y<sub>0</sub> 的差距應該會是 10 倍，兩者相除取對數將得到 1。於是 FiB = 1 + (-1) = 0。值得強調的是，當 i 年的漁獲量、MTI 皆維持在基準年水平，FiB 仍會是 0。若此狀態持續維持，也就是 FiB 始終為 0，即理想的「平衡」或「永續」漁業狀態。

The rise and fall of the FiB trend sometimes lead to a debate of "encouraging to catch more tertiary or primary consumers", which can be the wrong direction for discussion. In fact, there are a variety of factors that lead to the fluctuation of FiB:

FiB < 0. It may be because the increase in the fish landings in year i is less than the decrease in MTI, or the decrease in the fish landings in year i is greater than the increase in MTI. The former may be due to the fact that part of the fish landings is not included in the fishery statistic data (such as discarded catch), or fishery has taken more organisms from the marine ecosystem than what the ecosystem can recover from under normal function; the latter may reflect that fisheries tend to catch teritary consumers, which leads to lower fish landings.

FiB > 0. It may be because the increase in the fish landings in year i is greater than the decrease in MTI, or the decrease in the fish landings in year i is less than the increase in MTI. Other possible causes include the migration of foreign populations (such as the migration of new tuna populations into the sea area of Taiwan), the expansion of fishing grounds, and the increase of basic productivity in the regions (such as environmental eutrophication).

When FiB keeps deviating from the balanced state, especially when FiB keeps decreasing, it is the management methods that are insufficient to maintain fishery resources at a sustainable level. As for a clearer policy direction for improvement, the designs and monitorings in many aspects are needed to be sovled.
### Updates
資料來源為 Sea Around Us 中之 Region-based Marine Trophic Index of the catch in the waters of Taiwan，過去資料僅到 2014 年，目前已更新到 2016 年。 臺灣 2016 年的漁獲平衡指數（FiB）為 2.68。
### Trends
### 資料管理／權責單位
Fisheries Agency, Council of Agriculture
### 資料來源／網站連結
[Sea Around Us 網站](http://www.seaaroundus.org/)
